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
    private var run: Bool = true
    private var usageHistory: [Int] = []
    private var stackView: NSStackView = NSStackView(frame: .zero)
    private var bodyView: NSStackView = NSStackView(frame: .zero)
    private var valueLabel: NSTextField =
        NSTextField(labelWithString: "-%")
    private var tempLabel: NSTextField =
        NSTextField(labelWithString: "-")
    var enabled: Bool {
        return true
    }
    var title: String {
        return "CPUItem"
    }
    var view: NSView {
        return stackView
    }
    
    init(manager: Manager, graph: Graph) {
        self.manager = manager
        self.graph = graph
    }
    
    func action() {}

    func reload() {
        manager.reload()
        updateValueLabel()
        updateTempLabel()
        preferenceUpdate()
        graphRedraw()
    }

    func didLoad() {
        configureLabel(label: valueLabel)
        configureLabel(label: tempLabel)
        configureStackView()
        reload()
    }

    func didUnload() {
        run = false
    }
    
    /// Utility
    private func configureLabel(label: NSTextField) {
        label.font = NSFont.monospacedDigitSystemFont(
            ofSize: 13,
            weight: .regular
        )
        label.maximumNumberOfLines = 1
        label.sizeToFit()
    }

    private func configureStackView() {
        bodyView.addArrangedSubview(graph.view)
        bodyView.orientation = .horizontal
        bodyView.alignment = .centerY
        bodyView.distribution = .fillProportionally
        bodyView.width(CGFloat(Defaults[.cpuGraphWidth] * Defaults[.cpuGraphBoxCount]))
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(bodyView)
    }

    private func graphRedraw() {
        updateGraph()
        if !Defaults[.shouldDisplayCpuGraph] { return }
        graph.generateGraph(data: manager.usageHistory)
    }
    
    private func preferenceUpdate() {
        if Defaults[.shouldDisplayCpuGraph] &&
            !stackView.arrangedSubviews.contains(bodyView) {
            stackView.addArrangedSubview(bodyView)
        } else if !Defaults[.shouldDisplayCpuGraph] && stackView.arrangedSubviews.contains(bodyView) {
            removeViewFromStackView(view: bodyView)
        }
        if Defaults[.shouldDisplayCpuNumber] &&
            !stackView.arrangedSubviews.contains(valueLabel) {
            stackView.insertArrangedSubview(valueLabel, at: 0)
        } else if !Defaults[.shouldDisplayCpuNumber] && stackView.arrangedSubviews.contains(valueLabel) {
            removeViewFromStackView(view: valueLabel)
        }
    }
    
    private func removeViewFromStackView(view: NSView) {
        let labelPos: Int = stackView.arrangedSubviews.firstIndex(of: view) ?? -1
        stackView.removeArrangedSubview(view)
        if labelPos >= 0 {
            stackView.subviews.remove(at: labelPos)
        }
    }
    
    private func updateValueLabel() {
        valueLabel.stringValue = String(
            format: "%02d%%",
            manager.usage ?? 0
        )
    }
    
    private func updateTempLabel() {
        tempLabel.stringValue = String(
            format: "%02.01f°C",
            manager.temp ?? 0.0
        )
    }
    
    private func updateGraph() {
        if graph.stepSize != Defaults[.cpuGraphWidth] ||
            graph.historyLength != Defaults[.cpuGraphBoxCount] {
            bodyView.removeArrangedSubview(graph.view)
            bodyView.subviews.remove(at: 0)
            graph.resize()
            bodyView.addArrangedSubview(graph.view)
        }
    }
}

