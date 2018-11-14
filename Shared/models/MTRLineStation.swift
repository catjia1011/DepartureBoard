//
//  MTRLineStation.swift
//  Departure Board
//
//  Created by Cat Jia on 14/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

struct MTRLineStation {
    let line: MTRLine
    let station: MTRStation
    private init?(line: MTRLine, station: MTRStation) {
        guard allStationsForLine(line).contains(station) else { return nil }
        self.line = line
        self.station = station
    }

    fileprivate init(line: MTRLine, verifiedStation: MTRStation) {
        self.line = line
        self.station = verifiedStation
    }
}

extension MTRLineStation: RawRepresentable {
    typealias RawValue = String
    init?(rawValue: String) {
        let codes = rawValue.components(separatedBy: "-")
        guard codes.count == 2, let line = MTRLine(rawValue: codes[0]), let station = MTRStation(rawValue: codes[1]) else { return nil }
        self.init(line: line, station: station)
    }

    var rawValue: String {
        return [line.rawValue, station.rawValue].joined(separator: "-")
    }
}

extension MTRLineStation: Codable {}


// MARK: -
extension MTRLineStation {
    var availableDirections: [MTRLine.Direction] {
        if let endStationDirection = line.endStations[station] {
            return [endStationDirection]
        }
        return MTRLine.Direction.allCases
    }
}

extension MTRLine {
    var endStations: [MTRStation: MTRLine.Direction] {
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


private func allStationsForLine(_ line: MTRLine) -> [MTRStation] {
    switch line {
    case .tseungKwanOLine:
        return [.northPoint, .quarryBay, .yauTong, .tiuKengLeng, .tseungKwanO, .hangHau, .poLam, .lohasPark]

    case .westRainLine:
        return [.hungHom, .eastTsimShaTsui, .austin, .namCheong, .meiFoo, .tsuenWanWest, .kamSheungRoad, .yuenLong, .longPing, .tinShuiWai, .siuHong, .tuenMun]
    }
}

private let lineToLineStationsMap: [MTRLine: [MTRLineStation]] = {
    var dict = [MTRLine: [MTRLineStation]]()
    for line in MTRLine.allCases {
        let stations = allStationsForLine(line)
        dict[line] = stations.map { MTRLineStation(line: line, verifiedStation: $0) }
    }
    return dict
}()
