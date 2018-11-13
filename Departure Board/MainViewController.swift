//
//  MainViewController.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    var lineStations = [MTRLineStation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "當前顯示車站"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditButtonItem(_:)))

        self.tableView.register(cellType: UITableViewCell.self)
        self.tableView.tableFooterView = UIView()

        self.reloadData()

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: AppSettings.stationListDidUpdate, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func reloadData() {
        self.lineStations = Array(AppSettings.getSettings()) // TODO
        self.tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineStations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: UITableViewCell.self, for: indexPath)
        let lineStation = lineStations[indexPath.row]
        cell.textLabel?.text = lineStation.station.name
        return cell
    }

    @objc private func didTapEditButtonItem(_ sender: Any) {
        let vc = UINavigationController(rootViewController: StationListViewController())
        self.present(vc, animated: true, completion: nil)
    }

    @objc private func didReceiveNotification(_ notification: Notification) {
        if notification.name == AppSettings.stationListDidUpdate {
            self.reloadData()
        }
    }
}

