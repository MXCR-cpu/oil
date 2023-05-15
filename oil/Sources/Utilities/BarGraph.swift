//
//  BarGraph.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import AppKit

class BarGraph: Graph {
    internal var stepSize: Int = 10
    internal var view: NSView = NSView(
        frame: NSRect(x: 0, y: 0, width: 0, height: 0)
    )
    internal var historyLength: Int = 5
    
    init() {}
    
    func generateGraph(data: [Double]) {
        for i in 0...(data.count-1) {
            let boxLayer: CALayer = CALayer()
            boxLayer.frame = NSRect(
                x: self.stepSize * i,
                y: 0,
                width: self.stepSize,
                height: max(
                    Int(18 * (data[data.count-1-i] / 100)),
                    1
                )
            )
            boxLayer.backgroundColor = NSColor.white.cgColor
            boxLayer.borderWidth = 0.0
            self.view.layer?.addSublayer(boxLayer)
            if let old_layer = self.view.layer?.sublayers?[i] {
                self.view.layer?.replaceSublayer(old_layer, with: boxLayer)
            } else {
                self.view.layer?.addSublayer(boxLayer)
            }
        }
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
    }
}
