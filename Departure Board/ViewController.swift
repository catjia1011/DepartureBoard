//
//  ViewController.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let stations: [MTRStation] = TseungKwanOLineStation.allCases.reversed().map { .tko($0) }
    var selected = Set<MTRStation>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "設定顯示站點"

        self.tableView.register(cellType: UITableViewCell.self)
        self.tableView.tableFooterView = UIView()

        self.reloadData()

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: AppSettings.stationListDidUpdate, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func reloadData() {
        self.selected = AppSettings.getSettings()
        self.tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: UITableViewCell.self, for: indexPath)
        let station = stations[indexPath.row]
        cell.textLabel?.text = station.name
        cell.accessoryType = selected.contains(station) ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let station = stations[indexPath.row]
        if selected.contains(station) {
            selected.remove(station)
        } else {
            selected.insert(station)
        }

        AppSettings.setStations(Set(self.stations.filter { selected.contains($0) }))
    }


    @objc private func didReceiveNotification(_ notification: Notification) {
        if notification.name == AppSettings.stationListDidUpdate {
            self.reloadData()
        }
    }
}

