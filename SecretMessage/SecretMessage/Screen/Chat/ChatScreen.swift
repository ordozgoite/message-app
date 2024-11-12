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
    //    @ObservedObject var socket: SocketService
    
    var body: some View {
        NavigationStack {
            ZStack {
                Chats()
                
                NewChat()
            }
            //            .onAppear {
            //                updateChats()
            //                listenToMessages()
            //            }
            //            .onChange(of: socket.status) { status in
            //                if status == .connected {
            //                    updateChats()
            //                }
            //            }
            .navigationTitle("Your Chats")
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
                    
//                    SocketStatusView(socket: socket)
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
                    NavigationLink(destination: MessageScreen(chatId: chat.id, chatName: chat.chatName)
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
    
    //    private func updateChats() {
    //        Task {
    //            let token = try await authVM.getFirebaseToken()
    //            await chatListVM.getChats(token: token)
    //        }
    //    }
    
    //    private func listenToMessages() {
    //        print("⚠️ listenToMessages")
    //        socket.socket?.on("chat") { data, ack in
    //            print("⚠️ updateChats")
    //            updateChats()
    //        }
    //    }
}

#Preview {
    ChatScreen()
        .environmentObject(AuthViewModel())
}
