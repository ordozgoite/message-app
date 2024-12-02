//
//  MessageView.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import SwiftUI

struct MessageView: View {
    
    var message: FormattedMessage
    
    @State private var translation: CGSize = .zero
    @State private var showingAlert = false
    var resendMessage: () -> ()
    
    var body: some View {
        HStack {
            TextBubble(message.text)
            
            switch message.status {
            case .sent:
                EmptyView()
            case .sending:
                Sending()
            case .failed:
                Failed()
            }
        }
    }
    
    //MARK: - Text Bubble
    
    @ViewBuilder
    private func TextBubble(_ text: String) -> some View {
        BubbleView(
            message: text,
            isCurrentUser: message.isCurrentUser,
            isFirst: message.isFirst,
            username: message.senderUsername
        )
    }
    
    
    //MARK: - Sending
    
    @ViewBuilder
    private func Sending() -> some View {
        ProgressView()
            .padding(.leading)
    }
    
    //MARK: - Failed
    
    @ViewBuilder
    private func Failed() -> some View {
        Image(systemName: "exclamationmark.circle")
            .foregroundStyle(.red)
            .onTapGesture {
                self.showingAlert = true
            }
            .confirmationDialog("This message was not sent", isPresented: $showingAlert, titleVisibility: .visible) {
                Button("Try again") {
                    resendMessage()
                }
            }
    }
}

#Preview {
//    MessageView(message:
//                    FormattedMessage(
//                        id: "1",
//                        chatId: "1",
//                        text: "Essa é uma mensagem secreta",
//                        isCurrentUser: true,
//                        isFirst: true,
//                        status: .sent,
//                        createdAt: 1
//                    ),
//                resendMessage: {}
//    )
}
