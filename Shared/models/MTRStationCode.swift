//
//  MTRStationCode.swift
//  Departure Board
//
//  Created by Cat Jia on 14/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

enum MTRStationCode: String {
    case lohasPark        = "LHP"
    case poLam            = "POA"
    case hangHau          = "HAH"
    case tseungKwanO      = "TKO"
    case tiuKengLeng      = "TIK"
    case yauTong          = "YAT"
    case quarryBay        = "QUB"
    case northPoint       = "NOP"

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

    case tungChung        = "TUC"
    case sunnyBay         = "SUN"
    case tsingYi          = "TSY"
    case laiKing          = "LAK"
//  case namCheong        = "NAC"
    case olympic          = "OLY"
    case kowloon          = "KOW"
    case hongKong         = "HOK"

    case asiaWorldExpo    = "AWE"
    case airport          = "AIR"
//  case tsingYi          = "TSY"
//  case kowloon          = "KOW"
//  case hongKong         = "HOK"
}

extension MTRStationCode {
    var name: String {
        switch self {
        case .lohasPark:
            return NSLocalizedString("LHP", tableName: "Stations", value: "LOHAS Park", comment: "康城")
        case .poLam:
            return NSLocalizedString("POA", tableName: "Stations", value: "Po Lam", comment: "寶琳")
        case .hangHau:
            return NSLocalizedString("HAH", tableName: "Stations", value: "Hang Hau", comment: "坑口")
        case .tseungKwanO:
            return NSLocalizedString("TKO", tableName: "Stations", value: "Tseung Kwan O", comment: "將軍澳")
        case .tiuKengLeng:
            return NSLocalizedString("TIK", tableName: "Stations", value: "Tiu Keng Leng", comment: "調景嶺")
        case .yauTong:
            return NSLocalizedString("YAT", tableName: "Stations", value: "Yau Tong", comment: "油塘")
        case .quarryBay:
            return NSLocalizedString("QUB", tableName: "Stations", value: "Quarry Bay", comment: "鰂魚涌")
        case .northPoint:
            return NSLocalizedString("NOP", tableName: "Stations", value: "North Point", comment: "北角")

        case .tuenMun:
            return NSLocalizedString("TUM", tableName: "Stations", value: "Tuen Mun", comment: "屯門")
        case .siuHong:
            return NSLocalizedString("SIH", tableName: "Stations", value: "Siu Hong", comment: "兆康")
        case .tinShuiWai:
            return NSLocalizedString("TIS", tableName: "Stations", value: "Tin Shui Wai", comment: "天水圍")
        case .longPing:
            return NSLocalizedString("LOP", tableName: "Stations", value: "Long Ping", comment: "朗屏")
        case .yuenLong:
            return NSLocalizedString("YUL", tableName: "Stations", value: "Yuen Long", comment: "元朗")
        case .kamSheungRoad:
            return NSLocalizedString("KSR", tableName: "Stations", value: "Kam Sheung Road", comment: "錦上路")
        case .tsuenWanWest:
            return NSLocalizedString("TWW", tableName: "Stations", value: "Tsuen Wan West", comment: "荃灣西")
        case .meiFoo:
            return NSLocalizedString("MEF", tableName: "Stations", value: "Mei Foo", comment: "美孚")
        case .namCheong:
            return NSLocalizedString("NAC", tableName: "Stations", value: "Nam Cheong", comment: "南昌")
        case .austin:
            return NSLocalizedString("AUS", tableName: "Stations", value: "Austin", comment: "柯士甸")
        case .eastTsimShaTsui:
            return NSLocalizedString("ETS", tableName: "Stations", value: "East Tsim Sha Tsui", comment: "尖東")
        case .hungHom:
            return NSLocalizedString("HUH", tableName: "Stations", value: "Hung Hom", comment: "紅磡")

        case .tungChung:
            return NSLocalizedString("TUC", tableName: "Stations", value: "Tung Chung", comment: "東涌")
        case .sunnyBay:
            return NSLocalizedString("SUN", tableName: "Stations", value: "Sunny Bay", comment: "欣澳")
        case .tsingYi:
            return NSLocalizedString("TSY", tableName: "Stations", value: "Tsing Yi", comment: "青衣")
        case .laiKing:
            return NSLocalizedString("LAK", tableName: "Stations", value: "Lai King", comment: "荔景")
//      case .namCheong:
//          return NS//LocalizedString("NAC", tableName: "Stations", value: "Nam Cheong", comment: "南昌")
        case .olympic:
            return NSLocalizedString("OLY", tableName: "Stations", value: "Olympic", comment: "奧運")
        case .kowloon:
            return NSLocalizedString("KOW", tableName: "Stations", value: "Kowloon", comment: "九龍")
        case .hongKong:
            return NSLocalizedString("HOK", tableName: "Stations", value: "Hong Kong", comment: "香港")

        case .asiaWorldExpo:
            return NSLocalizedString("AWE", tableName: "Stations", value: "Asia-World Expo", comment: "博覽館")
        case .airport:
            return NSLocalizedString("AIR", tableName: "Stations", value: "Airport", comment: "機場")
//      case .tsingYi:
//          return NS//LocalizedString("TSY", tableName: "Stations", value: "Tsing Yi", comment: "青衣")
//      case .kowloon:
//          return NS//LocalizedString("KOW", tableName: "Stations", value: "Kowloon", comment: "九龍")
//      case .hongKong:
//          return NS//LocalizedString("HOK", tableName: "Stations", value: "Hong Kong", comment: "香港")
        }
    }
}

extension MTRStationCode: Codable {}
