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
    
    @Published var chats: [FormattedChat] = [
        FormattedChat(id: "1", chatName: "Amanda Hortêncio", otherUserUid: "1", lastMessageAt: 1727404777, hasUnreadMessages: true, lastMessage: "Oi, meu amor. Tudo bem?"),
        FormattedChat(id: "2", chatName: "Igor Farias", otherUserUid: "2", lastMessageAt: 1727304777, hasUnreadMessages: false, lastMessage: "Fala, mano")
    ]
    @Published var isLoading: Bool = false
    @Published var overlayError: (Bool, LocalizedStringKey) = (false, "")
    @Published var isInitialChatsFetched: Bool = false
    
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
}
