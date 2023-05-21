//
//  Preferences.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let stackedText = Key<Bool>("stackedText", default: true)
    static let refreshRate = Key<Int>("refreshRate", default: 1)
    static let displayGraph = Key<Bool>("displayGraph", default: true)
    static let graphWidth = Key<Int>("grapWidth", default: 10)
    static let graphLength = Key<Int>("graphLength", default: 5)
    static let graphType = Key<GraphType>("graphLength", default: .bar)
    static let itemsDisplay = Key<Int>("itemsDisplay", default: 31)
}
