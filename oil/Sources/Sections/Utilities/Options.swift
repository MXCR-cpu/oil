//
//  Options.swift
//  oil
//
//  Created by Maximus on 5/16/23.
//

import Foundation
import Defaults

enum GraphType: Int, Defaults.Serializable {
    case bar = 1
    case line = 2
    case spline = 3
}

enum GraphFunction: Int, Defaults.Serializable {
    case linear = 1
    case squareRoot = 2
}

enum DisplayText: Int, Defaults.Serializable {
    case line = 1
    case stacked = 2
}
