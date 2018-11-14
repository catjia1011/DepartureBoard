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
    let color: UIColor
    let stations: [MTRStation]

    fileprivate let endStations: [MTRStationCode: Direction]

    private typealias DestinationNameBlock = (_ direction: Direction, _ withRoutingWord: Bool) -> String
    private let destinationNameBlock: DestinationNameBlock

    private init(code lineCode: MTRLineCode, color: UIColor, stationCodes: [MTRStationCode], endStations: [MTRStationCode: Direction], destinationNameBlock: @escaping DestinationNameBlock) {
        self.code = lineCode
        self.stations = stationCodes.map { MTRStation(line: lineCode, verifiedStationCode: $0) }
        self.color = color
        self.endStations = endStations
        self.destinationNameBlock = destinationNameBlock
    }
}

// MARK: -
extension MTRLine {
    static func withCode(_ lineCode: MTRLineCode) -> MTRLine {
        switch lineCode {
        case .TKL:
            return tseungKwanOLine
        case .WRL:
            return westRainLine
        case .TCL:
            return tungChungLine
        case .AEL:
            return airportExpress
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

    func destinationName(for direction: Direction, withRoutingWord: Bool = false) -> String {
        return self.destinationNameBlock(direction, withRoutingWord)
    }

}

extension MTRLine.Direction: Codable {}

extension MTRStation {
    var availableDirections: [MTRLine.Direction] {
        if let endStationDirection = MTRLine.withCode(lineCode).endStations[code] {
            return [endStationDirection]
        }
        return MTRLine.Direction.allCases
    }
}


// MARK: -
extension MTRLine {
    static let allLines: [MTRLine] = [tseungKwanOLine, westRainLine, tungChungLine, airportExpress]

    static let tseungKwanOLine = MTRLine(
        code: .TKL,
        color: UIColor(R: 163, G: 94, B: 181),
        stationCodes: [
            .northPoint, .quarryBay, .yauTong, .tiuKengLeng, .tseungKwanO, .hangHau, .poLam, .lohasPark
        ],
        endStations: [
            .northPoint: .up,
            .lohasPark: .down,
            .poLam: .down
        ],
        destinationNameBlock: { (direction, withRoutingWord) in
            switch direction {
            case .up:   return withRoutingWord ? "往寶琳/康城" : "寶琳/康城"
            case .down: return withRoutingWord ? "往北角" : "北角"
            }
    })

    static let westRainLine = MTRLine(
        code: .WRL,
        color: UIColor(R: 182, G: 0, B: 141),
        stationCodes: [
            .hungHom, .eastTsimShaTsui, .austin, .namCheong, .meiFoo, .tsuenWanWest, .kamSheungRoad, .yuenLong, .longPing, .tinShuiWai, .siuHong, .tuenMun
        ],
        endStations: [
            .hungHom: .up,
            .tuenMun: .down
        ],
        destinationNameBlock: { (direction, withRoutingWord) in
            switch direction {
            case .up:   return withRoutingWord ? "往屯門" : "屯門"
            case .down: return withRoutingWord ? "往紅磡" : "紅磡"
            }
    })

    static let tungChungLine = MTRLine(
        code: .TCL,
        color: UIColor(R: 243, G: 139, B: 0),
        stationCodes: [
            .hongKong, .kowloon, .olympic, .namCheong, .laiKing, .tsingYi, .sunnyBay, .tungChung
        ],
        endStations: [
            .hongKong: .up,
            .tungChung: .down
        ],
        destinationNameBlock: { (direction, withRoutingWord) in
            switch direction {
            case .up:   return withRoutingWord ? "往東涌" : "東涌"
            case .down: return withRoutingWord ? "往香港" : "香港"
            }
    })

    static let airportExpress = MTRLine(
        code: .AEL,
        color: UIColor(R: 0, G: 112, B: 120),
        stationCodes: [
            .hongKong, .kowloon, .tsingYi, .airport, .asiaWorldExpo
        ],
        endStations: [
            .hongKong: .up,
            .asiaWorldExpo: .down
        ],
        destinationNameBlock: { (direction, withRoutingWord) in
            switch direction {
            case .up:   return withRoutingWord ? "往機場/博覽館" : "機場/博覽館"
            case .down: return withRoutingWord ? "往香港" : "香港"
            }
    })
}
