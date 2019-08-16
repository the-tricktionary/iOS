//
//  SpeedEvents.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation

class SpeedEvents {
    
    var data: [Int : String]
    
    init() {
        data = [
            0: "FISAC-IRSF - SRSS - 30s",
            1: "FISAC-IRSF - SRE - 180s",
            2: "FISAC-IRSF - SRSR - 4x30s",
            3: "FISAC-IRSF - DDSR - 4x45s",
            4: "Custom time"
            ] as [Int : String]
    }
}

enum Events {
    case FI1X30
    case FI1X180
    case FI4X30
    case FI4X45
    case custom
}

extension Events {
    func description() -> String {
        switch self {
        case .FI1X30:
            return "FISAC-IRSF - SRSS - 30s"
        case .FI1X180:
            return "FISAC-IRSF - SRE - 180s"
        case .FI4X30:
            return "FISAC-IRSF - SRSR - 4x30s"
        case .FI4X45:
            return "FISAC-IRSF - DDSR - 4x45s"
        case .custom:
            return "Custom time"
        }
    }
    
    func sections() -> Int {
        switch self {
        case .FI1X30, .FI1X180, .custom:
            return 1
        case .FI4X30, .FI4X45:
            return 4
        }
    }
}
