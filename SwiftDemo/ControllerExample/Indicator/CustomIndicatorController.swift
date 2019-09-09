//
//  CustomIndicatorController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/4.
//  Copyright © 2019 Heath Wang. All rights reserved.
//

import Foundation
import UIKit
import HWPanModal

enum IndicatorStyle {
    case changeColor, text, immobile
}

class IndicatorPopViewController: UIViewController {
    
    private let style: IndicatorStyle
    
    init(style: IndicatorStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 0, green: 1, blue: 8, alpha: 1)
    }
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .topInset, height: 44)
    }
    
    override func customIndicatorView() -> (UIView & HWPanModalIndicatorProtocol)? {
        switch style {
        case .changeColor:
            let indicatorView = HWPanIndicatorView()
            indicatorView.indicatorColor = view.backgroundColor!
            return indicatorView
        case .text:
            return TextIndicatorView()
        case .immobile:
            return ImmobileIndicatorView()
        }
    }
    
}
