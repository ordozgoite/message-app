//
//  MessageScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import SwiftUI

struct MessageScreen: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    let chat: FormattedChat
    
    @StateObject private var messageVM = MessageViewModel()
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
                                    MessageView(message: message) {}
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
                
                MessageComposer()
            }
        }
        .onAppear {
            Task {
                try await updateMessages()
            }
        }
        .sheet(isPresented: $messageVM.isAddUserSheetDisplayed) {
            AddUserToChatView(username: $messageVM.newUserUsername) {
                Task {
                    let token = try await authVM.getFirebaseToken()
                    await messageVM.addUser(messageVM.newUserUsername, toChat: self.chat.id, token: token)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                UserHeader()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    messageVM.isAddUserSheetDisplayed = true
                } label: {
                    Image(systemName: "person.badge.plus")
                }
                
            }
        }
    }
    
    //MARK: - User Header
    
    @ViewBuilder
    private func UserHeader() -> some View {
        HStack {
            Text(chat.chatName)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
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
                            let token = try await authVM.getFirebaseToken()
                            try await messageVM.sendMessage(
                                messageVM.messageText,
                                forChat: self.chat,
                                token: token
                            )
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
    
    private func updateMessages() async throws {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            Task {
                do {
                    try await self.getMessages()
                } catch {
                    print("Erro ao atualizar mensagens: \(error)")
                }
            }
        }
    }
    
    private func getMessages() async throws {
        let token = try await authVM.getFirebaseToken()
        await messageVM.getMessages(chat: chat, token: token)
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
}

#Preview {
    //    MessageScreen(chatId: "1", username: "Amanda Hortêncio", otherUserUid: "1")
}
