//
//  Graph.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import AppKit
import Defaults
import SwiftUI

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

    func generateGraph(data: [Int]) {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.path = self.draw(data: data).cgPath
        shapeLayer.fillColor = CGColor.white
        //shapeLayer.strokeColor = CGColor.white
        //shapeLayer.lineWidth = 0.5
        if let oldLayer = view.layer?.sublayers?[0] {
            view.layer?.replaceSublayer(oldLayer, with: shapeLayer)
        } else {
            view.layer?.addSublayer(shapeLayer)
        }
    }
    
    func resize() {
        self.stepSize = Defaults[.graphWidth]
        self.historyLength = Defaults[.graphLength]
        self.display = Defaults[.displayGraph]
        self.view = NSView(frame: NSRect(x: 0,
                                         y: 0,
                                         width: self.stepSize * self.historyLength,
                                         height: 18))
    }
    
    func draw(data: [Int]) -> Path {
        return Path()
    }
}
