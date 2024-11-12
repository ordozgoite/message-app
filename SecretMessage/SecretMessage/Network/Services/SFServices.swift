//
//  SFServices.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import Foundation

protocol SFServiceable {
    
    // User
    func postNewUser(username: String, token: String) async -> Result<MongoUser, RequestError>
    func getUserInfo(token: String) async -> Result<MongoUser, RequestError>
    
    // Chat
    func postNewChat(chatName: String, token: String) async -> Result<MongoChat, RequestError>
}

struct SFServices: HTTPClient, SFServiceable {
    
    static let shared = SFServices()
    private init() {}
    
    //MARK: - User
    
    func postNewUser(username: String, token: String) async -> Result<MongoUser, RequestError> {
        return await sendRequest(endpoint: SFEndpoints.postNewUser(username: username, token: token), responseModel: MongoUser.self)
    }
    
    func getUserInfo(token: String) async -> Result<MongoUser, RequestError> {
        return await sendRequest(endpoint: SFEndpoints.getUserInfo(token: token), responseModel: MongoUser.self)
    }
    
    //MARK: - Chat
    
    func postNewChat(chatName: String, token: String) async -> Result<MongoChat, RequestError> {
        return await sendRequest(endpoint: SFEndpoints.postNewChat(chatName: chatName, token: token), responseModel: MongoChat.self)
    }
}
