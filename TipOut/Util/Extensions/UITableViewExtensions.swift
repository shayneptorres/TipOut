//
//  UITableViewExtensions.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

extension UITableView {
    func deque<T>(cell: T.Type, for indexPath: IndexPath) -> T {
        // Allow the force unwrap, if the cell is not registered, crash the app?
        return self.dequeueReusableCell(withIdentifier: String(describing: cell), for: indexPath) as! T
    }
}
