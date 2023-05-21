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
    var enabled: Bool = true
    var title: String { return "CPUItem" }
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
        preferenceUpdate()
        updateLabel()
        if Defaults[.displayGraph] {
            graphRedraw()
        }
    }

    func didLoad() {
        configureStackView()
        enabled = true
    }

    func didUnload() {
        textView?.didUnload()
        //removeViewFromStackView(view: textView)
        removeViewFromStackView(view: graphView)
        enabled = false
    }
    
    /// Utility
    private func configureLabel(label: NSTextField) {
        label.font = NSFont.monospacedDigitSystemFont(ofSize: Defaults[.stackedText] ?
                                                        13 :
                                                        8,
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
        if Defaults[.displayGraph] {
            graphView.addArrangedSubview(graph.view)
            graphView.orientation = .horizontal
            graphView.alignment = .centerY
            graphView.distribution = .fillProportionally
            graphView.width(CGFloat(Defaults[.graphWidth] *
                                    Defaults[.graphLength]))
            stackView.addArrangedSubview(graphView)
        }
    }

    private func graphRedraw() {
        updateGraph()
        if !Defaults[.displayGraph] { return }
        graph.generateGraph(data: manager.usageHistory)
    }
    
    private func preferenceUpdate() {
        if Defaults[.displayGraph] &&
            !stackView.arrangedSubviews.contains(graphView) {
            stackView.addArrangedSubview(graphView)
        } else if !Defaults[.displayGraph] &&
                    stackView.arrangedSubviews.contains(graphView) {
            removeViewFromStackView(view: graphView)
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
    
    private func updateLabel() {
        textView?.reload()
    }

    
    private func updateGraph() {
        if graph.stepSize != Defaults[.graphWidth] ||
            graph.historyLength != Defaults[.graphLength] {
            graphView.removeArrangedSubview(graph.view)
            graphView.subviews.remove(at: 0)
            graph.resize()
            graphView.addArrangedSubview(graph.view)
        }
    }
}

