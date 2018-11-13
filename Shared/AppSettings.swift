//
//  AppSettings.swift
//  Departure Board
//
//  Created by Cat Jia on 2/10/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

private let SETTINGS_KEY = "widgetSettings/stations"
private let APP_GROUP_ID = "group.cat.jia.departureboard"
private let sharedUserDefaults = UserDefaults(suiteName: APP_GROUP_ID)


class AppSettings {

    static let stationListDidUpdate = Notification.Name(rawValue: "AppSettingsStationListDidUpdate")

    // MAX is 3
    static func setStations(_ stations: Set<MTRStation>) {
        sharedUserDefaults?.set(stations.map { $0.rawValue }, forKey: SETTINGS_KEY)
        sharedUserDefaults?.synchronize()
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: AppSettings.stationListDidUpdate, object: nil)
        }
    }

    static func getSettings() -> Set<MTRStation> {
        return Set((sharedUserDefaults?.array(forKey: SETTINGS_KEY) as? [String] ?? []).compactMap { MTRStation(rawValue: $0) })
    }
}
