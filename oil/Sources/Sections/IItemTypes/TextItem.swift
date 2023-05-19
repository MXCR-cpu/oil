//
//  TextItem.swift
//  oil
//
//  Created by Maximus on 5/19/23.
//

import Foundation
import AppKit

internal class TextItem: StatusItem {
    private var manager: Manager
    private var stackView: NSStackView = NSStackView(frame: .zero)
    private var valueLabel: NSTextField =
        NSTextField(labelWithString: "-%")
    var enabled: Bool { return true }
    var title: String { return "TextItem" }
    var view: NSView { return stackView }
    
    init(manager: Manager) {
        self.manager = manager
    }
    
    func action() {}
    
    func reload() {
        manager.reload()
        updateValueLabel()
        preferenceUpdate()
    }
    
    func didLoad() {
        configureLabel(label: valueLabel)
        configureStackView()
        reload()
    }
    
    func didUnload() {}
    
    private func configureLabel(label: NSTextField) {
        label.font = NSFont.monospacedDigitSystemFont(
            ofSize: 13,
            weight: .regular
        )
        label.maximumNumberOfLines = 1
        label.sizeToFit()
    }
    
    private func configureStackView() {
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.addArrangedSubview(valueLabel)
    }

    private func preferenceUpdate() {}

    private func updateValueLabel() {
        valueLabel.stringValue = manager.usageString ?? "NaN"
    }
}
