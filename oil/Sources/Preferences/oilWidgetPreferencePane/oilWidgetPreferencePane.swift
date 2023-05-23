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
    @IBOutlet weak var displayGraph: NSButton!
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
        self.refreshRate.stringValue = "\(Defaults[.refreshRate])"
        self.displayGraph.state = Defaults[.displayGraph] ? .on : .off
        self.graphLength.stringValue = "\(Defaults[.graphLength])"
        self.graphWidth.stringValue = "\(Defaults[.graphWidth])"
        self.graphType.selectItem(withTag: Defaults[.graphType].rawValue + 330)
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
        case 3:
            Defaults[.displayGraph] = checkbox.state == .on
        default:
            Defaults[.itemsDisplay] =
                Defaults[.itemsDisplay] ^ (1 << (checkbox.tag - 41))
        }
        loadBoxStates()
    }
    
    @IBAction func didChangeComboboxValue(_ combobox: NSComboBox) {
        switch combobox.tag {
        case 2:
            Defaults[.refreshRate] = Int(combobox.stringValue) ?? 1
        case 31:
            Defaults[.graphLength] = Int(combobox.stringValue) ?? 5
        case 32:
            Defaults[.graphWidth] = Int(combobox.stringValue) ?? 10
        default:
            return
        }
        loadBoxStates()
    }
    
    @IBAction func didChangePopupValue(_ popup: NSPopUpButton) {
        NSLog("[oil] change the Pop Up Value")
        switch popup.selectedItem?.tag ?? 331 {
        case 331:
            Defaults[.graphType] = .bar
        case 332:
            Defaults[.graphType] = .line
        case 333:
            Defaults[.graphType] = .spline
        case 334:
            Defaults[.graphType] = .horizon
        default:
            break
        }
        loadBoxStates()
    }
}
