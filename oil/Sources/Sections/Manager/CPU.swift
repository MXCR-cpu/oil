//
//  CPU.swift
//  oil
//
//  Created by Maximus on 5/18/23.
//

import Foundation
import AppKit
import SystemKit
import SwiftUI
import Defaults
import IOKit
import TinyConstraints

internal class CPUManager: Manager {
    var usage: Int? = nil
    var temp: Double? = nil
    var usageHistory: [Int] = []
    var system: System

    required init() {
        system = System()
    }
    
    func reload() {
        let temp_usage: (system: Double, user: Double, idle: Double, nice: Double) =
            system.usageCPU()
        usage = Int(temp_usage.system + temp_usage.user)
        temp = Double(((SmcControl.shared.cpuDieTemperature ?? 0) > 0
                       ? SmcControl.shared.cpuDieTemperature
                       : SmcControl.shared.cpuProximityTemperature) ?? 0.0)
        usageHistory = (usageHistory + [usage ?? 0])
            .suffix(Defaults[.cpuGraphBoxCount])
    }
}
