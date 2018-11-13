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
    var settings: [AppSettings.StationAndDirection] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "車站列表"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButtonItem(_:)))

        self.tableView.register(cellType: StationListCell.self)
        self.tableView.tableFooterView = UIView()

        self.reloadData()

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: AppSettings.stationListDidUpdate, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func reloadData() {
        self.settings = AppSettings.getSettings()
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
        let cell = tableView.dequeue(cellType: StationListCell.self, for: indexPath)
        let lineStation = lines[indexPath.section].allLineStations[indexPath.row]
        cell.textLabel?.text = lineStation.station.name
        cell.setSelectedDirections(self.settings.filter { $0.lineStation == lineStation }.map { $0.direction })
        cell.delegate = self
        return cell
    }
}


extension StationListViewController: StationListCellDelegate {
    func stationListCell(_ cell: StationListCell, didUpdateSelectStatus isSelected: Bool, for direction: MTRLine.Direction) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let lineStation = lines[indexPath.section].allLineStations[indexPath.row]
        let setting = AppSettings.StationAndDirection(lineStation: lineStation, direction: direction)

        var newSettings = self.settings
        if let index = newSettings.index(of: setting) {
            newSettings.remove(at: index)
        }

        if isSelected {
            newSettings.append(setting)
        }

        AppSettings.setStationsAndDirections(newSettings)
    }

}
