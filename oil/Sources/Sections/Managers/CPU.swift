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
    var usageString: [String]? = nil
    var temp: Double? = nil
    //var tempString: String? = nil
    var usageHistory: [Int] = []

    func reload() {
        var temp_usage: (system: Double, user: Double, idle: Double, nice: Double) =
            SystemManager.shared.usageCPU()
        usage = Int(temp_usage.system + temp_usage.user)
        usageHistory = (usageHistory + [usage ?? 0])
            .suffix(Defaults[.cpuGraphBoxCount])
        temp = Double(((SmcControl.shared.cpuDieTemperature ?? 0) > 0
                       ? SmcControl.shared.cpuDieTemperature
                       : SmcControl.shared.cpuProximityTemperature) ?? 0.0)
        //tempString = String(format: "%02.01f°C", temp ?? 0)
        usageString = [
            String(format: "%02d%%", usage ?? 0),
            String(format: "%02.01f°C", temp ?? 0)
        ]
    }
}
