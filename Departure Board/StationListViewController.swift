//
//  StationListViewController.swift
//  Departure Board
//
//  Created by Cat Jia on 13/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

class StationListViewController: UITableViewController {

    let lines = MTRLine.allCases
    var selected = Set<MTRLineStation>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "車站列表"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButtonItem(_:)))

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

    @objc private func didTapDoneButtonItem(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func didReceiveNotification(_ notification: Notification) {
        if notification.name == AppSettings.stationListDidUpdate {
            self.reloadData()
        }
    }
}


extension StationListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return lines.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines[section].allLineStations.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return lines[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: UITableViewCell.self, for: indexPath)
        let lineStation = lines[indexPath.section].allLineStations[indexPath.row]
        cell.textLabel?.text = lineStation.station.name
        cell.accessoryType = selected.contains(lineStation) ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let lineStation = lines[indexPath.section].allLineStations[indexPath.row]
        if selected.contains(lineStation) {
            selected.remove(lineStation)
        } else {
            selected.insert(lineStation)
        }

        AppSettings.setStations(self.selected)
    }
}
