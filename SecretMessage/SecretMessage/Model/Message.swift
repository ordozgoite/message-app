//
//  Message.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import Foundation

struct Message: Codable {
    let _id: String
    let chatId: String
    let senderUserUid: String
    let text: String
    let isRead: Bool
    let createdAt: Int
    
    func convertMessageToIntermediary(forCurrentUserUid userUid: String) -> MessageIntermediary {
        return MessageIntermediary(
            id: self._id,
            chatId: self.chatId,
            text: self.text,
            isRead: self.isRead,
            createdAt: self.createdAt,
            isCurrentUser: userUid == self.senderUserUid
        )
    }
}
