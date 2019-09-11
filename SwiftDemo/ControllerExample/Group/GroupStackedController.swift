//
//  GroupStackedController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/3.
//  Copyright © 2019 heath wang. All rights reserved.
//

import Foundation
import HWPanModal
import SnapKit

class GroupStackedViewController: GroupViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color = colors[indexPath.row]
        let detailVC = GroupDetailViewController(detailColor: color)
        presentPanModal(detailVC)
    }
}

extension GroupStackedViewController {
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .max, height: 0)
    }
    
    override func shortFormHeight() -> PanModalHeight {
        return longFormHeight()
    }
}

class GroupDetailViewController: UIViewController {
    
    var detailColor: UIColor
    
    lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = self.detailColor
        return view
    }()

    init(detailColor: UIColor) {
        self.detailColor = detailColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 200, height: 200))
            maker.top.equalTo(88)
            maker.centerX.equalTo(view).offset(0)
        }
    }
}

extension GroupDetailViewController {
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .topInset, height: 250)
    }
        
    override func anchorModalToLongForm() -> Bool {
        return false
    }
    
}
