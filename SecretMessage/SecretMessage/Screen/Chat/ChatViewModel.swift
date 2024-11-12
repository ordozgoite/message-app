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
    
    @Published var chats: [FormattedChat] = []
    @Published var isLoading: Bool = false
    @Published var overlayError: (Bool, LocalizedStringKey) = (false, "")
    @Published var isInitialChatsFetched: Bool = false
    
    // New Chat
    @Published var isNewChatViewDisplayed: Bool = false
    @Published var newChatName: String = ""
    @Published var isCreatingNewChat: Bool = false
    
    func getChats(token: String) async {
//        if !isInitialChatsFetched { isLoading = true }
//        let result = await AYServices.shared.getChatsByUser(token: token)
//        if !isInitialChatsFetched { isLoading = false }
//        
//        switch result {
//        case .success(let chats):
//            self.chats = chats
//            isInitialChatsFetched = true
//        case .failure:
//            overlayError = (true, ErrorMessage.defaultErrorMessage)
//        }
    }
    
    func createNewChat(token: String) async {
        isCreatingNewChat = true
        let result = await SFServices.shared.postNewChat(chatName: self.newChatName, token: token)
        isCreatingNewChat = false
        
        switch result {
        case .success(let chat):
            print("✅ Sucesso ao criar novo chat!")
            isNewChatViewDisplayed = false
            newChatName = ""
            appendChat(chat)
        case .failure:
            overlayError = (true, ErrorMessage.defaultErrorMessage)
        }
    }
    
    private func appendChat(_ chat: MongoChat) {
        self.chats.append(FormattedChat(id: chat._id, chatName: chat.chatName))
    }
}
