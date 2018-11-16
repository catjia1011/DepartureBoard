//
//  StationListViewController.swift
//  Departure Board
//
//  Created by Cat Jia on 13/11/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

protocol StationListViewControllerDelegate: NSObjectProtocol {
    func stationListViewController(_ controller: StationListViewController, didFinishWithNewSettings settings: [AppSettings.StationAndDirection]) -> Void
}

class StationListViewController: UITableViewController {

    weak var delegate: StationListViewControllerDelegate?
    
    private let lines = MTRLine.allLines
    private var settings: [AppSettings.StationAndDirection]
    init(settings: [AppSettings.StationAndDirection]) {
        self.settings = settings
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("ui.station_list", value: "Station List", comment: "車站列表")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButtonItem(_:)))

        self.tableView.register(cellType: StationListCell.self)
        self.tableView.tableFooterView = UIView()
    }

    @objc private func didTapDoneButtonItem(_ sender: Any) {
        self.delegate?.stationListViewController(self, didFinishWithNewSettings: self.settings)
        self.dismiss(animated: true, completion: nil)
    }
}


extension StationListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return lines.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines[section].stations.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return lines[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: StationListCell.self, for: indexPath)
        let station = lines[indexPath.section].stations[indexPath.row]
        let availableDirections = station.availableDirections
        let selectedDirections = self.settings.filter { $0.station == station }.map { $0.direction }
        cell.setLineStation(station, availableDirections: availableDirections, selectedDirections: selectedDirections)
        cell.delegate = self
        return cell
    }
}


extension StationListViewController: StationListCellDelegate {
    func stationListCell(_ cell: StationListCell, didUpdateSelectStatus isSelected: Bool, for direction: MTRLine.Direction) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let station = lines[indexPath.section].stations[indexPath.row]
        let setting = AppSettings.StationAndDirection(station: station, direction: direction)

        var newSettings = self.settings
        if let index = newSettings.index(of: setting) {
            newSettings.remove(at: index)
        }
        if isSelected {
            newSettings.append(setting)
        }
        self.settings = newSettings
        
        self.tableView.reloadData()
    }

}
