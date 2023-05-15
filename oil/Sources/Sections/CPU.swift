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

internal class CPUItem: StatusItem {
    private var system: System = System()
    private var refreshTimer: Timer?
    private var step_size: Int = 10
    private var history_length: Int = 5
    private var run: Bool = true
    private var usageHistory: [Double] = []
    private var stackView: NSStackView = NSStackView(frame: .zero)
    private var bodyView: NSStackView = NSStackView(frame: .zero)
    private var boxView: NSView = NSView(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
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
            format: "%.0f%%",
            usage.system + usage.user
        )
        valueLabel.sizeToFit()
        usageHistory = (
            usageHistory + [usage.system + usage.user]
        ).suffix(self.history_length)
    }

    func didLoad() {
        configureValueLabel()
        configureStackView()
        reload()
        repeatCall()
    }

    func didUnload() {
        self.run = false
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
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(bodyView)
        bodyView.addArrangedSubview(boxView)
    }

    private func repeatCall() {
        self.reload()
        self.graphRedraw()
        if self.run {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.repeatCall()
            }
        }
    }
    private func graphRedraw() {
        for i in 0...(self.usageHistory.count-1) {
            let boxLayer: CALayer = CALayer()
            boxLayer.frame = NSRect(
                x: self.step_size * i,
                y: 0,
                width: self.step_size,
                height: max(
                    Int(18 * (self.usageHistory[self.usageHistory.count-1-i] / 100)),
                    1
                )
            )
            boxLayer.backgroundColor = NSColor.white.cgColor
            boxLayer.borderWidth = 0.0
            boxView.layer?.addSublayer(boxLayer)
            if let old_layer = boxView.layer?.sublayers?[i] {
                boxView.layer?.replaceSublayer(old_layer, with: boxLayer)
            } else {
                boxView.layer?.addSublayer(boxLayer)
            }
        }
        boxView.layer?.backgroundColor = NSColor.clear.cgColor
    }
}

