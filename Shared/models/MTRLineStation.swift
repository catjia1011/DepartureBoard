//
//  MTRLineStation.swift
//  Departure Board
//
//  Created by Cat Jia on 14/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

struct MTRLineStation {
    let line: MTRLineCode
    let station: MTRStationCode
    private init?(line: MTRLineCode, station: MTRStationCode) {
        guard allStationsForLine(line).contains(station) else { return nil }
        self.line = line
        self.station = station
    }

    fileprivate init(line: MTRLineCode, verifiedStation: MTRStationCode) {
        self.line = line
        self.station = verifiedStation
    }
}

extension MTRLineStation: RawRepresentable {
    typealias RawValue = String
    init?(rawValue: String) {
        let codes = rawValue.components(separatedBy: "-")
        guard codes.count == 2, let line = MTRLineCode(rawValue: codes[0]), let station = MTRStationCode(rawValue: codes[1]) else { return nil }
        self.init(line: line, station: station)
    }

    var rawValue: String {
        return [line.rawValue, station.rawValue].joined(separator: "-")
    }
}

extension MTRLineStation: Codable {}


// MARK: -
extension MTRLineStation {
    var availableDirections: [MTRLineCode.Direction] {
        if let endStationDirection = line.endStations[station] {
            return [endStationDirection]
        }
        return MTRLineCode.Direction.allCases
    }
}

extension MTRLineCode {
    var endStations: [MTRStationCode: MTRLineCode.Direction] {
        switch self {
        case .tseungKwanOLine:
            return [
                .northPoint: .up,
                .lohasPark: .down,
                .poLam: .down,
            ]

        case .westRainLine:
            return [
                .hungHom: .up,
                .tuenMun: .down,
            ]
        }
    }

    var allLineStations: [MTRLineStation] {
        guard let result = lineToLineStationsMap[self] else {
            assertionFailure("unexpected") // won't happen; will checked by compiler for `allStationsForLine(_:)`
            return []
        }
        return result
    }
}


private func allStationsForLine(_ line: MTRLineCode) -> [MTRStationCode] {
    switch line {
    case .tseungKwanOLine:
        return [.northPoint, .quarryBay, .yauTong, .tiuKengLeng, .tseungKwanO, .hangHau, .poLam, .lohasPark]

    case .westRainLine:
        return [.hungHom, .eastTsimShaTsui, .austin, .namCheong, .meiFoo, .tsuenWanWest, .kamSheungRoad, .yuenLong, .longPing, .tinShuiWai, .siuHong, .tuenMun]
    }
}

private let lineToLineStationsMap: [MTRLineCode: [MTRLineStation]] = {
    var dict = [MTRLineCode: [MTRLineStation]]()
    for line in MTRLineCode.allCases {
        let stations = allStationsForLine(line)
        dict[line] = stations.map { MTRLineStation(line: line, verifiedStation: $0) }
    }
    return dict
}()
