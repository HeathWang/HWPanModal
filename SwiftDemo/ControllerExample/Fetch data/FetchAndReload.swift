//
//  FetchAndReload.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/9.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal
import SnapKit

class FetchDataViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.color = .black
        return indicator
    }()
    
    var dataSource: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        view.addSubview(tableView)
        view.addSubview(indicatorView)
        
        indicatorView.startAnimating()
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view)
        }
        
        indicatorView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.centerY.equalTo(view)
        }
        
        fetchDate()
    }
    
    func fetchDate() -> Void {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            let text = "Downstairs, the doctor left three different medicines in different colored capsules2 with instructions for giving them. One was to bring down the fever, another purgative3, the third to overcome an acid condition. The germs of influenza4 can only exist in an acid condition, he explained. He seemed to know all about influenza and said there was nothing to worry about if the fever did not go above one hundred and four degree. This was a light epidemic5 of flu and there was no danger if you avoided pneumonia6. Back in the room I wrote the boy's temperature down and made a note of the time to give the various capsules."
            for _ in 1...20 {
                self.dataSource.append(String(text.prefix(Int.random(in: 0 ..< text.count))))
            }
            
            self.tableView.reloadData()
            self.indicatorView.stopAnimating()
            self.panModalSetNeedsLayoutUpdate()
            
        }
    }
    
    override func panScrollable() -> UIScrollView? {
        return tableView
    }
    
}

extension FetchDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = self.dataSource[indexPath.row]
        let detailVC = FetchDataDetailViewController()
        detailVC.textString = str
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}

class FetchDataDetailViewController: UIViewController {

    var textString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Detail"
        
        let label = UILabel(frame: .zero)
        label.text = textString
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(displayP3Red: 0.200, green: 0.200, blue: 0.200, alpha: 1)
        label.numberOfLines = 0
        
        view.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.centerY.equalTo(view)
        }
        
    }
    
}
