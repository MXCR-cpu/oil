//
//  Item.swift
//  oil
//
//  Created by Maximus on 5/14/23.
//

import Foundation
import PockKit
import AppKit

class StatusItemView: PKView {
    weak var item: StatusItem?
    override func didTapHandler() {
        item?.action()
    }
}

protocol StatusItem: AnyObject {
    var enabled: Bool   { get }
    var title:   String { get }
    var view:    NSView { get }
    func action()
    func reload()
    func didLoad()
    func didUnload()
}