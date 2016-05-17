//
//  Extensions.swift
//  Pods
//
//  Created by AL TYUS on 3/19/16.
//
//

import Foundation

private enum DateFormatters {
    static let clubhouseDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
}

internal extension String {
    func toNSDate() -> NSDate? {
        return DateFormatters.clubhouseDateFormatter.dateFromString(self)
    }
}

internal extension NSURL {
    
    func URLByAppendingQueryParameters(parameters: [String: String]?) -> NSURL {
        guard let parameters = parameters,
            urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: true) else {
                return self
        }
        
        var mutableQueryItems: [NSURLQueryItem] = urlComponents.queryItems ?? []
        
        mutableQueryItems.appendContentsOf(parameters.map{ NSURLQueryItem(name: $0, value: $1) })
        
        urlComponents.queryItems = mutableQueryItems
        
        return urlComponents.URL!
    }
    
}