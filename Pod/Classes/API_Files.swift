//
//  API_Files.swift
//  Pods
//
//  Created by AL TYUS on 3/27/16.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public extension ClubhouseAPI {
    enum FileRouter: URLRequestConvertible {
        case GetFile(fileId: Int)
        case DeleteFile(fileId: Int)
        case ListFiles
        
        var method: Alamofire.Method {
            switch self {
            case .GetFile, .ListFiles:
                return .GET
            case .DeleteFile:
                return .DELETE
            }
        }
        var path: String {
            switch self {
            case .GetFile(let fileId):
                return "files/\(fileId)"
            case .DeleteFile(let fileId):
                return "files/\(fileId)"
            case .ListFiles:
                return "files"
            }
        }
        public var URLRequest: NSMutableURLRequest {
            let mutableURLRequest = ClubhouseAPI.URLRequest(method, path: path)
            
            switch  self {
            default:
                return mutableURLRequest
            }
        }
    }
    
    func getFile(fileId: Int, success: (File) -> Void, failure: Failure) {
        request(FileRouter.GetFile(fileId: fileId), success: { response in
            guard let response = response as? [String: AnyObject] else {
                failure(nil)
                return
            }
            success(File(json: JSON(response)))
            },
                failure: { error in
                    failure(error)
        })
    }
    
    func deleteFile(fileId: Int, success: () -> Void, failure: Failure) {
        request(FileRouter.DeleteFile(fileId: fileId), success: { _ in
            success()
            }, failure: { error in
                failure(error)
        })
    }
    
    func listFiles(success: ([File]) -> Void, failure: Failure) {
        request(FileRouter.ListFiles, success: { response in
            guard let files = File.objects(JSON(response).array) else {
                failure(nil)
                return
            }
            success(files)
            },
                failure: { error in
                    failure(error)
        })
    }
}