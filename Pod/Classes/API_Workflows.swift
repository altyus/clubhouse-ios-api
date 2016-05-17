//
//  API_Workflows.swift
//  Pods
//
//  Created by AL TYUS on 3/27/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public extension ClubhouseAPI {
    enum WorkflowRouter: URLRequestConvertible {
        case ListWorkflows
        
        var method: Alamofire.Method {
            switch self {
            case .ListWorkflows:
                return .GET
            }
        }
        var path: String {
            switch self {
            case .ListWorkflows:
                return "workflows"
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
    
    func listWorkflows(success: ([Workflow]) -> Void, failure: Failure) {
        request(WorkflowRouter.ListWorkflows, success: { response in
            guard let workflows = Workflow.objects(JSON(response).array) else {
                failure(nil)
                return
            }
            success(workflows)
            }, failure: { error in
                failure(error)
        })
    }
}