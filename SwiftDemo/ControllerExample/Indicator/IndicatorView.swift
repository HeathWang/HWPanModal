//
//  IndicatorView.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

class TextIndicatorView: UIView, HWPanModalIndicatorProtocol {
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextIndicatorView {
    
    func didChange(to state: HWIndicatorState) {
        switch state {
        case .normal:
            stateLabel.textColor = .white
            stateLabel.text = "Please pull down to dismiss"
        case .pull:
            stateLabel.textColor = UIColor(displayP3Red: 1, green: 0.200, blue: 0, alpha: 1)
            stateLabel.text = "Keep pull down to dismiss"
        default: break
        }
        
    }
    
    func indicatorSize() -> CGSize {
        return CGSize(width: 200, height: 18)
    }
    
    func setupSubviews() {
        stateLabel.frame = bounds
    }
}

class ImmobileIndicatorView: UIView {
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.layer.cornerRadius = 4
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImmobileIndicatorView: HWPanModalIndicatorProtocol {
    
    func didChange(to state: HWIndicatorState) {}
    
    func indicatorSize() -> CGSize {
        return CGSize(width: 45, height: 8)
    }
    
    func setupSubviews() {
        lineView.frame = CGRect(x: 0, y: 0, width: indicatorSize().width, height: indicatorSize().height)
    }
}
