//
//  DepartureTableViewController.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

private let COMPACT_WIDGET_HEIGHT = 110 as CGFloat
private let LIGHT_ALPHA = 0.15 as CGFloat
private let NORMAL_ALPHA = 0.25 as CGFloat

class DepartureTableViewController: UITableViewController {

    private let headerView = DepartureHeaderView()

    let station: MTRStation, direction: MTRLine.Direction
    init(station: MTRStation, direction: MTRLine.Direction) {
        self.station = station
        self.direction = direction
        super.init(style: .plain)
        self.title = station.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var departureInfoArray: [DepartureInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(cellType: DepartureCell.self)
        self.tableView.isUserInteractionEnabled = false

        headerView.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: COMPACT_WIDGET_HEIGHT / 4)
        headerView.backgroundColor = UIColor.white.withAlphaComponent(LIGHT_ALPHA)
        headerView.title = "\(station.name) → \(MTRLine.withCode(station.lineCode).destinationName(for: direction))"
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = UIView()
    }

    func fetchData(completion: @escaping () -> Void) {
        self.headerView.showLoading()
        APIClient.shared.request(station: self.station, direction: self.direction) { [weak self] (result) in
            self?.headerView.dismissLoading()
            completion()

            guard let strongSelf = self else { return }
            switch result {
            case .success(let array):
                strongSelf.departureInfoArray = array
            case .failure(let error):
                // TODO; error handling
                strongSelf.departureInfoArray = []
            }
            strongSelf.tableView.reloadData()
        }
    }
}


extension DepartureTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(3, departureInfoArray.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: DepartureCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.white.withAlphaComponent(NORMAL_ALPHA) : UIColor.white.withAlphaComponent(LIGHT_ALPHA)

        guard indexPath.row < departureInfoArray.count else {
            cell.textLabel?.text = "--"
            cell.detailTextLabel?.text = "--:--"
            return cell
        }

        let departureInfo = departureInfoArray[indexPath.row]
        cell.textLabel?.text = departureInfo.destination?.name ?? "--"
        cell.detailTextLabel?.text = dateFormatter.string(from: Date(timeIntervalSince1970: departureInfo.timestamp))
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return COMPACT_WIDGET_HEIGHT / 4
    }
}


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.timeZone = TimeZone(identifier: "HKT")
    return formatter
}()
