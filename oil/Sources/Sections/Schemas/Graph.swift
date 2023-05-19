//
//  Graph.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import AppKit

protocol Graph {
    var view: NSView { get }
    var stepSize: Int { get }
    var historyLength: Int { get }
    func generateGraph(data: [Int])
    func resize()
}
