//
//  Preferences.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let refreshRate = Key<Int>("refreshRate", default: 1)

    static let textDisplay = Key<DisplayText>("textDisplay", default: .stacked)
    
    static let shouldDisplayCpuNumber = Key<Bool>("shouldDisplayCpuNumber", default: true)
    static let shouldDisplayCpuGraph = Key<Bool>("shouldDisplayCpuGraph", default: true)
    static let cpuGraphWidth = Key<Int>("cpuGraphWidth", default: 10)
    static let cpuGraphBoxCount = Key<Int>("cpuGraphBoxCount", default: 5)
    static let cpuGraphType = Key<GraphType>("cpuGraphType", default: .bar)
    static let cpuGraphFunction = Key<GraphFunction>("cpuGraphFunction", default: .linear)
    static let shouldDisplayCpuTemp = Key<Bool>("shouldDisplayCpuGraph", default: true)
    
    static let shouldDisplayGpuNumber = Key<Bool>("shouldDisplayGpuNumber", default: true)
    static let shouldDisplayGpuGraph = Key<Bool>("shouldDisplayGpuGraph", default: true)
    static let gpuGraphWidth = Key<Int>("gpuGraphWidth", default: 10)
    static let gpuGraphBoxCount = Key<Int>("gpuGraphBoxCount", default: 5)
    static let gpuGraphType = Key<GraphType>("gpuGraphType", default: .bar)
    static let gpuGraphFunction = Key<GraphFunction>("gpuGraphFunction", default: .linear)
}
