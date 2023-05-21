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
    case horizon = 4
}
