//
//  LineGraph.swift
//  oil
//
//  Created by Maximus on 5/22/23.
//

import Foundation
import AppKit
import Defaults
import SwiftUI

class LineGraph: Graph {
    override init() {
        super.init()
        type = .line
    }
    
    override func draw(data: [Int]) -> Path {
        var path: Path = Path()
        var index: Int = 0
        path.addLines(data.compactMap {
            index += 1
            return CGPoint(x: stepSize * (data.count-index),
                           y: Int(18 * Double($0) / 100))
        })
        if Defaults[.graphFill] {
            path.addLine(to: .zero)
            path.addLine(to: CGPoint(x: stepSize * (data.count - 1), y: 0))
            path.closeSubpath()
        }
        return path
    }
}
