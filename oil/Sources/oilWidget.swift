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
        let cpu_item = GraphItem(manager: CPUManager(), graph: BarGraph())
        cpu_item.didLoad()
        loadedItems.append(cpu_item)
        stackView.addArrangedSubview(cpu_item.view)
        let gpu_item = GraphItem(manager: GPUManager(), graph: BarGraph())
        gpu_item.didLoad()
        loadedItems.append(gpu_item)
        stackView.addArrangedSubview(gpu_item.view)
        stackView.height(30)
        reloadCall()
    }
    
    @objc private func printMessage() {
        NSLog("[oilWidget]: Hello, World!")
    }
    
}
