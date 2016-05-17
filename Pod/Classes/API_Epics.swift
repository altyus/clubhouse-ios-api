//
//  API_Epics.swift
//  Pods
//
//  Created by AL TYUS on 3/26/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public enum EpicParam: Param {
    case BeforeId(Int)
    case FollowerIds([UUID])
    case Deadline(String)
    case OwnerIds([UUID])
    case Name(String)
    case Archived(Bool)
    case Description(String)
    case State(EpicState)
    case AfterId(Int)
    
    public enum EpicState: String {
        case InProgress = "in progress"
        case ToDo = "to do"
        case Done = "done"
    }
    
    public var param: (key: String, value: AnyObject) {
        switch self {
        case .BeforeId(let beforeId):
            return ("before_id", beforeId)
        case .FollowerIds(let followerIds):
            return ("follower_ids", followerIds)
        case .Deadline(let deadline):
            return ("deadline", deadline)
        case .OwnerIds(let ownerIds):
            return ("ownder_ids", ownerIds)
        case .Name(let name):
            return ("name", name)
        case .Archived(let archived):
            return ("archived", archived)
        case .Description(let description):
            return ("description", description)
        case .State(let state):
            return ("state", state.rawValue)
        case .AfterId(let afterId):
            return ("after_id", afterId)
        }
    }
}
public extension ClubhouseAPI {
    enum EpicRouter: URLRequestConvertible {
        case GetEpic(epicId: Int)
        case UpdateEpic(epicId: Int, params: [String: AnyObject])
        case DeleteEpic(epicId: Int)
        case ListEpics
        case CreateEpic(params: [String: AnyObject])
        
        var method: Alamofire.Method {
            switch self {
            case .GetEpic, .ListEpics:
                return .GET
            case .UpdateEpic:
                return .PUT
            case .DeleteEpic:
                return .DELETE
            case .CreateEpic:
                return .POST
            }
        }
        
        var path: String {
            switch self {
            case .GetEpic(let epicId):
                return "epics/\(epicId)"
            case .UpdateEpic(let epicId):
                return "epics/\(epicId)"
            case .DeleteEpic(let epicId):
                return "epics/\(epicId)"
            case .ListEpics:
                return "epics"
            case .CreateEpic:
                return "epics"
            }
        }
        
        public var URLRequest: NSMutableURLRequest {
           let mutableURLRequest = ClubhouseAPI.URLRequest(method, path: path)
            
            switch self {
            case .UpdateEpic(_, let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .CreateEpic(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
            }
        }
    }
    
    func getEpic(epicId: Int, success: (Epic) -> Void, failure: Failure) {
        request(EpicRouter.GetEpic(epicId: epicId), success: { response in
            guard let response = response as? [String: AnyObject] else {
                return failure(nil)
            }
            success(Epic(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func updateEpic(epicId: Int, optionalParams: [EpicParam], success: (Epic) -> Void, failure: Failure) {
        request(EpicRouter.UpdateEpic(epicId: epicId, params: optionalParams.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                return failure(nil)
            }
            success(Epic(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func deleteEpic(epicId: Int, success:() -> Void, failure: Failure) {
        request(EpicRouter.DeleteEpic(epicId: epicId), success: { _ in
                success()
            }, failure: { error in
                failure(error)
        })
    }
    
    func listEpics(success:([Epic]) -> Void, failure: Failure) {
        request(EpicRouter.ListEpics, success: { response in
            guard let epics = Epic.objects(JSON(response).array) else {
                return failure(nil)
            }
            success(epics)
            }, failure: { error in
               failure(error)
        })
    }
    
    func createEpic(name: String, optionalParams: [EpicParam], success: (Epic) -> Void, failure: Failure) {
        let params = optionalParams + [EpicParam.Name(name)]
        
        request(EpicRouter.CreateEpic(params: params.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                return failure(nil)
            }
            success(Epic(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
}