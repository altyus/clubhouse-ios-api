//
//  API_Projects.swift
//  Pods
//
//  Created by AL TYUS on 3/27/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public enum ProjectParam: Param {
    case FollowerIds([UUID])
    case StartTime(String)
    case Name(String)
    case Description(String)
    case CreatedAt(String)
    case Color(String)
    case ExternalId(String)
    case UpdatedAt(String)
    case Abbreviation(String)
    case IterationLength(Int)
    
    public var param: (key: String, value: AnyObject) {
        switch self {
        case .FollowerIds(let followerIds):
            return ("follower_ids", followerIds)
        case .StartTime(let startTime):
            return ("start_time", startTime)
        case .Name(let name):
            return ("name", name)
        case .Description(let description):
            return ("description", description)
        case .CreatedAt(let createdAt):
            return ("created_at", createdAt)
        case .Color(let color):
            return ("color", color)
        case .ExternalId(let externalId):
            return ("external_id", externalId)
        case .UpdatedAt(let updatedAt):
            return ("updated_at", updatedAt)
        case .Abbreviation(let abbreviation):
            return ("abbreviation", abbreviation)
        case .IterationLength(let iterationLength):
            return ("iteration_length", iterationLength)
        }
    }
}

public extension ClubhouseAPI {
    enum ProjectRouter: URLRequestConvertible {
        case ListProjects
        case CreateProject(params: [String: AnyObject])
        case ListStories(projectId: Int)
        case GetProject(projectId: Int)
        case UpdateProject(projectId: Int, params: [String: AnyObject])
        case DeleteProject(projectId: Int)
        
        var method: Alamofire.Method {
            switch self {
            case .ListProjects, .ListStories, .GetProject:
                return .GET
            case .CreateProject:
                return .POST
            case .UpdateProject:
                return .PUT
            case .DeleteProject:
                return .DELETE
            }
        }
        var path: String {
            switch self {
            case .ListProjects, .CreateProject:
                return "projects"
            case .ListStories(let projectId):
                return "projects/\(projectId)/stories"
            case .GetProject(let projectId):
                return "projects/\(projectId)"
            case .UpdateProject(let projectId , _):
                return "projects/\(projectId)"
            case .DeleteProject(let projectId):
                return "projects/\(projectId)"
            }
        }
        public var URLRequest: NSMutableURLRequest {
            let mutableURLRequest = ClubhouseAPI.URLRequest(method, path: path)
            
            switch self {
            case .CreateProject(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateProject(_, let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
            }
        }
    }
    
    func listProjects(success: ([Project]) -> Void, failure: Failure) {
        request(ProjectRouter.ListProjects, success: { response in
            guard let projects = Project.objects(JSON(response).array) else {
                failure(nil)
                return
            }
            success(projects)
            }, failure: { error in
                failure(error)
        })
    }
    
    func createProject(name: String, optionalParams: [ProjectParam], success: (Project) -> Void, failure: Failure) {
        let params = optionalParams + [ProjectParam.Name(name)]
        request(ProjectRouter.CreateProject(params: params.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Project(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func listStories(projectId: Int, success: ([Story]) -> Void, failure: Failure) {
        request(ProjectRouter.ListStories(projectId: projectId), success: { response in
            guard let stories = Story.objects(JSON(response).array) else {
                failure(nil)
                return
            }
            success(stories)
            }, failure: { error in
                failure(error)
        })
    }
    
    func getProject(projectId: Int, success: (Project) -> Void, failure: Failure) {
        request(ProjectRouter.GetProject(projectId: projectId), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Project(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func updateProject(projectId: Int, optionalParams: [ProjectParam], success: (Project) -> Void, failure: Failure) {
        
        request(ProjectRouter.UpdateProject(projectId: projectId, params: optionalParams.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Project(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func deleteProject(projectId: Int, success: () -> Void, failure: Failure) {
        request(ProjectRouter.DeleteProject(projectId: projectId), success: { _ in
            success()
            }, failure: { error in
                failure(error)
        })
    }
}