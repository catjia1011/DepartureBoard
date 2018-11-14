//
//  MTRLineCode.swift
//  Departure Board
//
//  Created by Cat Jia on 14/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

enum MTRLineCode: String {
    case TKL // Tseung KwanO Line
    case WRL // West Rail Line
    case TCL // Tung Chung Line
    case AEL // Airport Express
}

extension MTRLineCode {
    var name: String {
        switch self {
        case .TKL:
            return NSLocalizedString("line.TKL", value: "Tseung KwanO Line", comment: "將軍澳綫")
        case .WRL:
            return NSLocalizedString("line.WRL", value: "West Rail Line", comment: "西鐵綫")
        case .TCL:
            return NSLocalizedString("line.TCL", value: "Tung Chung Line", comment: "東涌綫")
        case .AEL:
            return NSLocalizedString("line.AEL", value: "Airport Express", comment: "機場快綫")
        }
    }
}

extension MTRLineCode: Codable {}
