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
    static func setStationsAndDirections(_ stationsAndDirections: [StationAndDirection]) {
        let settings = try? JSONEncoder().encode(stationsAndDirections)
        sharedUserDefaults?.set(settings, forKey: SETTINGS_KEY)
        sharedUserDefaults?.synchronize()
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: AppSettings.stationListDidUpdate, object: nil)
        }
    }

    static func getSettings() -> [StationAndDirection] {
        guard let data = sharedUserDefaults?.data(forKey: SETTINGS_KEY) else { return [] }
        return (try? JSONDecoder().decode([StationAndDirection].self, from: data)) ?? []
    }
}


extension AppSettings {
    struct StationAndDirection: Equatable, Codable {
        let lineStation: MTRLineStation
        let direction: MTRLine.Direction
    }
}

extension MTRLineStation: Equatable {}

