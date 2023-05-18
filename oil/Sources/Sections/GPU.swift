//
//  GPU.swift
//  oil
//
//  Created by Maximus on 5/17/23.
//

import Foundation
import AppKit
import Defaults
import IOKit
//import os

internal class GPUItem: StatusItem {
    /*
    private var logger: Logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "GPU_oil"
    )
    */
    private var gpu: GPUConnection = GPUConnection()
    private var barGraph: BarGraph = BarGraph(
        stepSize: Defaults[.gpuGraphWidth],
        historyLength: Defaults[.gpuGraphBoxCount])
    private var refreshTimer: Timer?
    private var run: Bool = true
    private var usageHistory: [Int] = []
    private var stackView: NSStackView = NSStackView(frame: .zero)
    private var bodyView: NSStackView = NSStackView(frame: .zero)
    private var valueLabel: NSTextField = NSTextField(
        labelWithString: "-%"
    )
    var enabled: Bool {
        return true
    }
    var title: String {
        return "GPUItem"
    }
    var view: NSView {
        return stackView
    }
    
    func action() {}

    func reload() {
        gpu.reload()
        usageHistory = (
            usageHistory + [(gpu.usage ?? 0)]
        ).suffix(barGraph.historyLength)
        updateLabel()
        updateGraph()
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
    
    private func repeatCall() {
        reload()
        preferenceUpdate()
        graphRedraw()
        if run {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + Double(Defaults[.refreshRate])
            ) {
                self.repeatCall()
            }
        }
    }
    
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
        bodyView.orientation = .horizontal
        bodyView.alignment = .centerY
        bodyView.distribution = .fillProportionally
        bodyView.width(CGFloat(Defaults[.gpuGraphWidth] * Defaults[.gpuGraphBoxCount]))
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(bodyView)
    }
    
    private func graphRedraw() {
        if !Defaults[.shouldDisplayGpuGraph] { return }
        barGraph.generateGraph(data: usageHistory)
    }
    
    private func preferenceUpdate() {
        if Defaults[.shouldDisplayGpuGraph] &&
            !stackView.arrangedSubviews.contains(bodyView) {
            stackView.addArrangedSubview(bodyView)
        } else if !Defaults[.shouldDisplayGpuGraph] && stackView.arrangedSubviews.contains(bodyView) {
            removeViewFromStackView(view: bodyView)
        }
        if Defaults[.shouldDisplayGpuNumber] &&
            !stackView.arrangedSubviews.contains(valueLabel) {
            stackView.insertArrangedSubview(valueLabel, at: 0)
        } else if !Defaults[.shouldDisplayGpuNumber] && stackView.arrangedSubviews.contains(valueLabel) {
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
    
    private func updateLabel() {
        valueLabel.stringValue = String(
            format: "%02d%%",
            gpu.usage ?? 0
        )
    }
    
    private func updateGraph() {
        if barGraph.stepSize != Defaults[.gpuGraphWidth] ||
            barGraph.historyLength != Defaults[.gpuGraphBoxCount] {
            bodyView.removeArrangedSubview(barGraph.view)
            bodyView.subviews.remove(at: 0)
            barGraph = BarGraph(
                stepSize: Defaults[.gpuGraphWidth],
                historyLength: Defaults[.gpuGraphBoxCount])
            bodyView.addArrangedSubview(barGraph.view)
        }
    }
}
