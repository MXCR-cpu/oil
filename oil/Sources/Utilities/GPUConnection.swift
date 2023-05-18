//
//  GPUConnection.swift
//  oil
//
//  Created by Maximus on 5/17/23.
//

//import CoreFoundation
import Foundation
import IOKit
import IOKit.graphics

internal class GPUConnection {
    var usage: Int? = nil
    
    init() {}
    
    func reload() {
        guard let propertyList = IOHelper.getPropertyList(for: kIOAcceleratorClassName) else {
            return
        }
        
        let usageArray: [Int] = propertyList.compactMap {
            guard
                let statistics =
                    $0["PerformanceStatistics"] as? [String: Any],
                let usagePercentage =
                    statistics["Device Utilization %"] as? Int ?? statistics["GPU Activity(%)"] as? Int
            else {
                return 0
            }
            return usagePercentage
        }
        usage = usageArray.max()
    }
}
