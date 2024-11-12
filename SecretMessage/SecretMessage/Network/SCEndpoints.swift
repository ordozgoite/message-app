//
//  SFEndpoints.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import Foundation

enum SCEndpoints {
    case postNewUser(username: String, token: String)
    case getUserInfo(token: String)
    case postNewChat(chatName: String, token: String)
    case getChatsByUser(token: String)
    case addUserToChat(chatId: String, username: String, token: String)
    case savePubECDHKey(chatId: String, publicKey: String, token: String)
    case postMessage(chatId: String, text: String, targetUserUid: String, token: String)
    case getMessagesByChat(chatId: String, token: String)
}

extension SCEndpoints: Endpoint {
    
    //MARK: - URL
    
    var path: String {
        switch self {
        case .postNewUser:
            return "/api/User/PostNewUser"
        case .getUserInfo:
            return "/api/User/GetUserInfo"
        case .postNewChat:
            return "/api/Chat/PostNewChat"
        case .getChatsByUser:
            return "/api/Chat/GetChatsByUser"
        case .addUserToChat:
            return "/api/Chat/AddUserToChat"
        case .savePubECDHKey:
            return "/api/Chat/SavePubECDHKey"
        case .postMessage:
            return "/api/Message/PostMessage"
        case .getMessagesByChat(let chatId, _):
            return "/api/Message/GetMessages/\(chatId)"
        }
    }
    
    //MARK: - Method
    
    var method: RequestMethod {
        switch self {
        case .postNewUser, .postNewChat, .addUserToChat, .savePubECDHKey, .postMessage:
            return .post
        case .getUserInfo, .getChatsByUser, .getMessagesByChat:
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
        case .postNewUser(_, let token), .getUserInfo(let token), .postNewChat(_, let token), .getChatsByUser(let token), .addUserToChat(_, _, let token), .savePubECDHKey(_, _, let token), .postMessage(_, _, _, let token), .getMessagesByChat(_, let token):
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
        case .addUserToChat(let chatId, let username, _):
            let  params: [String: Any] = [
                "chatId": chatId,
                "username": username
            ]
            return params
        case .savePubECDHKey(let chatId, let publicKey, _):
            let  params: [String: Any] = [
                "chatId": chatId,
                "publicKey": publicKey
            ]
            return params
        case .postMessage(let chatId, let text, let targetUserUid, _):
            let  params: [String: Any] = [
                "chatId": chatId,
                "text": text,
                "targetUserUid": targetUserUid
            ]
            return params
        default:
            return nil
        }
    }
}
