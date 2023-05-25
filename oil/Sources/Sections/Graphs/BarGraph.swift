//
//  BarGraph.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import AppKit
import Defaults
import SwiftUI

class BarGraph: Graph {
    override init() {
        super.init()
        type = .bar
    }

    override func draw(data: [Int]) -> Path {
        var path: Path = Path()
        path.move(to: CGPoint(x: CGFloat(stepSize * (data.count-1)),
                              y: CGFloat(18 * data[data.count - 1]) / 100.0))
        var index: Int = 0
        path.addLines(data.compactMap {
            index += 1
            return [
                CGPoint(x: stepSize * (data.count-index+1),
                        y: Int(18 * Double($0) / 100)),
                CGPoint(x: stepSize * (data.count-index),
                        y: Int(18 * Double($0) / 100)),
            ]
        }.flatMap { $0 })
        if Defaults[.graphFill] {
            path.addLine(to: .zero)
            path.addLine(to: CGPoint(x: stepSize * (data.count - 1), y: 0))
            path.closeSubpath()
        }
        return path
    }
}
