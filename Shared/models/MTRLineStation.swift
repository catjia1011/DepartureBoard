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
    init?(line: MTRLine, station: MTRStation) {
        guard line.allStations.contains(station) else { return nil }
        self.line = line
        self.station = station
    }

    fileprivate init(line: MTRLine, verifiedStation: MTRStation) {
        self.line = line
        self.station = verifiedStation
    }
}

extension MTRLineStation {
    var availableDirections: [MTRLine.Direction] {
        if let endStationDirection = line.endStations[station] {
            return [endStationDirection]
        }
        return MTRLine.Direction.allCases
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
extension MTRLine {
    var allLineStations: [MTRLineStation] {
        return self.allStations.map { MTRLineStation(line: self, verifiedStation: $0) }
    }
}
