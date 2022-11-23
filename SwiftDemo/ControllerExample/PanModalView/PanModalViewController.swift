//
//  PanModalViewController.swift
//  SwiftDemo
//
//  Created by heath wang on 2021/11/30.
//  Copyright © 2021 wangcongling. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import HWPanModal


class PanModalViewController : UIViewController {
    
    lazy var presentBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Present", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("CollectionView", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapCollectionBtn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(presentBtn)
        view.addSubview(collectionBtn)
        presentBtn.snp.makeConstraints { make in
            make.centerX.equalTo(view).offset(0)
            make.top.equalTo(200)
            make.size.equalTo(CGSize(width: 150, height: 44))
        }
        
        collectionBtn.snp.makeConstraints { make in
            make.centerX.equalTo(view).offset(0)
            make.top.equalTo(presentBtn.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 150, height: 44))
        }
    }
    
    @objc
    func didTapAction() {
        let colorView = PanModalListColorView();
        colorView.present(in: self.navigationController?.view)
    }
    
    @objc
    func didTapCollectionBtn() {
        let collectionView = PanModalCollectionBottomView()
        collectionView.present(in: self.navigationController?.view)
    }
    
}


class PanModalCollectionBottomView : HWPanModalContentView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PanModalCollectionColorCell.self), for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isKind(of: PanModalCollectionColorCell.self) {
            let boxCell = cell as! PanModalCollectionColorCell
            boxCell.box.backgroundColor = colors[indexPath.row]
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 60) / 2, height: 66.0)
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PanModalCollectionColorCell.self, forCellWithReuseIdentifier: NSStringFromClass(PanModalCollectionColorCell.self))
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var colors: [UIColor] = {
        var _colors: [UIColor] = []
        for _ in 1...10 {
            _colors.append(.random())
        }
        return _colors
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PanModalCollectionBottomView {
    override func panScrollable() -> UIScrollView? {
        return collectionView
    }
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .content, height: 140)
    }
    
    override func springDamping() -> CGFloat {
        return 0.7
    }
    
    override func shouldRespond(toPanModalGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return false
    }
    
    override func showDragIndicator() -> Bool {
        return false
    }
    
}

class PanModalCollectionColorCell : UICollectionViewCell {
    lazy var box: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(box)
        box.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PanModalListColorView : HWPanModalContentView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var colors: [UIColor] = {
        var _colors: [UIColor] = []
        for _ in 1...10 {
            _colors.append(.random())
        }
        return _colors
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PanModalListColorView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.contentView.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}

extension PanModalListColorView {
    override func panScrollable() -> UIScrollView? {
        return tableView
    }
    
    override func topOffset() -> CGFloat {
        return 88
    }
    
    override func springDamping() -> CGFloat {
        return 0.7
    }
    
    override func backgroundConfig() -> HWBackgroundConfig {
        if #available(iOS 14.0, *) {
            return HWBackgroundConfig(behavior: .systemVisualEffect)
        } else {
            return HWBackgroundConfig(behavior: .customBlurEffect)
        }
    }
}
