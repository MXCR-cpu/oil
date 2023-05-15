//
//  CPU.swift
//  oil
//
//  Created by Maximus on 5/14/23.
//

import Foundation
import AppKit
import SystemKit

internal class CPUItem: StatusItem {
    private var system: System = System()
    private var refreshTimer: Timer?
    private var run: Bool = true
    private var stackView: NSStackView = NSStackView(frame: .zero)
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
    
    func action() {
        
    }
    func reload() {
        let usage = system.usageCPU()
        valueLabel.stringValue = String(
            format: "%.0f%%",
            usage.system + usage.user
        )
        //valueLabel.stringValue = "\(System.loadAverage(.short)[0])"
        valueLabel.sizeToFit()
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
        stackView.spacing = 1
        stackView.addArrangedSubview(valueLabel)
    }
    private func repeatCall() {
        self.reload()
        if self.run {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.repeatCall()
            }
        }
    }
}

