//
//  MessageIntermediary.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import Foundation
import SwiftUI

struct MessageIntermediary {
    var id: String
    var chatId: String
    var text: String
    var isRead: Bool
    var createdAt: Int
    var status: MessageStatus?
    var isCurrentUser: Bool
    
    func formatMessage(isFirst: Bool, timeDivider: Int?) -> FormattedMessage {
        return FormattedMessage(
            id: self.id,
            chatId: self.chatId,
            text: self.text,
            isCurrentUser: self.isCurrentUser,
            isFirst: isFirst,
            timeDivider: timeDivider,
            status: self.status ?? .sent,
            createdAt: self.createdAt
        )
    }
}
