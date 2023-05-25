//
//  HorizonGraph.swift
//  oil
//
//  Created by Maximus on 5/23/23.
//

import Foundation
import AppKit
import Defaults
import SwiftUI

class HorizonGraph: Graph {
    override init() {
        super.init()
        type = .horizon
    }

    override func draw(data: [Int]) -> Path {
        var path: Path = Path()
        path.move(to: CGPoint(x: CGFloat(stepSize * (data.count-1)),
                              y: CGFloat(18 * data[data.count - 1]) / 100.0))
        var index: Int = 0
        var jndex: Int = 0
        var top_points: [CGPoint] = data.compactMap {
            index += 1
            return [
                CGPoint(x: stepSize * (data.count-index+1),
                        y: 9 + Int(18 * Double($0) / 200)),
                CGPoint(x: stepSize * (data.count-index),
                        y: 9 + Int(18 * Double($0) / 200)),
            ]
        }.flatMap { $0 }
        var bottom_points: [CGPoint] = data.compactMap {
            jndex += 1
            return [
                CGPoint(x: stepSize * (data.count-jndex+1),
                        y: 9 - Int(18 * Double($0) / 200)),
                CGPoint(x: stepSize * (data.count-jndex),
                        y: 9 - Int(18 * Double($0) / 200)),
            ]
        }.flatMap { $0 }
        bottom_points.reverse()
        path.addLines(top_points + bottom_points)
        path.closeSubpath()
        if Defaults[.graphFill] {
            path.addLine(to: .zero)
            path.addLine(to: CGPoint(x: stepSize * (data.count - 1), y: 0))
        }
        return path
    }
}
