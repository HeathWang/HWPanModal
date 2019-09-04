//
//  DynamicHeight.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/3.
//  Copyright © 2019 heath wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

enum ChangeType {
    case short, long
}

class DynamicViewController: UIViewController {
    
    lazy var changeShortButton: UIButton = {
        let button = createButton(title: "Dynamic Change short Form Height")
        button.addTarget(self, action: #selector(onTapChangeShort), for: .touchUpInside)
        return button
    }()
    
    lazy var changeLongButton: UIButton = {
        let button = createButton(title: "Dynamic Change long Form Height")
        button.addTarget(self, action: #selector(onTapChangeLong), for: .touchUpInside)
        return button
    }()
    
    var changeType: ChangeType = .short
    var shortHeight: PanModalHeight?
    var longHeight: PanModalHeight?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longHeight = PanModalHeight(type: .topInset, height: 0)
        
        view.backgroundColor = UIColor(displayP3Red: 0.542, green: 0.740, blue: 0.082, alpha: 1)
        view.addSubview(changeLongButton)
        view.addSubview(changeShortButton)
        
        changeShortButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.top.equalTo(20)
            maker.height.equalTo(44)
        }
        
        changeLongButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(changeShortButton.snp.bottom).offset(20)
            maker.size.equalTo(changeShortButton)
        }
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }
    
    @objc func onTapChangeShort() {
        changeType = .short
        
        // reload layout & transition to short
        panModalSetNeedsLayoutUpdate()
        panModalTransitionTo(state: .short)
    }
    
    @objc func onTapChangeLong() {
        changeType = .long
        
        // reload layout & transition to short
        panModalSetNeedsLayoutUpdate()
        panModalTransitionTo(state: .long)
    }
}

extension DynamicViewController {
    
    override func shortFormHeight() -> PanModalHeight {
        if changeType == .short {
            shortHeight = PanModalHeight(type: .topInset, height: CGFloat.random(in: 100...250))
        }
        
        return shortHeight!
    }
    
    override func longFormHeight() -> PanModalHeight {
        if changeType == .long {
            longHeight = PanModalHeight(type: .topInset, height: CGFloat.random(in: 1...150))
        }
        
        return longHeight!
    }
    
}

