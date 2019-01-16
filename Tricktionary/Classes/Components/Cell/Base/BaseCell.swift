//
//  BaseCell.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 16/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UITableViewCell {
    // MARK: Variables
    
    var layerView: UIView?
    
    // MARK: Public
    
    func cornerRadiusAll(_ radius: CGFloat) {
        layerView?.layer.cornerRadius = radius
    }
    
    func cornerRadiusTop(_ radius: CGFloat) {
        roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: radius)
    }
    
    func cornerRadiusBottom(_ radius: CGFloat) {
        roundCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: radius)
    }
    
    // MAKR: Private
    
    fileprivate func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        layerView?.layer.cornerRadius = radius
        layerView?.layer.maskedCorners = corners
    }
}
