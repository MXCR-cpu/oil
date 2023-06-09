//
//  GPU.swift
//  oil
//
//  Created by Maximus on 5/17/23.
//

import Foundation
import IOKit
import IOKit.graphics
import Defaults

internal class GPUManager: Manager {
    var title: String { return "GPUManager" }
    var id: Int { return 1 << 1 }
    var usage: Int? = nil
    var usageString: [String]? = nil
    var temp: Double? = nil
    var usageHistory: [Int] = []

    func reload() {
        guard let propertyList =
                IOHelper.getPropertyList(for: kIOAcceleratorClassName)
        else {
            return
        }
        let st = propertyList.compactMap {
            guard
                let statistics =
                    $0["PerformanceStatistics"] as? [String: Any],
                let usagePercentage =
                    statistics["Device Utilization %"] as? Int ??
                    statistics["GPU Activity(%)"] as? Int
            else {
                return (usage: 0, temp: 0.0)
            }
            return (usage: usagePercentage,
                    temp: statistics["Temperature(C)"] as? Double ??
                    SmcControl.shared.gpuProximityTemperature ?? 0)
        }
        usage = st.reduce(0, { partialResult, a in
            return a.usage > partialResult ? a.usage : partialResult
        })
        temp = st.reduce(0, { partialResult, a in
            return a.temp > partialResult ? a.temp : partialResult
        })
        usageHistory = (usageHistory + [usage ?? 0])
            .suffix(Defaults[.graphLength])
        usageString = [
            String(format: "%02d%%", usage ?? 0),
            String(format: "%02.01f°C", temp ?? 0)
        ]
    }
}
