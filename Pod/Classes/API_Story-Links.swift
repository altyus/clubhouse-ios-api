//
//  API_Story-Links.swift
//  Pods
//
//  Created by AL TYUS on 3/27/16.
//
//

import Foundation
import SwiftyJSON
import Alamofire

public enum StoryLinkParam: Param {
    case Object(Int)
    case Verb(String)
    case Subject(Int)
    
    public var param: (key: String, value: AnyObject) {
        switch self {
        case .Object(let object):
            return ("object", object)
        case .Verb(let verb):
            return ("verb", verb)
        case .Subject(let subject):
            return ("subject", subject)
        }
    }
}
public extension ClubhouseAPI {
    enum StoryLinkRouter: URLRequestConvertible {
        case CreateStoryLink(params: [String: AnyObject])
        case GetStoryLink(storyLinkId: Int)
        case DeleteStoryLink(storyLinkId: Int)
        
        var method: Alamofire.Method {
            switch self {
            case .CreateStoryLink:
                return .POST
            case .GetStoryLink:
                return .GET
            case .DeleteStoryLink:
                return .DELETE
            }
        }
        
        var path: String {
            switch self {
            case .CreateStoryLink:
                return "story-links"
            case .GetStoryLink(let storyLinkId):
                return "story-links/\(storyLinkId)"
            case .DeleteStoryLink(let storyLinkId):
               return "story-links/\(storyLinkId)"
            }
        }
        public var URLRequest: NSMutableURLRequest {
            let mutableURLRequest = ClubhouseAPI.URLRequest(method, path: path)
            
            switch self {
            case .CreateStoryLink(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
            }
        }
    }
    
    func createStoryLink(object: Int, verb: Verb, subject: Int, success: (StoryLink) -> Void, failure: Failure) {
        
        let params = [StoryLinkParam.Object(object), StoryLinkParam.Subject(subject), StoryLinkParam.Verb(verb.rawValue)]
        request(StoryLinkRouter.CreateStoryLink(params: params.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(StoryLink(json: JSON(response)))
            }, failure: { error in
        })
    }
    
    func getStoryLink(storyLinkId: Int, success: (StoryLink) -> Void, failure: Failure) {
        request(StoryLinkRouter.GetStoryLink(storyLinkId: storyLinkId), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(StoryLink(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func deleteStoryLink(storyLinkId: Int, success: () -> Void, failure: Failure) {
        request(StoryLinkRouter.DeleteStoryLink(storyLinkId: storyLinkId), success: { response in
           success()
            }, failure: { error in
                failure(error)
        })
    }
}