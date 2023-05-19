//
//  GPU.swift
//  oil
//
//  Created by Maximus on 5/17/23.
//

//import CoreFoundation
import Foundation
import IOKit
import IOKit.graphics
import Defaults

internal class GPUManager: Manager {
    var usage: Int? = nil
    var temp: Int? = nil
    var usageHistory: [Int] = []

    required init() {}
    
    func reload() {
        guard let propertyList = IOHelper.getPropertyList(for: kIOAcceleratorClassName) else {
            return
        }
        
        let _ = propertyList.compactMap {
            guard
                let statistics =
                    $0["PerformanceStatistics"] as? [String: Any],
                let usagePercentage =
                    statistics["Device Utilization %"] as? Int ??
                        statistics["GPU Activity(%)"] as? Int
            else {
                return 0
            }
            usage = (usage ?? 0) < usagePercentage ? usagePercentage : usage
            temp = statistics["Temperature(C)"] as? Int ??
                Int(SmcControl.shared.gpuProximityTemperature ?? 0)
            return 0
        }
        usageHistory = (usageHistory + [usage ?? 0])
            .suffix(Defaults[.cpuGraphBoxCount])
    }
}
