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
    var temp: Double? = nil
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
            usage = usagePercentage
            temp = statistics["Temperature(C)"] as? Double ??
                SmcControl.shared.gpuProximityTemperature
            return 0
        }
        usageHistory = (usageHistory + [usage ?? 0])
            .suffix(Defaults[.cpuGraphBoxCount])
    }
}
