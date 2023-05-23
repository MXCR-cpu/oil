//
//  Graph.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import AppKit
import Defaults

class Graph {
    internal var view: NSView = NSView(frame: .zero)
    internal var stepSize: Int = 0
    internal var historyLength: Int = 0
    internal var display: Bool = false
    var type: GraphType
    
    init() {
        type = .base
        resize()
    }
    
    deinit {
        view = NSView(frame: .zero)
    }
    
    func generateGraph(data: [Int]) {}
    
    func resize() {
        self.stepSize = Defaults[.graphWidth]
        self.historyLength = Defaults[.graphLength]
        self.display = Defaults[.displayGraph]
        self.view = NSView(frame: NSRect(x: 0,
                                         y: 0,
                                         width: self.stepSize * self.historyLength,
                                         height: 18))
    }
}
