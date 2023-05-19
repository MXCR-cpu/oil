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

internal class CPUItem: StatusItem {
    private var system: System = System()
    private var barGraph: BarGraph = BarGraph()
    private var usage:
        (system: Double, user: Double, idle: Double, nice: Double) = (0.0, 0.0, 0.0, 0.0)
    private var temp: Double? = nil
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
    
    func action() {}

    func reload() {
        usage = system.usageCPU()
        usageHistory = (
            usageHistory + [Int((usage.system + usage.user))]
        ).suffix(barGraph.historyLength)
        SmcControl.shared.refresh()
        temp = (SmcControl.shared.cpuDieTemperature ?? 0) > 0 ?
            SmcControl.shared.cpuDieTemperature :
            SmcControl.shared.cpuProximityTemperature
        NSLog("[oil] CPU temp: \(String(describing: temp))")
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
        bodyView.addArrangedSubview(barGraph.view)
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
        barGraph.generateGraph(data: usageHistory)
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
            Int(usage.system + usage.user)
        )
    }
    
    private func updateTempLabel() {
        tempLabel.stringValue = String(
            format: "%02.01f°C",
            temp ?? 0.0
        )
    }
    
    private func updateGraph() {
        if barGraph.stepSize != Defaults[.cpuGraphWidth] ||
            barGraph.historyLength != Defaults[.cpuGraphBoxCount] {
            bodyView.removeArrangedSubview(barGraph.view)
            bodyView.subviews.remove(at: 0)
            barGraph = BarGraph()
            bodyView.addArrangedSubview(barGraph.view)
        }
    }
}

