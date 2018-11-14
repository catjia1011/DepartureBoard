//
//  DepartureWidgetController.swift
//  Departure Board Widget
//
//  Created by Cat Jia on 30/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit
import NotificationCenter

class DepartureWidgetController: UIViewController, NCWidgetProviding {

    let settings = AppSettings.getSettings()
    lazy var vcs: [DepartureTableViewController] = settings.compactMap {
        DepartureTableViewController(station: $0.station, direction: $0.direction)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard vcs.count > 0 else {
            let openSettingsButton = UIButton()
            openSettingsButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            openSettingsButton.layer.cornerRadius = 6
            openSettingsButton.setTitle("添加 MTR 站點", for: .normal)
            openSettingsButton.setTitleColor(.white, for: .normal)
            openSettingsButton.titleLabel?.font = .systemFont(ofSize: 14)
            openSettingsButton.backgroundColor = UIColor(red:0.71, green:0.13, blue:0.29, alpha:1.0)
            openSettingsButton.sizeToFit()
            openSettingsButton.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            openSettingsButton.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
            openSettingsButton.addTarget(self, action: #selector(didTapOpenSettingsButton(_:)), for: .touchUpInside)
            self.view.addSubview(openSettingsButton)
            return
        }

        let stackView = UIStackView(frame: self.view.bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.spacing = 1
        self.view.addSubview(stackView)

        for (idx, vc) in vcs.enumerated() {
            guard idx < 3 else { break } // MAX 3
            stackView.addArrangedSubview(vc.view)
            self.addChild(vc)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(didReceiveTouch(_:)))
        self.view.addGestureRecognizer(tap)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        self.fetch {
            completionHandler(.newData)
        }
    }

    private func fetch(allCompletion: @escaping () -> Void) {
        var loadCount = 0 {
            didSet {
                if oldValue > 0 && loadCount == 0 {
                    allCompletion()
                }
            }
        }

        guard vcs.count > 0 else {
            allCompletion()
            return
        }

        for vc in vcs {
            loadCount += 1; vc.fetchData { loadCount -= 1 }
        }
    }

    @objc private func didReceiveTouch(_ sender: Any) {
        self.fetch {}
    }

    @objc private func didTapOpenSettingsButton(_ sender: Any) {
        self.extensionContext?.open(URL(string: "departureBoard://")!, completionHandler: nil)
    }
}
