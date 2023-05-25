//
//  Memory.swift
//  oil
//
//  Created by Maximus on 5/19/23.
//

import Foundation
import SystemKit

internal class MemoryManager: Manager {
    var title: String { return "MemoryManager" }
    var id: Int { return 1 << 3 }
    var usage: Int? = nil
    var usageString: [String]? = nil
    var usageHistory: [Int] = []
    var temp: Double? = nil
    private var free: Double = 0
    private var active: Double = 0
    private var inactive: Double = 0
    private var wired: Double = 0
    private var compressed: Double = 0
    private var appMemory: Double = 0
    private var cachedFiles: Double = 0
    private var used: Double {
        appMemory + wired + compressed
    }
    private var total: Double {
        free + inactive + active + wired + compressed
    }
    private var usedPercentage: Int {
        Int((100 * used) / total)
    }
    
    func reload() {
        (free,
         active,
         inactive,
         wired,
         compressed,
         appMemory,
         cachedFiles) = System.memoryUsage()
        usageString = [
            "\(used.memoryString)",
            String(format: "%02d%%", usedPercentage)
        ]
    }
}
