//
//  ChatView.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import SwiftUI

struct ChatView: View {
    
    let chat: FormattedChat
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                Text(chat.chatName)
                    .font(.headline)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .frame(alignment: .center)
        .padding(.vertical, 8)
    }
}

#Preview {
//    ChatView(chat:
//                FormattedChat(
//                    id: "1",
//                    chatName: "Amanda Hortêncio",
//                    otherUserUid: "1",
//                    lastMessageAt: nil,
//                    hasUnreadMessages: false,
//                    lastMessage: nil
//                )
//    )
}
