//
//  MTRLine.swift
//  Departure Board
//
//  Created by Cat Jia on 14/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

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

    var color: UIColor {
        switch self {
        case .tseungKwanOLine:
            return UIColor(red: 125.0 / 255, green: 73.0 / 255, blue: 157.0 / 255, alpha: 1)
        }
    }

    var endStations: [MTRStation: MTRLine.Direction] {
        switch self {
        case .tseungKwanOLine:
            return [
                .northPoint: .up,
                .lohasPark: .down,
                .poLam: .down,
            ]
        }
    }

    var allStations: [MTRStation] {
        switch self {
        case .tseungKwanOLine:
            return [.northPoint, .quarryBay, .yauTong, .tiuKengLeng, .tseungKwanO, .hangHau, .poLam, .lohasPark]
        }
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

extension MTRLine.Direction: Codable {}
extension MTRLine: Codable {}


// MARK: -
private func getAllStations(of line: MTRLine) -> [MTRStation] {
    switch line {
    case .tseungKwanOLine:
        return [.northPoint, .quarryBay, .yauTong, .tiuKengLeng, .tseungKwanO, .hangHau, .poLam, .lohasPark]
    }
}

