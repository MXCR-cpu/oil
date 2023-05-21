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
    var title: String { return "FanManager" }
    var usage: Int? = nil
    var usageString: [String]? = nil
    var usageHistory: [Int] = []
    var temp: Double? = nil
    
    func reload() {
        usage = SmcControl.shared.fans[0].currentSpeed
        usageHistory = (usageHistory + [usage ?? 0])
            .suffix(Defaults[.graphLength])
        usageString = SmcControl.shared.fans.compactMap {
            $0.currentSpeedString
        }
    }
}
