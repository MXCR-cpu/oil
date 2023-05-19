//
//  Fan.swift
//  oil
//
//  Created by Maximus on 5/19/23.
//

import Foundation
import AppKit
import SystemKit
import SwiftUI
import Defaults
import IOKit
import TinyConstraints

internal class FanManager: Manager {
    var usage: Int? = nil
    var usageString: String? = nil
    var usageHistory: [Int] = []
    var temp: Double? = nil
    var tempString: String? = nil
    
    func reload() {
        NSLog("[oil] FanManager: \(SmcControl.shared.fans.compactMap{ $0.currentSpeed })")
        usage = SmcControl.shared.fans[0].currentSpeed
        usageHistory = (usageHistory + [usage ?? 0])
            .suffix(Defaults[.cpuGraphBoxCount])
        usageString = "\(SmcControl.shared.fans[0].currentSpeedString) \(SmcControl.shared.fans[1].currentSpeedString)"
    }
}
