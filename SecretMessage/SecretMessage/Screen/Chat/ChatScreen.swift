//
//  ChatScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import SwiftUI

struct ChatScreen: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var chatVM = ChatViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Chats()
                
                NewChat()
            }
            .onAppear {
                Task {
                    try await updateChats()
                }
            }
            .navigationTitle("\(authVM.username)'s Chats")
            .onAppear {
                Task {
                    let token = try await authVM.getFirebaseToken()
                    print("🔑 FIREBASE TOKEN: \(token)")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        chatVM.isNewChatViewDisplayed = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
    
    //MARK: - Chats
    
    @ViewBuilder
    private func Chats() -> some View {
        List {
            if chatVM.chats.isEmpty {
                ForEach(self.chatVM.chats) { chat in
                    ChatView(chat: chat)
                }
            } else {
                ForEach($chatVM.chats) { $chat in
                    NavigationLink(destination: MessageScreen(chat: chat)
                    ) {
                        ChatView(chat: chat)
                    }
                }
            }
        }
    }
    
    //MARK: - New Chat
    
    @ViewBuilder
    private func NewChat() -> some View {
        if chatVM.isNewChatViewDisplayed {
            NewChatView(groupName: $chatVM.newChatName, isPresented: $chatVM.isNewChatViewDisplayed, isLoading: $chatVM.isCreatingNewChat) {
                Task {
                    try await createNewChat()
                }
            }
        }
    }
    
    //MARK: - Private Method
    
    private func createNewChat() async throws {
        let token = try await authVM.getFirebaseToken()
        await chatVM.createNewChat(token: token)
    }
    
    private func updateChats() async throws {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            Task {
                do {
                    try await self.getChats()
                } catch {
                    print("Erro ao atualizar mensagens: \(error)")
                }
            }
        }
    }
    
    private func getChats() async throws {
        let token = try await authVM.getFirebaseToken()
        await chatVM.getChats(token: token)
    }
}

#Preview {
    ChatScreen()
        .environmentObject(AuthViewModel())
}
