//
//  convenience.swift
//  iFund
//
//  Created by Cat Jia on 22/2/2017.
//  Copyright © 2017 Initium Media. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    static let trickyZeroDimension = 0.01 as CGFloat

    func register<T: UITableViewCell>(cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: NSStringFromClass(cellType))
    }

    func dequeue<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: NSStringFromClass(cellType), for: indexPath) as! T
    }

    func register<T: UITableViewHeaderFooterView>(headerFooterType: T.Type) {
        self.register(headerFooterType, forHeaderFooterViewReuseIdentifier: NSStringFromClass(headerFooterType))
    }

    func dequeue<T: UITableViewHeaderFooterView>(headerFooterType: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(headerFooterType)) as! T
    }
}


enum Result<Value> {
    case success(Value)
    case failure(Error)
}
