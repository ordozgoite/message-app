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
        Time()
        
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
    
    //MARK: - Time
    
    @ViewBuilder
    private func Time() -> some View {
        if let timeDivider = message.timeDivider {
            Text(timeDivider.convertTimestampToDate().formatDatetoMessage())
                .foregroundStyle(.gray)
                .font(.caption)
                .padding(.vertical, 10)
        }
    }
    
    //MARK: - Text Bubble
    
    @ViewBuilder
    private func TextBubble(_ text: String) -> some View {
        BubbleView(
            message: text,
            isCurrentUser: message.isCurrentUser,
            isFirst: message.isFirst
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
    MessageView(message:
                    FormattedMessage(
                        id: "1",
                        chatId: "1",
                        text: "Essa é uma mensagem secreta",
                        isCurrentUser: true,
                        isFirst: true,
                        status: .sent,
                        createdAt: 1
                    ),
                resendMessage: {}
    )
}
