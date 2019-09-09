//
//  AutoHandleTextInputController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal
import SnapKit

class InputTableViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.rowHeight = 50
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(InputTableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
}

extension InputTableViewController {
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .max, height: 0)
    }
    
    override func shortFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .content, height: 400)
    }
    
    override func panScrollable() -> UIScrollView? {
        return tableView
    }
    
    override func keyboardOffsetFromInputView() -> CGFloat {
        return 10
    }
    
}

extension InputTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(InputTableViewCell.self), for: indexPath) as? InputTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textField.placeholder = "please input something @\(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
}
