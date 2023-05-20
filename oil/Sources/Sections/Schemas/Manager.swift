//
//  Manager.swift
//  oil
//
//  Created by Maximus on 5/18/23.
//

import Foundation

protocol Manager {
    var title: String { get }
    var usage: Int? { get }
    var usageString: [String]? { get }
    var usageHistory: [Int] { get }
    var temp: Double? { get }
    func reload()
}
