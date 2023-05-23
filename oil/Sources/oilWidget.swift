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
        viewWillDisappear()
        clearItems()
    }
    
    func viewDidAppear() {
        run = true
        loadStatusElement()
        reloadCall()
    }
    
    func viewWillDisappear() {
        run = false
        clearItems()
    }
    
    func clearItems() {
        //NSLog("[oil] clearItems(): iterating over arranged subviews")
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        //NSLog("[oil] clearItems(): iterating over loadedItems")
        for item in loadedItems {
            item.didUnload()
        }
        loadedItems.removeAll()
        //NSLog("[oil] clearItems(): Exiting")
    }
    
    private func reloadCall() {
        var updateRecall: Bool = false
        SmcControl.shared.refresh()
        for item in loadedItems {
            if item.update {
                item.updateCall()
                updateRecall = true
            }
            switch ((Defaults[.itemsDisplay] & item.manager.id != 0) ? 2 : 0) | (item.enabled ? 1 : 0) {
            case 1:
                item.didUnload()
            case 2:
                item.didLoad()
            case 3:
                item.reload()
            default: break
            }
        }
        if updateRecall {
            //NSLog("[oil] running updateRecall condition")
            clearItems()
            loadStatusElement()
        }
        if run {
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + Double(Defaults[.refreshRate])) {
                self.reloadCall()
            }
        }
    }
    
    @objc private func loadStatusElement() {
        clearItems()
        let items: [StatusItem] = [
            GraphItem(manager: CPUManager(), graph: preferenceGraph()),
            GraphItem(manager: GPUManager(), graph: preferenceGraph()),
            TextItem(manager: FanManager()),
            TextItem(manager: MemoryManager()),
            TextItem(manager: DiskManager())
        ]
        for item in items {
            item.didLoad()
            loadedItems.append(item)
            stackView.addArrangedSubview(item.view)
        }
        stackView.height(30)
    }

    private func preferenceGraph() -> Graph {
        switch Defaults[.graphType] {
        case .base:
            return Graph()
        case .bar:
            return BarGraph()
        case .line:
            return LineGraph()
        case .spline:
            return Graph()
        case .horizon:
            return Graph()
        }
    }
}
