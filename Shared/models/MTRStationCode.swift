//
//  MTRStationCode.swift
//  Departure Board
//
//  Created by Cat Jia on 14/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

enum MTRStationCode: String {
    case northPoint     = "NOP"
    case quarryBay      = "QUB"
    case yauTong        = "YAT"
    case tiuKengLeng    = "TIK"
    case tseungKwanO    = "TKO"
    case hangHau        = "HAH"
    case poLam          = "POA"
    case lohasPark      = "LHP"

    case tuenMun          = "TUM"
    case siuHong          = "SIH"
    case tinShuiWai       = "TIS"
    case longPing         = "LOP"
    case yuenLong         = "YUL"
    case kamSheungRoad    = "KSR"
    case tsuenWanWest     = "TWW"
    case meiFoo           = "MEF"
    case namCheong        = "NAC"
    case austin           = "AUS"
    case eastTsimShaTsui  = "ETS"
    case hungHom          = "HUH"
}

extension MTRStationCode {
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

        case .tuenMun:          return "屯門"
        case .siuHong:          return "兆康"
        case .tinShuiWai:       return "天水圍"
        case .longPing:         return "朗屏"
        case .yuenLong:         return "元朗"
        case .kamSheungRoad:    return "錦上路"
        case .tsuenWanWest:     return "荃灣西"
        case .meiFoo:           return "美孚"
        case .namCheong:        return "南昌"
        case .austin:           return "柯士甸"
        case .eastTsimShaTsui:  return "尖東"
        case .hungHom:          return "紅磡"
        }
    }
}

extension MTRStationCode: Codable {}
