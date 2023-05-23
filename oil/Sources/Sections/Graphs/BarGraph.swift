//
//  BarGraph.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import AppKit
import Defaults

class BarGraph: Graph {
    override init() {
        super.init()
        type = .bar
    }

    override func generateGraph(data: [Int]) {
        for i in 0...(data.count-1) {
            let boxLayer: CALayer = CALayer()
            boxLayer.frame = NSRect(
                x: stepSize * i,
                y: 0,
                width: stepSize,
                height: max(
                    Int((18 * Double(data[data.count-1-i])) / 100),
                    1
                )
            )
            boxLayer.backgroundColor = NSColor.white.cgColor
            boxLayer.borderWidth = 0.0
            view.layer?.addSublayer(boxLayer)
            if let old_layer = view.layer?.sublayers?[i] {
                view.layer?.replaceSublayer(old_layer, with: boxLayer)
            } else {
                view.layer?.addSublayer(boxLayer)
            }
        }
    }
}
