//
//  API_Labels.swift
//  Pods
//
//  Created by AL TYUS on 3/27/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public enum LabelParam: Param {
    case ExternalId(String)
    case Name(String)
    
    public var param: (key: String, value: AnyObject) {
        switch self {
        case .ExternalId(let externalId):
            return ("external_id", externalId)
        case .Name(let name):
            return ("name", name)
        }
    }
}

public extension ClubhouseAPI {
    enum LabelRouter: URLRequestConvertible {
        case ListLabels
        case CreateLabel(params: [String: AnyObject])
        case UpdateLabel(labelId: Int, params: [String: AnyObject])
        case DeleteLabel(labelId: Int)
        
        var method: Alamofire.Method {
            switch self {
            case .ListLabels:
                return .GET
            case .CreateLabel:
                return .POST
            case .UpdateLabel:
                return .PUT
            case .DeleteLabel:
                return .DELETE
            }
        }
        var path: String {
            switch self {
            case .ListLabels, .CreateLabel:
                return "labels"
            case .UpdateLabel(let labelId):
                return "labels/\(labelId)"
            case .DeleteLabel(let labelId):
                return "labels/\(labelId)"
            }
        }
        public var URLRequest: NSMutableURLRequest {
            let mutableURLRequest = ClubhouseAPI.URLRequest(method, path: path)
            
            switch  self {
            case .CreateLabel(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateLabel(_ , let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
            }
        }
    }
   
    func listLabels(success: ([Label]) -> Void, failure: Failure) {
        request(LabelRouter.ListLabels, success: { response in
            guard let labels = Label.objects(JSON(response).array) else {
                return failure(nil)
            }
            success(labels)
            }, failure: { error in
                failure(error)
        })
    }
    
    func createLabel(name: String, optionalParams: [LabelParam], success: (Label) -> Void, failure: Failure) {
        let params = [LabelParam.Name(name)] + optionalParams
        request(LabelRouter.CreateLabel(params: params.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                return failure(nil)
            }
            success(Label(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func updateLabel(labelId: Int, name: String, success: (Label) -> Void, failure: Failure) {
        request(LabelRouter.UpdateLabel(labelId: labelId, params: [LabelParam.Name(name)].toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                return failure(nil)
            }
            success(Label(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func deleteLabel(labelId: Int, sucess: () -> Void, failure: Failure) {
        request(LabelRouter.DeleteLabel(labelId: labelId), success: { _ in
                sucess()
            }, failure: { error in
                failure(error)
        })
    }
}