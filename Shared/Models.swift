//
//  Models.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

enum MTRStation: String {
    case northPoint     = "NOP"
    case quarryBay      = "QUB"
    case yauTong        = "YAT"
    case tiuKengLeng    = "TIK"
    case tseungKwanO    = "TKO"
    case hangHau        = "HAH"
    case poLam          = "POA"
    case lohasPark      = "LHP"

    var name: String {
        switch self {
        case .northPoint:   return "北角"
        case .quarryBay:    return "鰂魚涌"
        case .yauTong:      return "油塘"
        case .tiuKengLeng:  return "調景嶺"
        case .tseungKwanO:  return "將軍澳"
        case .hangHau:      return "坑口"
        case .poLam:        return "寶琳"
        case .lohasPark:    return "康城"
        }
    }
}

enum MTRLine: String, CaseIterable {
    case tseungKwanOLine = "TKL"
}

extension MTRLine {
    enum Direction: String, CaseIterable {
        case up     = "UP"
        case down   = "DOWN"
    }

    var name: String {
        switch self {
        case .tseungKwanOLine:
            return "將軍澳綫"
        }
    }

    var allStations: [MTRStation] {
        return getAllStations(of: self)
    }

    var allLineStations: [MTRLineStation] {
        return getAllStations(of: self).map { MTRLineStation(line: self, verifiedStation: $0) }
    }

    func destinationName(for direction: Direction, withRoutingWord: Bool = false) -> String {
        switch self {
        case .tseungKwanOLine:
            switch direction {
            case .up:   return withRoutingWord ? "往寶琳/康城" : "寶琳/康城"
            case .down: return withRoutingWord ? "往北角" : "北角"
            }
        }
    }
}


private func getAllStations(of line: MTRLine) -> [MTRStation] {
    switch line {
    case .tseungKwanOLine:
        return [.northPoint, .quarryBay, .yauTong, .tiuKengLeng, .tseungKwanO, .hangHau, .poLam, .lohasPark]
    }
}


struct MTRLineStation {
    let line: MTRLine
    let station: MTRStation
    init?(line: MTRLine, station: MTRStation) {
        guard getAllStations(of: line).contains(station) else { return nil }
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


struct DepartureInfo {
    let destinationCode: String
    let timestamp: TimeInterval

    var destination: MTRStation? {
        return MTRStation(rawValue: destinationCode)
    }
}


// codable
extension MTRLine.Direction: Codable {}
extension MTRLine: Codable {}
extension MTRStation: Codable {}
extension MTRLineStation: Codable {}
