//
//  MainViewController.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    private enum Section { case settings, manage }
    private var sectionValues: [Section] = [.settings, .manage]

    var settings: [AppSettings.StationAndDirection] = [] {
        didSet {
            self.editButtonItem.isEnabled = (settings.count > 0)
            if settings.count == 0 {
                self.setEditing(false, animated: true)
            }
        }
    }

    // only one and not being reused; convenient fore style updating
    private let manageButtonCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = NSLocalizedString("ui.add_or_remove_stations", value: "Add / Remove Stations", comment: "添加或移除車站")
        return cell
    }()

    private func updateManageButtonCellStatus() {
        manageButtonCell.textLabel?.textColor = self.isEditing ? .lightGray : .mainTintColor
    }

    init() {
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("ui.current_displayed_stations", value: "Current Stations", comment: "當前顯示車站")
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        self.tableView.register(cellType: ValueTableViewCell.self)
        self.tableView.tableFooterView = UIView()

        self.loadSettingsAndReloadTableView(AppSettings.getSettings())
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.updateManageButtonCellStatus()
    }
    
    private func loadSettingsAndReloadTableView(_ settings: [AppSettings.StationAndDirection]) {
        self.settings = settings
        self.sectionValues = settings.count > 0 ? [.settings, .manage] : [.manage]
        self.tableView.reloadData()
    }
    
    private func saveCurrentSettings() {
        AppSettings.setStationsAndDirections(self.settings)
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
        case .manage:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionValues[indexPath.section] {
        case .settings:
            let cell = tableView.dequeue(cellType: ValueTableViewCell.self, for: indexPath)
            let setting = settings[indexPath.row]
            let station = setting.station.code
            let line = MTRLine.withCode(setting.station.lineCode)
            let direction = setting.direction
            cell.textLabel?.text = station.name
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.text = line.destinationName(for: direction, withRoutingWord: true)
            return cell

        case .manage:
            self.updateManageButtonCellStatus()
            return self.manageButtonCell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch sectionValues[indexPath.section] {
        case .settings:
            break

        case .manage:
            let listVC = StationListViewController(settings: self.settings)
            listVC.delegate = self
            self.present(UINavigationController(rootViewController: listVC), animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch sectionValues[indexPath.section] {
        case .settings:
            return true
        case .manage:
            return false
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch sectionValues[indexPath.section] {
        case .settings:
            return .delete
        case .manage:
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch sectionValues[indexPath.section] {
        case .settings:
            switch editingStyle {
            case .delete:
                // remove settings section if it's empty
                self.settings.remove(at: indexPath.row)
                if self.settings.count == 0 {
                    self.sectionValues.remove(at: indexPath.section)
                    tableView.beginUpdates()
                    tableView.deleteSections([indexPath.section], with: .automatic)
                    tableView.endUpdates()
                } else {
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
                self.saveCurrentSettings()

            case .insert, .none:
                break
            }
            
        case .manage:
            break
        }
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
            self.tableView.reloadData()
            return
        }

        var newSettings = self.settings
        let item = newSettings.remove(at: sourceIndexPath.row)
        newSettings.insert(item, at: destinationIndexPath.row)
        self.settings = newSettings
        self.saveCurrentSettings()
    }

    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sectionValues[proposedDestinationIndexPath.section] != .settings {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
}

extension MainViewController: StationListViewControllerDelegate {
    func stationListViewController(_ controller: StationListViewController, didFinishWithNewSettings settings: [AppSettings.StationAndDirection]) {
        self.loadSettingsAndReloadTableView(settings)
        self.saveCurrentSettings()
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
