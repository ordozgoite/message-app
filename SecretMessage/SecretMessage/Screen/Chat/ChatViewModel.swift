//
//  ChatViewModel.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    
    private var cryptoManager = CryptoManager()
    
    @Published var chats: [FormattedChat] = []
    @Published var isLoading: Bool = false
    @Published var overlayError: (Bool, LocalizedStringKey) = (false, "")
    @Published var isInitialChatsFetched: Bool = false
    
    // New Chat
    @Published var isNewChatViewDisplayed: Bool = false
    @Published var newChatName: String = ""
    @Published var isCreatingNewChat: Bool = false
    
    func getChats(token: String) async {
        isLoading = true
        let result = await SCServices.shared.getChatsByUser(token: token)
        isLoading = false
        
        switch result {
        case .success(let chats):
            self.chats = formatChats(chats)
            isInitialChatsFetched = true
        case .failure:
            overlayError = (true, ErrorMessage.defaultErrorMessage)
        }
    }
    
    private func formatChats(_ chats: [MongoChat]) -> [FormattedChat] {
        var formattedChats: [FormattedChat] = []
        for chat in chats {
            formattedChats.append(chat.formatChat())
        }
        return formattedChats
    }
    
    func createNewChat(token: String) async {
        isCreatingNewChat = true
        let result = await SCServices.shared.postNewChat(chatName: self.newChatName, token: token)
        isCreatingNewChat = false
        
        switch result {
        case .success(let chat):
            print("✅ Sucesso ao criar novo chat!")
            isNewChatViewDisplayed = false
            newChatName = ""
            chats.append(chat.formatChat())
            // generate keys routine:
            let pubKey = generateECDHKeys(forChat: chat._id)
            sendPubKey(pubKey, toChat: chat._id, token: token)
        case .failure:
            overlayError = (true, ErrorMessage.defaultErrorMessage)
        }
    }
    
    private func generateECDHKeys(forChat chatId: String) -> String {
        let keys = cryptoManager.generateECDHKeys()
        let privateKey = keys.privateKey
        let publicKey = cryptoManager.publicKeyToString(publicKey: keys.publicKey)
        print("🔑 Generated Public Key: \(publicKey)")
        
        let privateKeyBase64 = privateKey.rawRepresentation.base64EncodedString()
        cryptoManager.persistPrivateKey(chatId: chatId, privateKey: privateKeyBase64)
        
        return publicKey
    }
    
    private func sendPubKey(_ key: String, toChat chatId: String, token: String) {
        Task {
            _ = await SCServices.shared.savePubECDHKey(chatId: chatId, publicKey: key, token: token)
        }
    }
}
