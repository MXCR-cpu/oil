//
//  Preferences.swift
//  oil
//
//  Created by Maximus on 5/15/23.
//

import Foundation
import Defaults

/*
internal struct Preferences {
    internal enum Keys: String {
        case shouldDisplayCpuNumber
        case shouldDisplayCpuBarGraph
    }
    
    static subscript<T>(_ key: Keys) -> T {
        get {
            guard let value = UserDefaults.standard.value(
                forKey: key.rawValue
            ) as? T else {
                switch key {
                    case .shouldDisplayCpuNumber:
                        return true as! T
                    case .shouldDisplayCpuBarGraph:
                        return true as! T
                }
            }
            return value
        }
        set {
            UserDefaults.standard.setValue(
                newValue,
                forKey: key.rawValue
            )
        }
    }
    
    static func reset() {
        Preferences[.shouldDisplayCpuNumber] = true
        Preferences[.shouldDisplayCpuBarGraph] = true
    }
}
*/

extension Defaults.Keys {
    static let shouldDisplayCpuNumber = Defaults.Key<Bool>("shouldDisplayCpuNumber", default: false)
    static let shouldDisplayCpuNumber = Defaults.Key<Bool>("shouldDisplayCpuNumber", default: false
}
