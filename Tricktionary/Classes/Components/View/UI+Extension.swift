//
//  UI+Extension.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 12/01/2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var readableArea: UILayoutGuide {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return readableContentGuide
        } else {
            let guide = UILayoutGuide()
            addLayoutGuide(guide)
            guide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            guide.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            guide.topAnchor.constraint(equalTo: topAnchor).isActive = true
            guide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            return guide
        }
    }
}
