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
    @IBOutlet weak var showCpuNumber: NSButton!
    @IBOutlet weak var showCpuGraph: NSButton!
    
    func reset() {
        loadCheckboxState()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.superview?.wantsLayer = true
        self.view.wantsLayer = true
        self.loadCheckboxState()
    }
    
    private func loadCheckboxState() {
        self.showCpuNumber.state = Defaults[.shouldDisplayCpuNumber] ? .on : .off
        self.showCpuGraph.state = Defaults[.shouldDisplayCpuGraph] ? .on : .off
    }
    
    @IBAction func didChangeCheckboxValue(_ checkbox: NSButton) {
        var key: Defaults.Key<Bool>
        switch checkbox.tag {
            case 1:
                key = .shouldDisplayCpuNumber
            case 2:
                key = .shouldDisplayCpuGraph
            default:
                return
        }
        Defaults[key] = checkbox.state == .on
        loadCheckboxState()
    }
}
