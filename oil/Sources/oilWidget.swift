//
//  oilWidget.swift
//  oil
//
//  Created by Maximus on 5/14/23.
//  
//

import Foundation
import Defaults
import AppKit
import PockKit
import SystemKit
import TinyConstraints

class oilWidget: PKWidget {
    static var identifier: String = "mxcr.cpu.oil"
    var customizationLabel: String = "oil"
    var run: Bool = true
    var view: NSView!
    private var stackView: NSStackView {
        return view as! NSStackView
    }
    private var loadedItems: [StatusItem] = []
    
    required init() {
        self.view = NSStackView(frame: .zero)
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fill
        stackView.spacing = 5
    }
    
    deinit {
        clearItems()
    }
    
    func viewDidAppear() {
        loadStatusElement()
    }
    
    func viewWillDisappear() {
        clearItems()
    }
    
    func clearItems() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for item in loadedItems {
            item.didUnload()
        }
        loadedItems.removeAll()
    }
    
    private func reloadCall() {
        SmcControl.shared.refresh()
        for item in loadedItems {
            item.reload()
        }
        if run {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + Double(Defaults[.refreshRate])
            ) {
                self.reloadCall()
            }
        }
    }
    
    @objc private func loadStatusElement() {
        clearItems()
        let items: [StatusItem] = [
            GraphItem(manager: CPUManager(), graph: BarGraph()),
            GraphItem(manager: GPUManager(), graph: BarGraph())
        ]
        for item in items {
            item.didLoad()
            loadedItems.append(item)
            stackView.addArrangedSubview(item.view)
        }
        stackView.height(30)
        reloadCall()
    }
    
    @objc private func printMessage() {
        NSLog("[oilWidget]: Hello, World!")
    }
    
}
