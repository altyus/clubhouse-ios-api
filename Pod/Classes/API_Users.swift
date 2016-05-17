//
//  API_Users.swift
//  Pods
//
//  Created by AL TYUS on 3/26/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public extension ClubhouseAPI {
    enum UserRouter: URLRequestConvertible {
        case ListUsers
        case GetUser(userId: UUID)
        
        var method: Alamofire.Method {
            switch self {
            case .ListUsers, .GetUser:
                return .GET
            }
        }
        
        var path: String {
            switch self {
            case .ListUsers:
                return "users"
            case .GetUser(let userId):
                return "users/\(userId)"
            }
        }
        
        public var URLRequest: NSMutableURLRequest {
            let mutableURLRequest = ClubhouseAPI.URLRequest(method, path: path)
            
            switch self {
            default:
                return mutableURLRequest
            }
        }
    }
    
    func listUsers(success: ([User]) -> Void, failure: Failure) {
        request(UserRouter.ListUsers, success: { response in
            guard let users = User.objects(JSON(response).array) else {
                failure(nil)
                return
            }
            success(users)
            }, failure: { error in
                failure(error)
        })
    }
    
    func getUser(userId: String, success: (User) -> Void, failure: Failure) {
        request(UserRouter.GetUser(userId: userId), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(User(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
}