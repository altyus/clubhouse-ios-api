//
//  Stories.swift
//  Pods
//
//  Created by Al Tyus on 3/13/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 Enumeration conforming to Param encapsulating CRUD params for Story calls
 */
public enum StoryParam: Param {
    case BeforeId(Int)
    case FollowerIds([UUID])
    case OwnerIds([UUID])
    case Estimate(Int)
    case AfterId(Int)
    case StoryType(String)
    case FileIds([Int])
    case Labels([String: AnyObject])
    case ProjetId(Int)
    case EpicId(Int)
    case Name(String)
    case Deadline(String)
    case Description(String)
    case Archived(Bool)
    case RequestedById(UUID)
    case WorkflowStateId(Int)
    
    /// Tuple wrapping a given Param's key and value
    public var param: (key: String, value: AnyObject) {
        switch self {
        case .BeforeId(let beforeId):
            return ("before_id", beforeId)
        case .FollowerIds(let followerIds):
            return ("follower_ids", followerIds)
        case .OwnerIds(let ownerIds):
            return ("owner_ids", ownerIds)
        case .Estimate(let estimate):
            return ("estimate", estimate)
        case .AfterId(let afterId):
            return ("after_id", afterId)
        case .StoryType(let storyType):
            return ("story_type", storyType)
        case .FileIds(let fileIds):
            return ("file_ids", fileIds)
        case .Labels(let labels):
            return ("labels", labels)
        case .ProjetId(let projectId):
            return ("project_id", projectId)
        case .EpicId(let epicId):
            return ("epic_id", epicId)
        case .Deadline(let deadline):
            return ("deadline", deadline)
        case .Description(let description):
            return ("description", description)
        case .Archived(let archived):
            return ("archived", archived)
        case .RequestedById(let requestedById):
            return ("requested_by_id", requestedById)
        case .WorkflowStateId(let workflowStateId):
            return ("workflow_state_id", workflowStateId)
        case .Name(let name):
            return ("name", name)
        }
    }
}

/**
  Enumeration conforming to Param encapsulating CRUD params for Task calls
 */
public enum TaskParam: Param {
    case Description(String)
    
    public var param: (key: String, value: AnyObject) {
        switch self {
        case .Description(let description):
            return ("description", description)
        }
    }
}

/**
 Enumeration conforming to Param encapsulating CRUD params for Comment calls
 */
public enum CommentParam: Param {
    case AuthorId(UUID)
    case CreatedAt(String)
    case ExternalId(String)
    case UpdatedAt(String)
    case Text(String)
    
    public var param: (key: String, value: AnyObject) {
        switch self {
        case .AuthorId(let authorId):
            return ("author_id", authorId)
        case .CreatedAt(let createdAt):
            return ("created_at", createdAt)
        case .ExternalId(let externalId):
            return ("external_id", externalId)
        case .UpdatedAt(let updatedAt):
            return ("updated_at", updatedAt)
        case .Text(let text):
            return ("text", text)
        }
    }
}

public extension ClubhouseAPI {
    enum StoryRouter: URLRequestConvertible {
        case GetStory(storyId: Int)
        case GetComment(storyId: Int, commentId: Int)
        case UpdateStory(storyId: Int, params: [String: AnyObject])
        case CreateStory(params: [String: AnyObject])
        case DeleteStory(storyId: Int)
        case BulkUpdate(params: [String: AnyObject])
        case GetTask(storyId: Int, taskId: Int)
        case CreateTask(storyId: Int, params: [String: AnyObject])
        case UpdateTask(storyId: Int, taskId: Int, params: [String: AnyObject])
        case DeleteTask(storyId: Int, taskId: Int)
        case SearchStories(params: [String: AnyObject])
        case UpdateComment(storyId: Int, commentId: Int, params: [String: AnyObject])
        case DeleteComment(storyId: Int, commentId: Int)
        case CreateComment(storyId: Int, params: [String: AnyObject])
        
        var method: Alamofire.Method {
            switch self {
            case .GetStory, .GetComment, .GetTask:
                return .GET
            case .UpdateStory, .BulkUpdate, .UpdateComment, .UpdateTask:
                return .PUT
            case .CreateStory, CreateTask, .SearchStories, .CreateComment:
                return .POST
            case .DeleteStory, .DeleteComment, DeleteTask:
                return .DELETE
            }
        }
        var path: String {
            switch self {
            case .GetStory(let id):
                return "stories/\(id)"
            case .GetComment(let storyId, let commentId):
                return "stories/\(storyId)/comments/\(commentId)"
            case .UpdateStory(let id, _):
                return "stories/\(id)"
            case .CreateStory:
                return "stories"
            case .DeleteStory(let id):
                return "stories/\(id)"
            case .BulkUpdate:
                return "stories/bulk"
            case .GetTask(let storyId, let taskId):
                return "stories/\(storyId)/tasks/\(taskId)"
            case .CreateTask(let id, _):
                return "stories/\(id)/tasks"
            case .UpdateTask(let storyId, let taskId, _):
                return "stories/\(storyId)/tasks/\(taskId)"
            case .DeleteTask(let storyId, let taskId):
                return "stories/\(storyId)/tasks/\(taskId)"
            case .SearchStories:
                return "stories/search"
            case .UpdateComment(let storyId, let commentId, _):
                return "stories/\(storyId)/comments/\(commentId)"
            case .DeleteComment(let storyId, let commentId):
                return "stories/\(storyId)/comments/\(commentId)"
            case .CreateComment(let storyId, _):
                return "stories/\(storyId)/comments"
                }
            }
        public var URLRequest: NSMutableURLRequest {
            let mutableURLRequest = ClubhouseAPI.URLRequest(method, path: path)
            
            switch self {
            case .CreateStory(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateStory(_, let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .BulkUpdate(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .CreateTask(_, let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateTask(_, _, let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .SearchStories(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateComment(_, _, let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .CreateComment(_, let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
            }
        }
    }
    
    func updateStories(storyIds: [Int], optionalParams: [StoryParam], success: () -> Void, failure: Failure) {
        request(StoryRouter.BulkUpdate(params: optionalParams.toParams()), success: { _ in
            success()
            },
            failure: { error in
                failure(error)
        })
    }
    
    func getStory(id: Int, success: (Story) -> Void, failure: Failure) {
        request(StoryRouter.GetStory(storyId: id), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Story(json: JSON(response)))
        },
            failure: { error in
                failure(error) 
        })
    }
    
    func updateStory(id: Int, optionalParams: [StoryParam], success: (Story) -> Void, failure: Failure) {
        request(StoryRouter.UpdateStory(storyId: id, params: optionalParams.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Story(json: JSON(response)))
            },
            failure: { error in
                failure(error)
        })
    }

    func createStory(optionalParams: [StoryParam], success: (Story) -> Void, failure: Failure) {
        request(StoryRouter.CreateStory(params: optionalParams.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Story(json: JSON(response)))
            },
            failure: { error in
                failure(error)
        })
    }
    
    func deleteStory(id: Int, success: () -> Void, failure: Failure) {
        request(StoryRouter.DeleteStory(storyId: id), success: { _ in
            success()
        },
            failure: { error in
                failure(error)
        })
    }
    
    func searchStories(optionalParams: [StoryParam], success: ([Story]) -> Void, failure: Failure) {
        request(StoryRouter.SearchStories(params: optionalParams.toParams()), success: { response in
            guard let stories = Story.objects(JSON(response).array) else {
                failure(nil)
                return
            }
            success(stories)
            
            }, failure: { error in
        })
    }

    func getComment(storyId: Int, commentId: Int, success: (Comment) -> Void, failure: Failure) {
        request(StoryRouter.GetComment(storyId: storyId, commentId: commentId), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Comment(json: JSON(response)))
        },
                failure: { error in
                    failure(error)
        })
    }
    
    func updateComment(storyId: Int, commentId: Int, text: String, success: (Comment) -> Void, failure: Failure) {
        request(StoryRouter.UpdateComment(storyId: storyId, commentId: commentId, params: ["text": text]), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Comment(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func deleteComment(storyId: Int, commentId: Int, success: () -> Void, failure: Failure) {
        request(StoryRouter.DeleteComment(storyId: storyId, commentId: commentId), success: { response in
            success()
            }, failure: { error in
                failure(error)
        })
    }
    
    func createComment(storyId: Int, text: String, optionalParams:[CommentParam], success: (Comment) -> Void, failure: Failure) {
        var params = optionalParams + [CommentParam.Text(text)]
        request(StoryRouter.CreateComment(storyId: storyId, params: params.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Comment(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func getTask(storyId: Int, taskId: Int, success:(Task) -> Void, failure: Failure) {
        request(StoryRouter.GetTask(storyId: storyId, taskId: taskId), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Task(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func createTask(storyId: Int, description: String, optionalParams:[TaskParam],  complete: Bool, success: (Task) -> Void, failure: Failure) {
        // Combines Optional Params with Required Param, Description
        var params = optionalParams + [TaskParam.Description(description)]
        request(StoryRouter.CreateTask(storyId: storyId, params: params.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Task(json: JSON(response)))
            },
                failure: { error in
                    failure(error)
        })
    }
    
    func updateTask(storyId: Int, taskId: Int, optionalParams:[TaskParam], success: (Task) -> Void, failure: Failure) {
        request(StoryRouter.UpdateTask(storyId: storyId, taskId: taskId, params: optionalParams.toParams()), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(Task(json: JSON(response)))
            }, failure: { error in
                failure(error)
        })
    }
    
    func deleteTask(storyId: Int, taskId: Int, success: () -> Void, failure: Failure) {
        request(StoryRouter.DeleteTask(storyId: storyId, taskId: taskId), success: { _ in
                success()
            }, failure: { error in
                failure(error)
        })
    }
}
