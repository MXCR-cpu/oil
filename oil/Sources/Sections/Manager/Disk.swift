//
//  Disk.swift
//  oil
//
//  Created by Maximus on 5/19/23.
//

import Foundation

internal class DiskManager: Manager {
    var usage: Int? = nil
    var usageString: String? = nil
    var usageHistory: [Int] = []
    var temp: Double? = nil
    var tempString: String? = nil
    
    func reload() {
        guard let volumes =
                (try? FileManager.default.contentsOfDirectory(atPath: "/Volumes"))
        else { return }
        
        //NSLog("[oil] volumes: \(volumes)")
        if volumes[0].starts(with: ".") ||
            volumes[0].contains("com.apple") { return }

        let path = "/Volumes/" + volumes[0]
        let url = URL(fileURLWithPath: path)

        guard
            let attributes = try? FileManager.default.attributesOfFileSystem(forPath: path),
            let size = attributes[FileAttributeKey.systemSize] as? UInt64,
            let freeSize = attributes[FileAttributeKey.systemFreeSize] as? UInt64
        else { return }
        
        usageString = "\(Int((size - freeSize) / 1_000_000_000)) GB \(String(format: "%02d%%", Int(((size - freeSize) * 100) / (size))))"
    }
}
