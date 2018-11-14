//
//  MTRLine.swift
//  Departure Board
//
//  Created by Cat Jia on 14/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

struct MTRLine {
    let code: MTRLineCode
    let stations: [MTRStation]

    private init(code lineCode: MTRLineCode, stationCodes: [MTRStationCode]) {
        self.code = lineCode
        self.stations = stationCodes.map { MTRStation(line: lineCode, verifiedStationCode: $0) }
    }

    // MARK: -
    static let tseungKwanOLine = MTRLine(code: .TKL, stationCodes: [.northPoint, .quarryBay, .yauTong, .tiuKengLeng, .tseungKwanO, .hangHau, .poLam, .lohasPark])

    static let westRainLine = MTRLine(code: .WRL, stationCodes: [.hungHom, .eastTsimShaTsui, .austin, .namCheong, .meiFoo, .tsuenWanWest, .kamSheungRoad, .yuenLong, .longPing, .tinShuiWai, .siuHong, .tuenMun])

    static let allLines: [MTRLine] = [.tseungKwanOLine, .westRainLine]
}


// MARK: -
extension MTRLine {
    static func withCode(_ lineCode: MTRLineCode) -> MTRLine {
        switch lineCode {
        case .TKL:
            return tseungKwanOLine
        case .WRL:
            return westRainLine
        }
    }
}


extension MTRLine {
    enum Direction: String, CaseIterable {
        case up     = "UP"
        case down   = "DOWN"
    }

    var name: String {
        return self.code.name
    }

    var color: UIColor {
        switch self.code {
        case .TKL:
            return UIColor(red: 125.0 / 255, green: 73.0 / 255, blue: 157.0 / 255, alpha: 1)
        case .WRL:
            return UIColor(red: 182.0 / 255, green: 0.0 / 255, blue: 141.0 / 255, alpha: 1)
        }
    }

    func destinationName(for direction: Direction, withRoutingWord: Bool = false) -> String {
        switch self.code {
        case .TKL:
            switch direction {
            case .up:   return withRoutingWord ? "往寶琳/康城" : "寶琳/康城"
            case .down: return withRoutingWord ? "往北角" : "北角"
            }

        case .WRL:
            switch direction {
            case .up:   return withRoutingWord ? "往屯門" : "屯門"
            case .down: return withRoutingWord ? "往紅磡" : "紅磡"
            }
        }
    }

}

extension MTRLine.Direction: Codable {}
