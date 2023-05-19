//
//  CPUManager.swift
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
    var temp: Int? = nil
    var usageHistory: [Int] = []
    var system: System

    required init() {
        system = System()
    }
    
    func reload() {
        let temp_usage: (system: Double, user: Double, idle: Double, nice: Double) =
            system.usageCPU()
        usage = Int(temp_usage.system + temp_usage.user)
        usageHistory = (usageHistory + [usage ?? 0])
            .suffix(Defaults[.cpuGraphBoxCount])
    }
}
