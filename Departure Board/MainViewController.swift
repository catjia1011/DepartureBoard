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
    private var sectionValues: [Section] = [.settings, .edit]

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

        self.tableView.register(cellType: ValueTableViewCell.self)
        self.tableView.tableFooterView = UIView()

        self.reloadData()

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: AppSettings.stationListDidUpdate, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if let section = self.sectionValues.index(of: .edit) {
            self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }

    private func reloadData() {
        self.settings = AppSettings.getSettings()
        self.sectionValues = settings.count > 0 ? [.settings, .edit] : [.edit]
        self.navigationItem.rightBarButtonItem = settings.count > 1 ? self.editButtonItem : nil
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
            let cell = tableView.dequeue(cellType: ValueTableViewCell.self, for: indexPath)
            let setting = settings[indexPath.row]
            let station = setting.lineStation.station
            let line = setting.lineStation.line
            let direction = setting.direction
            cell.textLabel?.text = station.name
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.text = line.destinationName(for: direction, withRoutingWord: true)
            return cell

        case .edit:
            let cell = tableView.dequeue(cellType: ValueTableViewCell.self, for: indexPath)
            cell.textLabel?.text = "添加或移除車站"
            cell.textLabel?.textColor = self.isEditing ? .lightGray : .appleBlue
            cell.detailTextLabel?.text = nil
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


private class ValueTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
