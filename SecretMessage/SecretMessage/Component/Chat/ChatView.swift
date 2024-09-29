//
//  ChatView.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import SwiftUI

struct ChatView: View {
    
    let chat: FormattedChat
    
    var lastMessageStamp: String? {
        if let lastMessageAt = chat.lastMessageAt {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter.string(from: lastMessageAt.convertTimestampToDate())
        } else {
            return nil
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                ZStack {
                    if chat.hasUnreadMessages {
                        Circle()
                            .foregroundStyle(.blue)
                    }
                }
                .frame(width: 8, alignment: .center)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(chat.chatName)
                    .font(.headline)
                    .lineLimit(1)
                
                if let lastMessage = chat.lastMessage {
                    Text(lastMessage)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, minHeight: 40, alignment: .topLeading)
                }
            }
            
            Spacer()
            
            VStack {
                Text(lastMessageStamp ?? "")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(alignment: .center)
        .padding(.vertical, 8)
    }
}

#Preview {
    ChatView(chat:
                FormattedChat(
                    id: "1",
                    chatName: "Amanda Hortêncio",
                    otherUserUid: "1",
                    lastMessageAt: nil,
                    hasUnreadMessages: false,
                    lastMessage: nil
                )
    )
}
