//
//  Manager.swift
//  oil
//
//  Created by Maximus on 5/18/23.
//

import Foundation

protocol Manager {
    var usage: Int? { get }
    var temp: Int? { get }
    var usageHistory: [Int] { get }
    init()
    func reload()
}
