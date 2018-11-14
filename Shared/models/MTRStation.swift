//
//  MTRStation.swift
//  Departure Board
//
//  Created by Cat Jia on 14/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

struct MTRStation {
    let code: MTRStationCode
    let lineCode: MTRLineCode

    private init?(lineCode: MTRLineCode, stationCode: MTRStationCode) {
        guard MTRLine.withCode(lineCode).stations.contains(where: { $0.code == stationCode }) else { return nil }
        self.code = stationCode
        self.lineCode = lineCode
    }

    init(line: MTRLineCode, verifiedStationCode: MTRStationCode) {
        self.code = verifiedStationCode
        self.lineCode = line
    }
}

extension MTRStation: RawRepresentable {
    typealias RawValue = String
    init?(rawValue: String) {
        let codes = rawValue.components(separatedBy: "-")
        guard codes.count == 2, let lineCode = MTRLineCode(rawValue: codes[0]), let stationCode = MTRStationCode(rawValue: codes[1]) else { return nil }
        self.init(lineCode: lineCode, stationCode: stationCode)
    }

    var rawValue: String {
        return [lineCode.rawValue, code.rawValue].joined(separator: "-")
    }
}

extension MTRStation {
    var name: String {
        return self.code.name
    }
}

extension MTRStation: Equatable, Codable {}


// MARK: -
extension MTRStation {
    var availableDirections: [MTRLine.Direction] {
        if let endStationDirection = lineCode.endStations[code] {
            return [endStationDirection]
        }
        return MTRLine.Direction.allCases
    }
}

extension MTRLineCode {
    var endStations: [MTRStationCode: MTRLine.Direction] {
        switch self {
        case .TKL:
            return [
                .northPoint: .up,
                .lohasPark: .down,
                .poLam: .down,
            ]

        case .WRL:
            return [
                .hungHom: .up,
                .tuenMun: .down,
            ]
        }
    }
}
