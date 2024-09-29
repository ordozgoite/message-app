//
//  ChatScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import SwiftUI

struct ChatScreen: View {
    
    @StateObject private var chatVM = ChatViewModel()
    //    @ObservedObject var socket: SocketService
    
    var body: some View {
        NavigationStack {
            ZStack {
                Chats()
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
            .navigationTitle("Chats")
            //            .toolbar {
            //                ToolbarItem(placement: .topBarTrailing) {
            //                    SocketStatusView(socket: socket)
            //                }
            //            }
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
                    NavigationLink(destination: MessageScreen(chatId: chat.id, username: chat.chatName, otherUserUid: chat.otherUserUid)
                    ) {
                        ChatView(chat: chat)
                    }
                }
            }
        }
    }
    
    //MARK: - Private Method
    
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
}
