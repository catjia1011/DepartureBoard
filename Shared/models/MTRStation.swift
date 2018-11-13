//
//  MTRStation.swift
//  Departure Board
//
//  Created by Cat Jia on 14/11/2018.
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

extension MTRStation: Codable {}
