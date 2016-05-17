//
//  Protocols.swift
//  Pods
//
//  Created by AL TYUS on 3/20/16.
//
//

import Foundation

public protocol Param {
    var param: (key: String, value: AnyObject) {
        get
    }
}

extension Array where Element: Param {
    func toParams() -> [String: AnyObject] {
        var requestDictionary = [String: AnyObject]()
        for param in self {
            requestDictionary[param.param.key] = param.param.value
        }
        return requestDictionary
    }
}