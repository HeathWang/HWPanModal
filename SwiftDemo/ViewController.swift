//
//  ViewController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/8/22.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import UIKit
import SnapKit
import HWPanModal

class ViewController: UIViewController {
    
    var demoType = DemoList.home
    var dataSource: [DemoCell] = []

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 44
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if demoType == .home {
            dataSource = DemoCell.homeDemoCells()
            title = "Swift Example"
        } else if demoType == .app {
            dataSource = DemoCell.appDemoCells()
            title = "App Example"
        } else if demoType == .indicator {
            dataSource = DemoCell.indicatorCells()
            title = "Indicator Example"
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let cellData = dataSource[indexPath.row]
        
        cell.textLabel?.text = cellData.string
        cell.accessoryType = cellData.action == .push ? .disclosureIndicator : .none
        return cell
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellData = dataSource[indexPath.row]
        if cellData.action == .push {
            self.navigationController?.pushViewController(cellData.rowVC, animated: true)
        } else {
            presentPanModal(cellData.rowVC)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
