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
    private var manager: Manager
    private var graph: Graph
    private var usageHistory: [Int] = []
    private var stackView: NSStackView = NSStackView(frame: .zero)
    private var graphView: NSStackView = NSStackView(frame: .zero)
    private var textView: NSStackView = NSStackView(frame: .zero)
    //private var label: NSTextField = NSTextField(labelWithString: "NaN")
    private var labelArray: [NSTextField] = []
    var enabled: Bool { return true }
    var title: String { return "CPUItem" }
    var view: NSView { return stackView }
    
    init(manager: Manager, graph: Graph) {
        self.manager = manager
        self.graph = graph
    }
    
    func action() {}

    func reload() {
        preferenceUpdate()
        manager.reload()
        updateLabel()
        graphRedraw()
    }

    func didLoad() {
        manager.reload()
        configureStackView()
        //configureLabel(label: label)
    }

    func didUnload() {}
    
    /// Utility
    private func configureLabel(label: NSTextField) {
        switch Defaults[.textDisplay] {
        case .line:
            label.font = NSFont.monospacedDigitSystemFont(
                ofSize: 13,
                weight: .regular
            )
        case .stacked:
            label.font = NSFont.monospacedDigitSystemFont(
                ofSize: 8,
                weight: .regular
            )
        }
        label.maximumNumberOfLines = 1
        label.sizeToFit()
    }

    private func configureStackView() {
        switch Defaults[.textDisplay] {
        case .line:
            textView.orientation = .horizontal
            textView.distribution = .fillProportionally
            textView.alignment = .centerY
        case .stacked:
            textView.orientation = .vertical
            textView.alignment = .right
        }
        textView.spacing = 3
        labelArray = manager.usageString?.compactMap {
            let textField = NSTextField(labelWithString: $0)
            configureLabel(label: textField)
            textView.addArrangedSubview(textField)
            return textField
        } ?? []
        graphView.addArrangedSubview(graph.view)
        graphView.orientation = .horizontal
        graphView.alignment = .centerY
        graphView.distribution = .fillProportionally
        graphView.width(CGFloat(Defaults[.cpuGraphWidth] *
                               Defaults[.cpuGraphBoxCount]))
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(graphView)
    }

    private func graphRedraw() {
        updateGraph()
        if !Defaults[.shouldDisplayCpuGraph] { return }
        graph.generateGraph(data: manager.usageHistory)
    }
    
    private func preferenceUpdate() {
        if Defaults[.shouldDisplayCpuGraph] &&
            !stackView.arrangedSubviews.contains(graphView) {
            stackView.addArrangedSubview(graphView)
        } else if !Defaults[.shouldDisplayCpuGraph] &&
                    stackView.arrangedSubviews.contains(graphView) {
            removeViewFromStackView(view: graphView)
        }
        if Defaults[.shouldDisplayCpuNumber] &&
            !stackView.arrangedSubviews.contains(textView) {
            stackView.insertArrangedSubview(textView, at: 0)
        } else if !Defaults[.shouldDisplayCpuNumber] &&
                    stackView.arrangedSubviews.contains(textView) {
            removeViewFromStackView(view: textView)
        }
    }
    
    private func removeViewFromStackView(view: NSView) {
        let labelPos: Int = stackView.arrangedSubviews.firstIndex(of: view) ?? -1
        stackView.removeArrangedSubview(view)
        if labelPos >= 0 {
            stackView.subviews.remove(at: labelPos)
        }
    }
    
    private func updateLabel() {
        guard let newStringArray = manager.usageString else {
            return
        }
        for idx in 0..<labelArray.count {
            labelArray[idx].stringValue = newStringArray[idx]
        }
    }

    
    private func updateGraph() {
        if graph.stepSize != Defaults[.cpuGraphWidth] ||
            graph.historyLength != Defaults[.cpuGraphBoxCount] {
            graphView.removeArrangedSubview(graph.view)
            graphView.subviews.remove(at: 0)
            graph.resize()
            graphView.addArrangedSubview(graph.view)
        }
    }
}

