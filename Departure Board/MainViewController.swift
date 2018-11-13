//
//  MainViewController.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    private enum Section { case settings, edit }
    private let sectionValues: [Section] = [.settings, .edit]

    var settings: [AppSettings.StationAndDirection] = []

    init() {
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "當前顯示車站"
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        self.tableView.register(cellType: UITableViewCell.self)
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
}

extension MainViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionValues.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionValues[section] {
        case .settings:
            return settings.count
        case .edit:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionValues[indexPath.section] {
        case .settings:
            let cell = tableView.dequeue(cellType: UITableViewCell.self, for: indexPath)
            let setting = settings[indexPath.row]
            let station = setting.lineStation.station
            let line = setting.lineStation.line
            let direction = setting.direction
            cell.textLabel?.text = "\(station.name) → \(line.destinationName(for: direction))"
            cell.textLabel?.textColor = .black
            return cell

        case .edit:
            let cell = tableView.dequeue(cellType: UITableViewCell.self, for: indexPath)
            cell.textLabel?.text = "添加或移除車站"
            cell.textLabel?.textColor = .appleBlue
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch sectionValues[indexPath.section] {
        case .settings:
            break

        case .edit:
            let vc = UINavigationController(rootViewController: StationListViewController())
            self.present(vc, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch sectionValues[indexPath.section] {
        case .settings:
            return true
        case .edit:
            return false
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.section == destinationIndexPath.section && sectionValues[sourceIndexPath.section] == .settings else {
            assertionFailure("unexpected")
            self.reloadData()
            return
        }

        var newSettings = self.settings
        let item = newSettings.remove(at: sourceIndexPath.row)
        newSettings.insert(item, at: destinationIndexPath.row)
        AppSettings.setStationsAndDirections(newSettings)
        self.reloadData()
    }

    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sectionValues[proposedDestinationIndexPath.section] != .settings {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
}

extension MainViewController {
    @objc private func didReceiveNotification(_ notification: Notification) {
        if notification.name == AppSettings.stationListDidUpdate {
            self.reloadData()
        }
    }
}

