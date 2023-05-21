//
//  TextItem.swift
//  oil
//
//  Created by Maximus on 5/19/23.
//

import Foundation
import AppKit
import SwiftUI
import Defaults

internal class TextItem: StatusItem {
    var manager: Manager
    private var stackView: NSStackView =
        NSStackView(frame: NSRect(x: 0,
                                  y: 0,
                                  width: 18,
                                  height: 18))
    private var label: NSTextField =
        NSTextField(labelWithString: "NaN")
    private var labelArray: [NSTextField] = []
    var enabled: Bool = true
    var title: String { return "TextItem" }
    var view: NSView { return stackView }
    
    init(manager: Manager) {
        self.manager = manager
    }
    
    func action() {}
    
    func reload() {
        manager.reload()
        updateLabel()
        preferenceUpdate()
    }
    
    func didLoad() {
        manager.reload()
        configureStackView()
        enabled = true
    }
    
    func didUnload() {
        for label in labelArray {
            removeViewFromStackView(view: label)
        }
        enabled = false
    }
    
    private func configureLabel(label: NSTextField) {
        label.font = NSFont.monospacedDigitSystemFont(ofSize: Defaults[.stackedText] ?
                                                        8 :
                                                        13,
                                                      weight: .regular)
        label.sizeToFit()
    }
    
    private func configureStackView() {
        if Defaults[.stackedText] {
            stackView.orientation = .vertical
            stackView.alignment = .right
        } else {
            stackView.orientation = .horizontal
            stackView.distribution = .fillProportionally
            stackView.alignment = .centerY
        }
        stackView.spacing = 3
        labelArray = manager.usageString?.compactMap {
            let textField = NSTextField(labelWithString: $0)
            configureLabel(label: textField)
            stackView.addArrangedSubview(textField)
            return textField
        } ?? []
    }

    private func preferenceUpdate() {}

    private func updateLabel() {
        guard let newStringArray = manager.usageString else {
            return
        }
        for idx in 0..<labelArray.count {
            labelArray[idx].stringValue = newStringArray[idx]
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

}
