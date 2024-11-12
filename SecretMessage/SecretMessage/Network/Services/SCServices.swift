//
//  SFServices.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import Foundation

protocol SCServiceable {
    
    // User
    func postNewUser(username: String, token: String) async -> Result<MongoUser, RequestError>
    func getUserInfo(token: String) async -> Result<MongoUser, RequestError>
    
    // Chat
    func postNewChat(chatName: String, token: String) async -> Result<MongoChat, RequestError>
    func getChatsByUser(token: String) async -> Result<[MongoChat], RequestError>
    func addUserToChat(chatId: String, username: String, token: String) async -> Result<MongoChat, RequestError>
    func savePubECDHKey(chatId: String, publicKey: String, token: String) async -> Result<MongoChat, RequestError>
    
    // Message
    func postMessage(chatId: String, text: String, targetUserUid: String, token: String) async -> Result<MongoMessage, RequestError>
    func getMessagesByChat(chatId: String, token: String) async -> Result<[MongoMessage], RequestError>
}

struct SCServices: HTTPClient, SCServiceable {
   
    static let shared = SCServices()
    private init() {}
    
    //MARK: - User
    
    func postNewUser(username: String, token: String) async -> Result<MongoUser, RequestError> {
        return await sendRequest(endpoint: SCEndpoints.postNewUser(username: username, token: token), responseModel: MongoUser.self)
    }
    
    func getUserInfo(token: String) async -> Result<MongoUser, RequestError> {
        return await sendRequest(endpoint: SCEndpoints.getUserInfo(token: token), responseModel: MongoUser.self)
    }
    
    //MARK: - Chat
    
    func postNewChat(chatName: String, token: String) async -> Result<MongoChat, RequestError> {
        return await sendRequest(endpoint: SCEndpoints.postNewChat(chatName: chatName, token: token), responseModel: MongoChat.self)
    }
    
    func getChatsByUser(token: String) async -> Result<[MongoChat], RequestError> {
        return await sendRequest(endpoint: SCEndpoints.getChatsByUser(token: token), responseModel: [MongoChat].self)
    }
    
    func addUserToChat(chatId: String, username: String, token: String) async -> Result<MongoChat, RequestError> {
        return await sendRequest(endpoint: SCEndpoints.addUserToChat(chatId: chatId, username: username, token: token), responseModel: MongoChat.self)
    }
    
    func savePubECDHKey(chatId: String, publicKey: String, token: String) async -> Result<MongoChat, RequestError> {
        return await sendRequest(endpoint: SCEndpoints.savePubECDHKey(chatId: chatId, publicKey: publicKey, token: token), responseModel: MongoChat.self)
    }
    
    //MARK: - Message
    
    func postMessage(chatId: String, text: String, targetUserUid: String, token: String) async -> Result<MongoMessage, RequestError> {
        return await sendRequest(endpoint: SCEndpoints.postMessage(chatId: chatId, text: text, targetUserUid: targetUserUid, token: token), responseModel: MongoMessage.self)
    }
    
    func getMessagesByChat(chatId: String, token: String) async -> Result<[MongoMessage], RequestError> {
        return await sendRequest(endpoint: SCEndpoints.getMessagesByChat(chatId: chatId, token: token), responseModel: [MongoMessage].self)
    }
}
