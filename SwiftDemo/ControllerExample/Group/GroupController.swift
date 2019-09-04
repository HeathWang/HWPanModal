//
//  GroupController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/3.
//  Copyright © 2019 heath wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

class GroupViewController: UITableViewController {
    
    var colors: [UIColor] = {
        var _colors: [UIColor] = []
        for _ in 1...10 {
            _colors.append(.random())
        }
        return _colors
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
    
    func getColor(index: Int) -> UIColor {
        return colors[index]
    }
}

extension GroupViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.contentView.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
}

extension GroupViewController {
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .topInset, height: 200)
    }
    
    override func shortFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .content, height: 200)
    }
    
    override func panScrollable() -> UIScrollView? {
        return tableView
    }
    
}

extension CGFloat {
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(displayP3Red: .random(),
                       green: .random(),
                       blue: .random(),
                       alpha: 1.0)
    }
}
