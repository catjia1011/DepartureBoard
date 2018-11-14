//
//  APIClient.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit
import SwiftyJSON

private let BASE_URL = "http://ctka.me/api/departure.php"
private let LANGUAGE = "zh"

enum CustomError: Error {
    case unknown
    case unexpectedData
    case withServerInfo(Error, [String: Any])
}

class APIClient {
    static let shared = APIClient()
    private init() {}

    @discardableResult
    private func requestDictionary(url: URL, completion: @escaping (Result<[String: Any]>) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(error ?? CustomError.unknown))
                    return
                }

                let json = JSON(data)
                let optionalDict = json.dictionaryObject

                if let error = error {
                    if let dict = optionalDict {
                        completion(.failure(CustomError.withServerInfo(error, dict)))
                    } else {
                        completion(.failure(error))
                    }
                    return
                }

                guard let dict = optionalDict else {
                    completion(.failure(CustomError.unexpectedData))
                    return
                }

                completion(.success(dict))
            }
        }
        dataTask.resume()
        return dataTask
    }
}


extension APIClient {
    func request(lineStation: MTRLineStation, direction: MTRLineCode.Direction, completion: @escaping (Result<[DepartureInfo]>) -> Void) {
        let originalUrl: URL = {
            let queries: [String: String] = [
                "line": lineStation.line.rawValue,
                "station": lineStation.station.rawValue,
                "language": LANGUAGE,
            ]
            let queryString = queries.map { "\($0)=\($1)" }.joined(separator: "&")
            return URL(string: BASE_URL + "?" + queryString)!
        }()

        self.requestDictionary(url: originalUrl) { (urlResult) in
            switch urlResult {
            case .failure(let error):
                completion(.failure(error))

            case .success(let urlDict):
                guard let translated = urlDict["url"] as? String, let translatedUrl = URL(string: translated) else {
                    completion(.failure(CustomError.unexpectedData))
                    return
                }

                self.requestDictionary(url: translatedUrl) { (result) in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))

                    case .success(let dict):
                        let array = JSON(dict)["data"][lineStation.rawValue][direction.rawValue].arrayValue
                        let infoArray: [DepartureInfo] = array.compactMap {
                            guard let dest = $0["dest"].string, let time = $0["time"].string, let timestamp = apiResultDateFormatter.date(from: time)?.timeIntervalSince1970 else { return nil }
                            return DepartureInfo(destinationCode: dest, timestamp: timestamp)
                        }
                        completion(.success(infoArray))
                    }
                }
            }
        }
    }
}


private let apiResultDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone(identifier: "HKT")
    return formatter
}()

