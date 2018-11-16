//
//  DepartureCell.swift
//  Departure Board
//
//  Created by Cat Jia on 29/9/2018.
//  Copyright © 2018 Cat Jia. All rights reserved.
//

import UIKit

class DepartureCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        self.textLabel?.font = .systemFont(ofSize: 13)
        self.detailTextLabel?.font = .systemFont(ofSize: 13)

        self.textLabel?.allowsDefaultTighteningForTruncation = true
        self.detailTextLabel?.allowsDefaultTighteningForTruncation = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let textLabel = self.textLabel, let detailTextLabel = self.detailTextLabel else { return }
        let previousDetailTextLabelFrame = detailTextLabel.frame
        detailTextLabel.frame.size.width = detailTextLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)).width
        detailTextLabel.frame.origin.x = previousDetailTextLabelFrame.maxX - detailTextLabel.frame.width

        let deltaWidth = detailTextLabel.frame.width - previousDetailTextLabelFrame.width
        textLabel.frame.size.width -= deltaWidth
    }
}
