//
//  LineGraph.swift
//  oil
//
//  Created by Maximus on 5/22/23.
//

import Foundation
import Cocoa
import AppKit
import Defaults
import SwiftUI

class LineGraph: Graph {
    override init() {
        super.init()
        type = .line
    }
    
    override func generateGraph(data: [Int]) {
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
    
    private func draw(data: [Int]) -> Path {
        var path: Path = Path()
        path.move(to: .zero)
        for i in 0..<data.count {
            path.addLine(to: CGPoint(x: stepSize * i,
                                     y: max(Int(Double(18 * data[data.count-1-i]) /
                                                100),
                                            1)))
        }
        path.addLine(to: CGPoint(x: (data.count - 1) * stepSize, y: 0))
        path.addLine(to: .zero)
        path.closeSubpath()
        NSLog("[oil] CustomPathView: path drawn")
        return path
    }
}
