//
//  MongoChat.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import Foundation

struct MongoChat: Codable {
    let _id: String
    let chatName: String
    let participantUserUids: [String]
    let publicKeys: [String: String]
    
    func formatChat() -> FormattedChat {
        return FormattedChat(
            id: self._id,
            chatName: self.chatName,
            participantUserUids: self.participantUserUids,
            publicKeys: self.publicKeys
        )
    }
}
