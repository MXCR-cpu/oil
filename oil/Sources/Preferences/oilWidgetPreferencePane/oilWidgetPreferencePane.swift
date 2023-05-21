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
    @IBOutlet weak var stackedText: NSButton!
    @IBOutlet weak var refreshRate: NSComboBox!
    @IBOutlet weak var graphLength: NSComboBox!
    @IBOutlet weak var graphWidth: NSComboBox!
    @IBOutlet weak var graphType: NSPopUpButton!
    @IBOutlet weak var useCPU: NSButton!
    @IBOutlet weak var useGPU: NSButton!
    @IBOutlet weak var useFan: NSButton!
    @IBOutlet weak var useMemory: NSButton!
    @IBOutlet weak var useDisk: NSButton!
    
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
        self.stackedText.state = Defaults[.stackedText] ? .on : .off
        self.refreshRate.enclosingMenuItem?.state =
            .init(rawValue: Defaults[.refreshRate])
        self.graphLength.enclosingMenuItem?.state =
            .init(rawValue: Defaults[.graphLength])
        self.graphWidth.enclosingMenuItem?.state =
            .init(rawValue: Defaults[.graphWidth])
        self.graphType.enclosingMenuItem?.state =
            .init(rawValue: Defaults[.graphType].rawValue)
        self.useCPU.state = (Defaults[.itemsDisplay] & (1 << 0)) != 0 ? .on : .off
        self.useGPU.state = (Defaults[.itemsDisplay] & (1 << 1)) != 0 ? .on : .off
        self.useFan.state = (Defaults[.itemsDisplay] & (1 << 2)) != 0 ? .on : .off
        self.useMemory.state = (Defaults[.itemsDisplay] & (1 << 3)) != 0 ? .on : .off
        self.useDisk.state = (Defaults[.itemsDisplay] & (1 << 4)) != 0 ? .on : .off
    }
    
    @IBAction func didChangeCheckboxValue(_ checkbox: NSButton) {
        switch checkbox.tag {
        case 1:
            Defaults[.stackedText] = checkbox.state == .on
        default:
            Defaults[.itemsDisplay] = Defaults[.itemsDisplay] ^ (1 << (checkbox.tag - 41))
        }
        loadBoxStates()
    }
    
    @IBAction func didChangeComboboxValue(_ combobox: NSComboBox) {
        switch combobox.tag {
        case 2:
            Defaults[.refreshRate] = combobox.enclosingMenuItem?.state.rawValue ??
                Defaults[.refreshRate]
        case 31:
            Defaults[.graphLength] = combobox.enclosingMenuItem?.state.rawValue ??
                Defaults[.graphLength]
        case 32:
            Defaults[.graphWidth] = combobox.enclosingMenuItem?.state.rawValue ??
                Defaults[.graphWidth]
        default:
            return
        }
        loadBoxStates()
    }
    
    @IBAction func didChangePopupValue(_ popup: NSPopUpButton) {
        Defaults[.graphType] = GraphType(rawValue: popup.enclosingMenuItem?.state.rawValue ?? 1) ??
            Defaults[.graphType]
        loadBoxStates()
    }
}
        
    /*
    @IBOutlet weak var refreshRate: NSComboBox!
    @IBOutlet weak var showCpuNumber: NSButton!
    @IBOutlet weak var showCpuGraph: NSButton!
    @IBOutlet weak var cpuGraphWidth: NSComboBox!
    @IBOutlet weak var cpuGraphBoxCount: NSComboBox!
    @IBOutlet weak var cpuGraphType: NSPopUpButton!
    @IBOutlet weak var cpuGraphFunction: NSPopUpButton!
    @IBOutlet weak var showCpuTemp: NSButton!
    @IBOutlet weak var showGpuNumber: NSButton!
    @IBOutlet weak var showGpuGraph: NSButton!
    @IBOutlet weak var gpuGraphWidth: NSComboBox!
    @IBOutlet weak var gpuGraphBoxCount: NSComboBox!
    @IBOutlet weak var gpuGraphType: NSPopUpButton!
    @IBOutlet weak var gpuGraphFunction: NSPopUpButton!
    
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
        self.refreshRate.enclosingMenuItem?.state = .init(
            rawValue: Defaults[.refreshRate]
        )
        self.showCpuNumber.state = Defaults[.shouldDisplayCpuNumber] ? .on : .off
        self.showCpuGraph.state = Defaults[.shouldDisplayCpuGraph] ? .on : .off
        self.cpuGraphWidth.enclosingMenuItem?.state = .init(
            rawValue: Defaults[.cpuGraphWidth]
        )
        self.cpuGraphBoxCount.enclosingMenuItem?.state = .init(
            rawValue: Defaults[.cpuGraphBoxCount]
        )
        self.cpuGraphType.enclosingMenuItem?.state = .init(
            rawValue: Defaults[.cpuGraphType].rawValue
        )
        self.cpuGraphFunction.enclosingMenuItem?.state = .init(
            rawValue: Defaults[.cpuGraphFunction].rawValue
        )
        self.showCpuTemp.state = Defaults[.shouldDisplayCpuTemp] ? .on : .off
    }
    
    @IBAction func didChangeCheckboxValue(_ checkbox: NSButton) {
        var key: Defaults.Key<Bool>
        switch checkbox.tag {
        case 2:
            key = .shouldDisplayCpuNumber
        case 3:
            key = .shouldDisplayCpuGraph
        case 4:
            key = .shouldDisplayCpuTemp
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
    
    @IBAction func didChangeComboBoxValueGraphType(_ popupbutton: NSPopUpButton) {
        Defaults[.cpuGraphType] = GraphType(
            rawValue: popupbutton.tag - 330
        ) ?? .bar
        loadBoxStates()
    }

    @IBAction func didChangeComboBoxValueGraphFunction(_ popupbutton: NSPopUpButton) {
        Defaults[.cpuGraphFunction] = GraphFunction(
            rawValue: popupbutton.tag - 340
        ) ?? .linear
        loadBoxStates()
    }
    */
