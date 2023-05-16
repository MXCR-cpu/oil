//
//  Preferences.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let shouldDisplayCpuNumber = Key<Bool>("shouldDisplayCpuNumber", default: true)
    static let shouldDisplayCpuGraph = Key<Bool>("shouldDisplayCpuGraph", default: true)
    static let cpuGraphWidth = Key<Int>("cpuGraphWidth", default: 10)
    static let cpuGraphBoxCount = Key<Int>("cpuGraphBoxCount", default: 5)
}
