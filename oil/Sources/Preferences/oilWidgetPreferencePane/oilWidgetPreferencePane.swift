//
//  oilWidgetPreferencePane.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

//import Foundation
import Cocoa
import Defaults
import PockKit
import AppKit

class oilWidgetPreferencePane:
    NSViewController,
    PKWidgetPreference {
    static var nibName: NSNib.Name = "oilWidgetPreferencePane"
    @IBOutlet weak var refreshRate: NSComboBox!
    @IBOutlet weak var showCpuNumber: NSButton!
    @IBOutlet weak var showCpuGraph: NSButton!
    @IBOutlet weak var cpuGraphWidth: NSComboBox!
    @IBOutlet weak var cpuGraphBoxCount: NSComboBox!
    
    func reset() {
        loadBoxStates()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.superview?.wantsLayer = true
        self.view.wantsLayer = true
        self.loadBoxStates()
    }
    
    private func loadBoxStates() {
        self.refreshRate.enclosingMenuItem?.state = .init(rawValue: Defaults[.refreshRate])
        self.showCpuNumber.state = Defaults[.shouldDisplayCpuNumber] ? .on : .off
        self.showCpuGraph.state = Defaults[.shouldDisplayCpuGraph] ? .on : .off
        self.cpuGraphWidth.enclosingMenuItem?.state = .init(rawValue: Defaults[.cpuGraphWidth])
        self.cpuGraphBoxCount.enclosingMenuItem?.state = .init(rawValue: Defaults[.cpuGraphBoxCount])
    }
    
    @IBAction func didChangeCheckboxValue(_ checkbox: NSButton) {
        var key: Defaults.Key<Bool>
        switch checkbox.tag {
        case 2:
            key = .shouldDisplayCpuNumber
        case 3:
            key = .shouldDisplayCpuGraph
        default:
            return
        }
        Defaults[key] = checkbox.state == .on
        loadBoxStates()
    }
    
    @IBAction func didChangeComboBoxValue(_ combobox: NSComboBox) {
        var key: Defaults.Key<Int>
        var defaultValue: Int
        switch combobox.tag {
        case 1:
            key = .refreshRate
            defaultValue = 1
        case 31:
            key = .cpuGraphBoxCount
            defaultValue = 5
        case 32:
            key = .cpuGraphWidth
            defaultValue = 10
        default:
            return
        }
        Defaults[key] = Int(
            "\(combobox.objectValueOfSelectedItem ?? defaultValue)"
        ) ?? defaultValue
        loadBoxStates()
    }
}
