//
//  GroupStackedController.swift
//  SwiftDemo
//
//  Created by heath wang on 2019/9/3.
//  Copyright © 2019 heath wang. All rights reserved.
//

import Foundation
import HWPanModal

class GroupStackedViewController: GroupViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
