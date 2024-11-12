//
//  MessageScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import SwiftUI

struct MessageScreen: View {
    
    let chatId: String
    let chatName: String
    
    @StateObject private var messageVM = MessageViewModel()
//    @ObservedObject var socket: SocketService
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ScrollViewReader { proxy in
                        ZStack {
                            VStack(spacing: 0) {
                                ForEach(messageVM.formattedMessages) { message in
                                    MessageView(message: message) {
                                        // resend message
                                    }
                                }
                                .onAppear {
                                    if let lastMessageId = messageVM.formattedMessages.last?.id {
                                        scrollToMessage(withId: lastMessageId, usingProxy: proxy, animated: false)
                                    }
                                }
                                .onChange(of: messageVM.lastMessageAdded) { _ in
                                    if let id = messageVM.lastMessageAdded {
                                        scrollToMessage(withId: id, usingProxy: proxy)
                                    }
                                }
                                .onChange(of: isFocused) { _ in
                                    if isFocused {
                                        if let lastMessageId = messageVM.formattedMessages.last?.id {
                                            scrollToMessage(withId: lastMessageId, usingProxy: proxy)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                scrollToMessage(withId: lastMessageId, usingProxy: proxy)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .refreshable {
                    hapticFeedback(style: .soft)
                    Task {
                        try await getMessages(.oldest)
                    }
                }
                
                MessageComposer()
            }
        }
        .onAppear {
            //            print("⚠️ Stored messages: \(messages)")
            Task {
                try await getMessages(.newest)
            }
            listenToMessages()
        }
        .onDisappear {
            stopListeningMessages()
        }
//        .onChange(of: socket.status) { status in
//            if status == .connected {
//                Task {
//                    try await getMessages(.newest)
//                }
//            }
//        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                UserHeader()
            }
            
//            ToolbarItem(placement: .topBarTrailing) {
//                SocketStatusView(socket: socket)
//            }
        }
    }
    
    //MARK: - User Header
    
    @ViewBuilder
    private func UserHeader() -> some View {
        HStack {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(chatName)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.bottom, 6)
    }
    
    //MARK: - Message Composer
    
    @ViewBuilder
    private func MessageComposer() -> some View {
        VStack {
            HStack(spacing: 8) {
                TextField("Escreva uma mensagem...", text: $messageVM.messageText, axis: .vertical)
                    .padding(10)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(20)
                    .shadow(color: .gray, radius: 10)
                    .focused($isFocused)
                
                if !messageVM.messageText.isEmpty {
                    Button {
                        Task {
//                            let token = try await authVM.getFirebaseToken()
//                            try await messageVM.sendMessage(
//                                chatId,
//                                forChat: messageVM.messageText
//                            )
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    //MARK: - Private Method
    
    private func listenToMessages() {
//        socket.socket?.on("message") { data, ack in
//            if let message = data as? [Any] {
//                print("📩 Received message: \(message)")
//                messageVM.processMessage(message, toChat: chatId) { messageId in
//                    emitReadCommand(forMessage: messageId)
//                }
//            }
//        }
    }
    
    private func emitReadCommand(forMessage messageId: String) {
//        socket.socket?.emit("read", messageId)
    }
    
    private func stopListeningMessages() {
//        socket.socket?.off("message")
    }
    
    enum FetchMessageType {
        case newest
        case oldest
    }
    
    private func getMessages(_ type: FetchMessageType) async throws {
//        let token = try await authVM.getFirebaseToken()
//        switch type {
//        case .newest:
//            await messageVM.getLastMessages(chatId: chatId, token: token)
//        case .oldest:
//            await messageVM.getMessages(chatId: chatId, token: token)
//        }
    }
    
    private func scrollToMessage(withId messageId: String, usingProxy proxy: ScrollViewProxy, animated: Bool = true) {
        if animated {
            withAnimation {
                proxy.scrollTo(messageId, anchor: .top)
            }
        } else {
            proxy.scrollTo(messageId, anchor: .top)
        }
        
    }
    
    private func resendMessage(withId messageId: String) async throws {
//        let token = try await authVM.getFirebaseToken()
//        await messageVM.resendMessage(withTempId: messageId, token: token)
    }
}

#Preview {
//    MessageScreen(chatId: "1", username: "Amanda Hortêncio", otherUserUid: "1")
}
