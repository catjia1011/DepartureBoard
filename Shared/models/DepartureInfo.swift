//
//  DepartureInfo.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import Foundation

struct DepartureInfo {
    let destinationCode: String
    let timestamp: TimeInterval
}

extension DepartureInfo {
    var destination: MTRStation? {
        return MTRStation(rawValue: destinationCode)
    }
}
