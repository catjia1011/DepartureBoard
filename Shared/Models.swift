//
//  Models.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

enum TseungKwanOLineStation: String, CaseIterable {
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

enum MTRStation: Hashable {
    case tko(TseungKwanOLineStation)

    var name: String {
        switch self {
        case .tko(let station):
            return station.name
        }
    }
}

extension MTRStation: RawRepresentable {
    typealias RawValue = String
    init?(rawValue: String) {
        let codes = rawValue.components(separatedBy: "-")
        guard codes.count == 2 else { return nil }
        switch codes[0] {
        case "TKL":
            guard let tklStation = TseungKwanOLineStation(rawValue: codes[1]) else { return nil }
            self = .tko(tklStation)
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .tko(let station):
            return ["TKL", station.rawValue].joined(separator: "-")
        }
    }

    var lineCode: String {
        return self.rawValue.components(separatedBy: "-")[0]
    }

    var stationCode: String {
        return self.rawValue.components(separatedBy: "-")[1]
    }

    var lineStationCode: String {
        return [lineCode, stationCode].joined(separator: "-")
    }
}

enum MTRLineDirection: String {
    case up     = "UP"
    case down   = "DOWN"
}

struct DepartureInfo {
    let destinationCode: String
    let timestamp: TimeInterval

    var destinationName: String? {
        return TseungKwanOLineStation(rawValue: destinationCode)?.name
    }
}
