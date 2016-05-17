//
//  ClubhouseAPI.swift
//  Pods
//
//  Created by Al Tyus on 3/13/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public class ClubhouseAPI {
    // MARK: -  Types
    
    public typealias SuccessList = ([AnyObject]) -> Void
    public typealias SuccessObject = (JSON) -> Void
    public typealias Failure = (ErrorType?) -> Void
    
    // MARK: -  Properties
    
    public static let sharedInstance: ClubhouseAPI = ClubhouseAPI()
    
    internal let baseURLString = "https://api.clubhouse.io/api/v1/"
    public var apiToken: String?
    
    // MARK: - Initializers
    
    public class func configure(apiToken: String) {
        ClubhouseAPI.sharedInstance.apiToken = apiToken
    }
   
    //MARK: - Functions
   
    public static func URLRequest(method: Alamofire.Method, path: String) -> NSMutableURLRequest {
        guard let apiToken = ClubhouseAPI.sharedInstance.apiToken, baseURL = NSURL(string: ClubhouseAPI.sharedInstance.baseURLString) else {
            fatalError("Token must be set")
        }
        let URL = baseURL.URLByAppendingPathComponent(path).URLByAppendingQueryParameters(["token": apiToken])
        let mutableURLReuqest = NSMutableURLRequest(URL: URL)
        mutableURLReuqest.HTTPMethod = method.rawValue
        
        return mutableURLReuqest
    }
    
    internal func request(request: URLRequestConvertible, success: (AnyObject) -> Void, failure: Failure) {
        Alamofire.request(request)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    success(value)
                case .Failure(let error):
                    failure(error)
                }
        }
    }
   
}
