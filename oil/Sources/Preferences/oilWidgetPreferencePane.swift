//
//  oilWidgetPreferencePane.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

//import Foundation
import Cocoa
import PockKit

class oilWidgetPreferencePane:
    NSViewController,
    NSTextFieldDelegate,
    PKWidgetPreference {
        static var nibName: NSNib.Name = "oilWidgetPreferencePane"
        
        @IBOutlet weak var showCpuNumber: NSButton!
        @IBOutlet weak var showCpuGraph: NSButton!
        
        func reset() {
            Preferences.reset()
            loadCheckboxState()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.superview?.wantsLayer = true
            self.view.wantsLayer = true
            self.loadCheckboxState()
        }
        
        private func loadCheckboxState() {
            self.showCpuNumber.state =
                Preferences[.shouldDisplayCpuNumber] ? .on : .off
            self.showCpuGraph.state =
                Preferences[.shouldDisplayCpuBarGraph] ? .on : .off
        }
        
        @IBAction func didChangeCheckboxValue(_ checkbox: NSButton) {
            var key: Preferences.Keys
            switch checkbox.tag {
                case 0:
                    key = .shouldDisplayCpuNumber
                case 1:
                    key = .shouldDisplayCpuBarGraph
                default:
                    return
            }
            Preferences[key] = checkbox.state == .on
            loadCheckboxState()
        }
}
