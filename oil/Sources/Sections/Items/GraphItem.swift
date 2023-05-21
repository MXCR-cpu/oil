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

internal class GraphItem: StatusItem {
    private var manager: Manager
    private var graph: Graph
    private var usageHistory: [Int] = []
    private var stackView: NSStackView = NSStackView(frame: .zero)
    private var graphView: NSStackView = NSStackView(frame: .zero)
    //private var textView: NSStackView = NSStackView(frame: .zero)
    private var textView: TextItem? = nil
    private var labelArray: [NSTextField] = []
    var enabled: Bool { return true }
    var title: String { return "CPUItem" }
    var view: NSView { return stackView }
    
    init(manager: Manager, graph: Graph) {
        self.manager = manager
        self.graph = graph
    }
    
    func action() {
        NSWorkspace.shared
            .open(URL(fileURLWithPath: "/Application/Activity Monitor.app"))
    }

    func reload() {
        preferenceUpdate()
        //manager.reload()
        updateLabel()
        graphRedraw()
    }

    func didLoad() {
        //manager.reload()
        configureStackView()
    }

    func didUnload() {}
    
    /// Utility
    private func configureLabel(label: NSTextField) {
        label.font = NSFont.monospacedDigitSystemFont(ofSize: Defaults[.stackedText] ?
                                                        13 :
                                                        8,
                                                      weight: .regular)
        label.maximumNumberOfLines = 1
        label.sizeToFit()
    }

    private func configureStackView() {
        /*
        if Defaults[.stackedText] {
            textView.orientation = .horizontal
            textView.distribution = .fillProportionally
            textView.alignment = .centerY
        } else {
            textView.orientation = .vertical
            textView.alignment = .right
        }
        textView.spacing = 3
        */
        textView = TextItem(manager: manager)
        textView?.didLoad()
        labelArray = manager.usageString?.compactMap {
            let textField = NSTextField(labelWithString: $0)
            configureLabel(label: textField)
            //textView.addArrangedSubview(textField)
            return textField
        } ?? []
        graphView.addArrangedSubview(graph.view)
        graphView.orientation = .horizontal
        graphView.alignment = .centerY
        graphView.distribution = .fillProportionally
        graphView.width(CGFloat(Defaults[.graphWidth] *
                               Defaults[.graphLength]))
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        //stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(textView?.view ??
                                     NSStackView(frame: .zero))
        stackView.addArrangedSubview(graphView)
    }

    private func graphRedraw() {
        updateGraph()
        if !Defaults[.displayGraph] { return }
        graph.generateGraph(data: manager.usageHistory)
    }
    
    private func preferenceUpdate() {
        if Defaults[.displayGraph] &&
            !stackView.arrangedSubviews.contains(graphView) {
            stackView.addArrangedSubview(graphView)
        } else if !Defaults[.displayGraph] &&
                    stackView.arrangedSubviews.contains(graphView) {
            removeViewFromStackView(view: graphView)
        }
        /*
        if Defaults[.shouldDisplayCpuNumber] &&
            !stackView.arrangedSubviews.contains(textView) {
            stackView.insertArrangedSubview(textView, at: 0)
        } else if !Defaults[.shouldDisplayCpuNumber] &&
                    stackView.arrangedSubviews.contains(textView) {
            removeViewFromStackView(view: textView)
        }
        */
    }
    
    private func removeViewFromStackView(view: NSView) {
        let labelPos: Int = stackView.arrangedSubviews.firstIndex(of: view) ?? -1
        stackView.removeArrangedSubview(view)
        if labelPos >= 0 {
            stackView.subviews.remove(at: labelPos)
        }
    }
    
    private func updateLabel() {
        /*
        guard let newStringArray = manager.usageString else {
            return
        }
        for idx in 0..<labelArray.count {
            labelArray[idx].stringValue = newStringArray[idx]
        }
        */
        textView?.reload()
    }

    
    private func updateGraph() {
        if graph.stepSize != Defaults[.graphWidth] ||
            graph.historyLength != Defaults[.graphLength] {
            graphView.removeArrangedSubview(graph.view)
            graphView.subviews.remove(at: 0)
            graph.resize()
            graphView.addArrangedSubview(graph.view)
        }
    }
}

