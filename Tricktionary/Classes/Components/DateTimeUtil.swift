//
//  DateTimeUtil.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 24/02/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation

class DateTimeUtil {
    
    static func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
