//
//  MongoMessage.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 12/11/24.
//

import Foundation

struct MongoMessage: Codable {
    let _id: String
    let chatId: String
    let senderUserUid: String
    let text: String
    let targetUserUid: String
    
    func format() -> FormattedMessage {
        return FormattedMessage(id: self._id, chatId: self.chatId, text: self.text, isCurrentUser: LocalState.currentUserUid == self.senderUserUid, isFirst: false, status: .sent)
    }
}
