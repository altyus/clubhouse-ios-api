//
//  Models.swift
//  Pods
//
//  Created by AL TYUS on 3/19/16.
//
//

import Foundation
import SwiftyJSON

//MARK: Protocols

/**
*  Conforming types can return a collection of Self
*/
public protocol Numerable {
    static func objects(jsonArray: [JSON]?) -> [Self]?
}

/**
 *  Conforming types can be initialized with a SwiftyJSON JSON object
 */
public protocol Initializable {
    init(json: JSON)
}

//MARK: TypeAliases

public typealias UUID = String

//MARK: Extensions

// MARK: - Extends Numerable to implement method which returns collection of Self
public extension Numerable where Self: Initializable {
    /**
     Given an Object conforming to Numerable and Initializable return an optional collectin of Self
     
     - parameter jsonArray: optional array of JSON objects
     
     - returns: array of Self objects
     */
    public static func objects(jsonArray: [JSON]?) -> [Self]? {
        return jsonArray.flatMap { $0.map { Self(json: $0) } }
    }
}

// MARK: - Extends String to transform string to optional StoryType
private extension String {
    /**
     Converts a string to an Option StoryType Object
     
     - returns: If a matching storytype is found for string raw value returns storytype
     */
    func toStoryType() -> StoryType? {
       return StoryType(rawValue: self)
    }
}

//MARK: Enums 

/**
Enum wrapping types of stories

- feature: a feature story
- bug:     a bug story
- chore:   a chore story
*/
public enum StoryType: String {
    case Feature = "feature"
    case Bug = "bug"
    case Chore = "chore"
}


//MARK: Models 

public struct Branch: Initializable, Numerable {
    public let repository: RepoSlim
    public let repositoryName: String?
    public let name: String?
    public let deleted: Bool
    public let persistent: Bool
    public let createdAt: NSDate?
    public let pullRequests: [PullRequest]?
    public let updatedAt: NSDate?
    public let merges: [BranchSlim]?
    public let url: String
    public let id: String
    
    public init(json: JSON) {
        self.deleted = json["deleted"].boolValue
        self.repository = RepoSlim(json: json["respository"])
        self.name = json["name"].string
        self.persistent = json["persistent"].boolValue
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.pullRequests = PullRequest.objects(json["pull_requests"].array)
        self.repositoryName = json["repository_name"].string
        self.id = json["id"].stringValue
        self.url = json["url"].stringValue
        self.merges = BranchSlim.objects(json["merges"].array)
        self.createdAt = json["created_at"].stringValue.toNSDate()
    }
}

public struct BranchSlim: Initializable, Numerable {
    public let name: String
    public let deleted: Bool
    public let id: Int
    public let persistent: Bool
    
    public init(json: JSON) {
        self.name = json["name"].stringValue
        self.deleted = json["deleted"].boolValue
        self.id = json["id"].intValue
        self.persistent = json["persistent"].boolValue
    }
}

private extension String {
    /**
     Converts a string to an Optional Verb Object
     
     - returns: If a matching Verb is found for string raw value returns Verb
     */
    func toVerb() -> Verb? {
        return Verb(rawValue: self)
    }
}

public enum Verb: String {
    case Blocks = "blocks"
    case Duplicates = "duplicates"
    case RelatesTo = "relates to"
}

public struct StoryLink: Initializable, Numerable {
    public let createdAt: NSDate?
    public let object: Int
    public let updatedAt: NSDate?
    public let verb: Verb?
    public let subject: Int
    public let description: String
    
    public init(json: JSON) {
        self.createdAt = json["created_at"].string?.toNSDate()
        self.object = json["object"].intValue
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.verb = json["verb"].string?.toVerb()
        self.subject = json["subject"].intValue
        self.description = json["description"].stringValue
    }
}

public struct Comment: Initializable, Numerable {
    public let storyId: Int
    public let createdAt: NSDate?
    public let updatedAt: NSDate?
    public let text: String?
    public let position: Int
    public let author: UserSlim
    public let id: Int
    
    public init(json: JSON) {
        self.id = json["id"].intValue
        self.text = json["text"].string
        self.position = json["position"].intValue
        self.createdAt = json["created_at"].string?.toNSDate()
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.storyId = json["story_id"].intValue
        self.author = UserSlim(json: json)
    }
}

public struct Commit: Initializable, Numerable {
    public let repository: RepoSlim
    public let authorIdentity: IdentitySlim
    public let authorEmail: String
    public let author: UserSlim
    public let message: String
    public let hash: String
    public let createdAt: NSDate?
    public let timestamp: NSDate?
    public let updatedAt: NSDate?
    public let url: String
    public let id: Int
   
    public init(json: JSON) {
        self.repository = RepoSlim(json: json["repository"])
        self.hash = json["hash"].stringValue
        self.author = UserSlim(json: json["author"])
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.id = json["id"].intValue
        self.url = json["url"].stringValue
        self.authorEmail = json["author_email"].stringValue
        self.timestamp = json["timestamp"].string?.toNSDate()
        self.authorIdentity = IdentitySlim(json: json["author_identity"])
        self.createdAt = json["created_at"].string?.toNSDate()
        self.message = json["message"].stringValue
    }
}

public struct Email: Initializable, Numerable {
    public let emailAddress: String
    public let createdAt: NSDate?
    public let confirmed: Bool
    public let updatedAt: NSDate?
    public let primary: Bool
    public let id: UUID
    
    public init(json: JSON) {
        self.emailAddress = json["email_address"].stringValue
        self.createdAt = json["created_at"].string?.toNSDate()
        self.confirmed = json["confirmed"].boolValue
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.primary = json["confirmed"].boolValue
        self.id = json["id"].stringValue
    }
}

public struct Epic: Initializable, Numerable {
    public let deadline: NSDate?
    public let position: Int?
    public let name: String
    public let comments: [ThreadedComment]?
    public let archived: Bool
    public let description: String
    public let state: String
    public let createdAt: NSDate?
    public let updatedAt: NSDate?
    public let id: Int
    public let followers: [UserSlim]?
    
    public init(json: JSON) {
        self.deadline = json["deadline"].string?.toNSDate()
        self.position = json["position"].int
        self.name = json["name"].stringValue
        self.comments = ThreadedComment.objects(json["comments"].array)
        self.archived = json["archived"].boolValue
        self.description = json["description"].stringValue
        self.state = json["stat"].stringValue
        self.createdAt = json["created_at"].string?.toNSDate()
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.id = json["id"].intValue
        self.followers = UserSlim.objects(json["followers"].array)
    }
}

public struct EpicSlim: Initializable, Numerable {
    public let id: String
    
    public init(json: JSON) {
        self.id = json["id"].stringValue
    }
}

public struct Estimate: Initializable, Numerable {
    public let value: Int
    public let id: Int
    
    public init(json: JSON) {
        self.value = json["value"].intValue
        self.id = json["id"].intValue
    }
}

public struct EstimateScale: Initializable, Numerable {
    public let estimates: [Estimate]?
    public let name: NSDate?
    public let id: Int
    
    public init(json: JSON) {
        self.estimates = Estimate.objects(json["estimates"].array)
        self.name = json["name"].string?.toNSDate()
        self.id = json["id"].intValue
    }
}

public struct File: Initializable, Numerable {
    public let id: Int
    public let url: String
    public let fileName: String?
    public let thumbnailURL: String?
    public let size: Int?
    public let contentType: String?
    public let createdAt: NSDate?
    public let uploader: UserSlim
    
    public init(json: JSON) {
        self.id = json["id"].intValue
        self.url = json["url"].stringValue
        self.fileName = json["file_name"].string
        self.thumbnailURL = json["thumbnail_url"].string
        self.size = json["size"].int
        self.contentType = json["content_type"].string
        self.createdAt = json["created_at"].string?.toNSDate()
        self.uploader = UserSlim(json: json["uploader"])
    }
}

public struct IdentitySlim: Initializable, Numerable {
    public let name: String
    public let type: String
    
    public init(json: JSON) {
        self.name = json["name"].stringValue
        self.type = json["type"].stringValue
    }
}

public struct Integration: Initializable, Numerable {
    public let disabled: Bool
    public let webhookUrl: String?
    public let createdAt: NSDate?
    public let updatedAt: NSDate?
    public let type: String?
    public let id: Int
    
    public init(json: JSON) {
        self.disabled = json["disabled"].boolValue
        self.webhookUrl = json["webhook_url"].string
        self.createdAt = json["created_at"].string?.toNSDate()
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.type = json["type"].string
        self.id = json["id"].intValue
    }
}

public struct Label: Initializable, Numerable {
    public let id: String
    public let name: String
    public let updatedAt: NSDate?
    
    public init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.updatedAt = json["updatedAt"].string?.toNSDate()
    }
}

public struct LabelSlim: Initializable, Numerable {
    public let name: String
    
    public init(json: JSON) {
        self.name = json["name"].stringValue
    }
}

public struct Organization: Initializable, Numerable {
    public let lockedOut: Bool
    public let disabled: Bool
    public let location: String?
    public let name: String
    public let beta: Bool
    public let publicUrl: String?
    public let estimateScale: EstimateScale
    public let signupDomain: String?
    public let integrations: [Integration]?
    public let id: UUID?
    public let urlSlug: String?
    
    public init(json: JSON) {
        self.lockedOut = json["locked_out"].boolValue
        self.disabled = json["disabled"].boolValue
        self.location = json["location"].string
        self.name = json["name"].stringValue
        self.beta = json["beta"].boolValue
        self.publicUrl = json["public_url"].string
        self.estimateScale = EstimateScale(json: json["estimate_scale"])
        self.signupDomain = json["signup_domain"].string
        self.integrations = Integration.objects(json["integrations"].array)
        self.id = json["id"].stringValue
        self.urlSlug = json["url_slug"].string
    }
}

public struct PullRequest: Initializable, Numerable {
    public let closed: Bool
    public let numAdded: Int
    public let number: Int
    public let numCommits: Int
    public let title: String
    public let updatedAt: NSDate?
    public let id: Int
    public let url: String
    public let numRemoved: Int
    public let numModified: Int
    public let createdAt: NSDate?
    public let targetBranch: BranchSlim
    
    public init(json: JSON) {
        self.closed = json["closed"].boolValue
        self.numAdded = json["num_added"].intValue
        self.number = json["number"].intValue
        self.numCommits = json["num_commits"].intValue
        self.title = json["titltle"].stringValue
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.id = json["id"].intValue
        self.url = json["url"].stringValue
        self.numRemoved = json["num_removed"].intValue
        self.numModified = json["num_modified"].intValue
        self.createdAt = json["created_at"].string?.toNSDate()
        self.targetBranch = BranchSlim(json: json["target_branch"])
    }
}

public struct Project: Initializable, Numerable {
    public let startTime: NSDate?
    public let name: String
    public let archived: Bool
    public let description: String
    public let daysToThermometer: Int?
    public let createdAt: NSDate?
    public let color: String
    public let updatedAt: NSDate?
    public let abbreviation: String?
    public let id: Int
    public let showThermometer: Bool
    public let followers: [UserSlim]?
    public let iterationLength: Int?
    public let organization: Organization
    
    public init(json: JSON) {
        self.startTime = json["start_time"].string?.toNSDate()
        self.name = json["name"].stringValue
        self.archived = json["archived"].boolValue
        self.description = json["description"].stringValue
        self.daysToThermometer = json["days_to_thermometer"].int
        self.createdAt = json["created_at"].string?.toNSDate()
        self.color = json["color"].stringValue
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.abbreviation = json["abbreviation"].string
        self.id = json["id"].intValue
        self.showThermometer = json["show_thermometer"].boolValue
        self.followers = UserSlim.objects(json["followers"].array)
        self.iterationLength = json["iteration_length"].int
        self.organization = Organization(json: json["organization"])
    }
}

public struct RepoSlim: Initializable {
    public let id: Int
    public let name: String
    public let fullName: String
    public let url: String
    
    public init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.fullName = json["full_name"].stringValue
        self.url = json["url"].stringValue
    }
}

public struct Story: Initializable, Numerable {
    public let id: Int
    public let position: Int?
    public let estimate: Int?
    public let name: String?
    public let storyType: StoryType?
    public let projectId: Int?
    public let description: String?
    public let archived: Bool?
    public let workflowStateId: Int?
    public let createdAt: NSDate?
    public let updatedAt: NSDate?
    public let deadline: NSDate?
    public let files: [File]?
    public let comments: [Comment]?
    public let requestedBy: UserSlim?
    public let epic: [Epic]?
    public let owners: [UserSlim]?
    public let labels: [Label]?
    public let followers: [UserSlim]?
    public let branches: [Branch]?
    public let tasks: [Task]?
    public let commits: [Commit]?
    
    public init(json: JSON) {
        self.name = json["name"].string
        self.id = json["id"].intValue
        self.position = json["position"].int
        self.estimate = json["position"].int
        self.projectId = json["project_id"].int
        self.description = json["description"].string
        self.archived = json["archived"].bool
        self.workflowStateId = json["workflow_state_id"].int
        self.storyType = json["story_type"].string?.toStoryType()
        self.createdAt = json["created_at"].string?.toNSDate()
        self.deadline = json["deadline"].string?.toNSDate()
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.files = File.objects(json["files"].arrayValue)
        self.comments = Comment.objects(json["commnts"].array)
        self.requestedBy = UserSlim(json: json["requested_by"])
        self.epic = Epic.objects(json["epic"].array)
        self.owners = UserSlim.objects(json["authors"].array)
        self.labels = Label.objects(json["labels"].array)
        self.followers = UserSlim.objects(json["followers"].array)
        self.branches = Branch.objects(json["branches"].array)
        self.tasks = Task.objects(json["tasks"].array)
        self.commits = Commit.objects(json["commits"].array)
    }
}

public struct Task: Initializable, Numerable {
    public let id: Int
    public let description: String
    public let position: Int
    public let createdAt: NSDate?
    public let updatedAt: NSDate?
    public let complete: Bool
    public let completedAt: NSDate?
    public let storyId: Int
    
    public init(json: JSON) {
        self.id = json["id"].intValue
        self.description = json["description"].stringValue
        self.position = json["position"].intValue
        self.createdAt = json["created_at"].stringValue.toNSDate()
        self.updatedAt = json["updated_at"].stringValue.toNSDate()
        self.complete = json["complete"].boolValue
        self.completedAt = json["completed_at"].string?.toNSDate()
        self.storyId = json["story_id"].intValue
    }
}

public struct Token: Initializable, Numerable {
    public let createdAt: NSDate?
    public let id: String?
    public let lastUsed: NSDate?
    public let description: String?
    
    public init(json: JSON) {
        self.createdAt = json["created_at"].string?.toNSDate()
        self.id = json["id"].string
        self.lastUsed = json["last_used"].string?.toNSDate()
        self.description = json["description"].string
    }
}

public struct ThreadedComment: Initializable, Numerable {
    public let createdAt: NSDate?
    public let text: String
    public let deleted: Bool
    public let author: UserSlim
    public let id: Int
    
    public init(json: JSON) {
        self.createdAt = json["created_at"].string?.toNSDate()
        self.text = json["text"].stringValue
        self.deleted = json["deleted"].boolValue
        self.author = UserSlim(json: json["author"])
        self.id = json["id"].intValue
    }
}

public struct User: Initializable, Numerable {
    public let initials: String?
    public let gravatarId: String?
    public let disabled: Bool
    public let twoFactorAuthActivated: Bool
    public let tokens: [Token]?
    public let name: String
    public let emailAlerts: Bool
    public let username: String
    public let email: String
    public let emails: [Email]?
    public let twoFactorAuth: Bool
    public let id: UUID?
    public let role: String
    public let organization: Organization
    
    public init(json: JSON) {
        self.initials = json["initials"].string
        self.gravatarId = json["gravatar_id"].string
        self.disabled = json["disabled"].boolValue
        self.twoFactorAuthActivated = json["two_factor_auth_activated"].boolValue
        self.tokens = Token.objects(json["tokens"].array)
        self.name = json["name"].stringValue
        self.emailAlerts = json["email_alerts"].boolValue
        self.username = json["username"].stringValue
        self.email = json["email"].stringValue
        self.emails = Email.objects(json["emails"].array)
        self.twoFactorAuth = json["two_factor_auth"].boolValue
        self.id = json["id"].stringValue
        self.role = json["role"].stringValue
        self.organization = Organization(json: json["organization"])
    }
}

public struct UserSlim: Initializable, Numerable {
    public let id: String?
    
    public init(json: JSON) {
        self.id = json["id"].string
    }
}

public struct Workflow: Initializable, Numerable {
    public let createdAt: NSDate?
    public let updatedAt: NSDate?
    public let states: [WorkflowState]?
    public let name: String?
    public let defaultStateId: Int?
    public let id: Int
    public let description: String?
    
    public init(json: JSON) {
        self.createdAt = json["created_at"].string?.toNSDate()
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.states = WorkflowState.objects(json["states"].array)
        self.name = json["name"].string
        self.defaultStateId = json["default_state_id"].int
        self.id = json["id"].intValue
        self.description = json["description"].string
    }
}

public struct WorkflowState: Initializable, Numerable {
    public let position: Int?
    public let name: String?
    public let description: String?
    public let createdAt: NSDate?
    public let color: String?
    public let numStories: Int
    public let verb: String?
    public let updatedAt: NSDate?
    public let type: String?
    public let id: Int
    
    public init(json: JSON) {
        self.position = json["position"].int
        self.name = json["name"].string
        self.description = json["description"].string
        self.createdAt = json["created_at"].string?.toNSDate()
        self.color = json["color"].string
        self.numStories = json["num_stories"].intValue
        self.verb = json["verb"].string
        self.updatedAt = json["updated_at"].string?.toNSDate()
        self.type = json["type"].string
        self.id = json["id"].intValue
    }
}

