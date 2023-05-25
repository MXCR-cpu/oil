//
//  CPU.swift
//  oil
//
//  Created by Maximus on 5/14/23.
//

import Foundation
import AppKit
import SystemKit
import SwiftUI
import Defaults
import IOKit
import TinyConstraints

internal class GraphItem: StatusItem {
    var manager: Manager
    private var graph: Graph
    private var usageHistory: [Int] = []
    private var stackView: NSStackView = NSStackView(frame: .zero)
    private var graphView: NSStackView = NSStackView(frame: .zero)
    private var textView: TextItem? = nil
    private var labelArray: [NSTextField] = []
    var update: Bool = false
    var enabled: Bool = true
    var view: NSView { return stackView }
    
    init(manager: Manager, graph: Graph) {
        self.manager = manager
        self.graph = graph
    }
    
    func action() {
        NSWorkspace.shared
            .open(URL(fileURLWithPath: "/Application/Activity Monitor.app"))
    }

    func reload() {
        updateLabel()
        if graph.display {
            graph.generateGraph(data: manager.usageHistory)
        }
        update =
            Defaults[.graphWidth] != graph.stepSize ||
            Defaults[.graphLength] != graph.historyLength ||
            Defaults[.displayGraph] != graph.display ||
            Defaults[.graphType] != graph.type
    }

    func didLoad() {
        configureStackView()
        enabled = true
    }

    func didUnload() {
        textView?.didUnload()
        if stackView.arrangedSubviews.contains(graphView) {
            removeViewFromStackView(view: graphView)
        }
        enabled = false
    }
    
    func updateCall() {
        updateGraph()
        update = false
    }
    
    /// Utility
    private func configureLabel(label: NSTextField) {
        label.font = NSFont
            .monospacedDigitSystemFont(ofSize: Defaults[.stackedText] ? 13 : 8,
                                       weight: .regular)
        label.maximumNumberOfLines = 1
        label.sizeToFit()
    }

    private func configureStackView() {
        textView = TextItem(manager: manager)
        textView?.didLoad()
        labelArray = manager.usageString?.compactMap {
            let textField = NSTextField(labelWithString: $0)
            configureLabel(label: textField)
            return textField
        } ?? []
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.addArrangedSubview(textView?.view ??
                                     NSStackView(frame: .zero))
        if graph.display {
            graphView = NSStackView(frame: .zero)
            graphView.addArrangedSubview(graph.view)
            graphView.orientation = .horizontal
            graphView.alignment = .centerY
            graphView.distribution = .fillProportionally
            graphView.width(CGFloat(Defaults[.graphWidth] *
                                    Defaults[.graphLength]))
            stackView.addArrangedSubview(graphView)
        }
    }

    private func removeViewFromStackView(view: NSView) {
        let labelPos: Int = stackView
            .arrangedSubviews
            .firstIndex(of: view) ?? -1
        stackView.removeArrangedSubview(view)
        if labelPos >= 0 {
            stackView
                .subviews
                .remove(at: labelPos)
        }
    }
    
    private func removeViewFromParentView(parentView: NSStackView,
                                          childView: NSView) {
        let labelPos: Int = parentView
            .arrangedSubviews
            .firstIndex(of: childView) ?? -1
        parentView.removeArrangedSubview(childView)
        if labelPos >= 0 {
            parentView
                .subviews
                .remove(at: labelPos)
        }
    }
    
    private func updateLabel() {
        textView?.reload()
    }

    private func updateGraph() {
        //NSLog("[oil] \(manager.title): running removeViewFromParentView()")
        if graphView.arrangedSubviews.contains(graph.view) {
            removeViewFromParentView(parentView: graphView,
                                     childView: graph.view)
        }
        //NSLog("[oil] \(manager.title): graph.resize()")
        graph.resize()
        graphView.addArrangedSubview(graph.view)
        //NSLog("[oil] \(manager.title): Exiting updateGraph()")
    }
}

