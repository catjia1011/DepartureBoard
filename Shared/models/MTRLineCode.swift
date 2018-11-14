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
}

extension MTRLineCode {
    var name: String {
        switch self {
        case .TKL:
            return "將軍澳綫"
        case .WRL:
            return "西鐵綫"
        case .TCL:
            return "東涌綫"
        }
    }
}

extension MTRLineCode: Codable {}
