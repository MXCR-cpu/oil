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
    var title: String { return "GPUManager" }
    var usage: Int? = nil
    var usageString: [String]? = nil
    var temp: Double? = nil
    var usageHistory: [Int] = []

    func reload() {
        guard let propertyList =
                IOHelper.getPropertyList(for: kIOAcceleratorClassName) else {
            return
        }
        /* Perhaps utilize a better way to collect the data from the list */
        guard
            let statistics =
                propertyList[0]["PerformanceStatistics"] as? [String: Any],
            let usagePercentage =
                statistics["Device Utilization %"] as? Int ??
                    statistics["GPU Activity(%)"] as? Int
        else {
            return
        }
        usage = usagePercentage
        temp = statistics["Temperature(C)"] as? Double ??
            SmcControl.shared.gpuProximityTemperature
        usageHistory = (usageHistory + [usage ?? 0])
            .suffix(Defaults[.graphLength])
        usageString = [
            String(format: "%02d%%", usage ?? 0),
            String(format: "%02.01f°C", temp ?? 0)
        ]
    }
}
