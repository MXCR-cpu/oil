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

internal class CPUItem: StatusItem {
    private var system: System = System()
    private var barGraph: BarGraph = BarGraph()
    private var refreshTimer: Timer?
    private var run: Bool = true
    private var preferenceHistory: [Bool] = [true, true]
    private var usageHistory: [Double] = []
    private var stackView: NSStackView = NSStackView(frame: .zero)
    private var bodyView: NSStackView = NSStackView(frame: .zero)
    private var valueLabel: NSTextField = NSTextField(
        labelWithString: "-%"
    )
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
        let usage = system.usageCPU()
        valueLabel.stringValue = String(
            format: "%3.0f%%",
            usage.system + usage.user
        )
        valueLabel.sizeToFit()
        usageHistory = (
            usageHistory + [usage.system + usage.user]
        ).suffix(barGraph.historyLength)
    }

    func didLoad() {
        configureValueLabel()
        configureStackView()
        reload()
        repeatCall()
    }

    func didUnload() {
        run = false
    }
    
    /// Utility
    private func configureValueLabel() {
        valueLabel.font = NSFont.monospacedDigitSystemFont(
            ofSize: 13,
            weight: .regular
        )
        valueLabel.maximumNumberOfLines = 1
        valueLabel.sizeToFit()
    }

    private func configureStackView() {
        bodyView.addArrangedSubview(barGraph.view)
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(bodyView)
    }

    private func repeatCall() {
        reload()
        preferenceUpdate()
        graphRedraw()
        if run {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.repeatCall()
            }
        }
    }
    private func graphRedraw() {
        if !Defaults[.shouldDisplayCpuGraph] { return }
        barGraph.generateGraph(data: usageHistory)
    }
    
    private func preferenceUpdate() {
        if Defaults[.shouldDisplayCpuGraph] &&
            !stackView.arrangedSubviews.contains(bodyView) {
            stackView.addArrangedSubview(bodyView)
        } else if !Defaults[.shouldDisplayCpuGraph] && stackView.arrangedSubviews.contains(bodyView) {
            stackView.removeArrangedSubview(bodyView)
        }
        if Defaults[.shouldDisplayCpuNumber] &&
            !stackView.arrangedSubviews.contains(valueLabel) {
            stackView.insertArrangedSubview(valueLabel, at: 0)
        } else if !Defaults[.shouldDisplayCpuNumber] && stackView.arrangedSubviews.contains(valueLabel) {
            stackView.removeArrangedSubview(valueLabel)
        }
    }
}

