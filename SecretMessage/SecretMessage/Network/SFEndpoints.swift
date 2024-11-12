//
//  SFEndpoints.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import Foundation

enum SFEndpoints {
    case postNewUser(username: String, token: String)
    case getUserInfo(token: String)
    case postNewChat(chatName: String, token: String)
}

extension SFEndpoints: Endpoint {
    
    //MARK: - URL
    
    var path: String {
        switch self {
        case .postNewUser:
            return "/api/User/PostNewUser"
        case .getUserInfo:
            return "/api/User/GetUserInfo"
        case .postNewChat:
            return "/api/Chat/PostNewChat"
        }
    }
    
    //MARK: - Method
    
    var method: RequestMethod {
        switch self {
        case .postNewUser, .postNewChat:
            return .post
        case .getUserInfo:
            return .get
        }
    }
    
    //MARK: - Query
    
    var query: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    //MARK: - Header
    
    var header: [String : String]? {
        switch self {
        case .postNewUser(_, let token), .getUserInfo(let token), .postNewChat(_, let token):
            return [
                "Authorization": "Bearer \(token)",
                "Accept": "application/x-www-form-urlencoded",
                "Content-Type": "application/json"
            ]
        default:
            return [
                "Accept": "application/x-www-form-urlencoded",
                "Content-Type": "application/json"
            ]
        }
    }
    
    //MARK: - Body
    
    var body: [String : Any]? {
        switch self {
        case .postNewUser(let username, _):
            let  params: [String: Any] = [
                "username": username
            ]
            return params
        case .postNewChat(let chatName, _):
            let  params: [String: Any] = [
                "chatName": chatName
            ]
            return params
        default:
            return nil
        }
    }
}
