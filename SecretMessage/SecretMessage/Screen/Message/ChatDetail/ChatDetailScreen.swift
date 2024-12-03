//
//  ChatDetailScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 02/12/24.
//

import SwiftUI

struct ChatDetailScreen: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    let chatId: String
    @State private var usernames: [String] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    List(usernames, id: \.self) { username in
                        Text(username)
                    }
                }
            }
            .onAppear {
                Task {
                    try await getUsernames()
                }
            }
            .navigationTitle("Chat Members")
        }
    }
    
    //MARK: - Private Methods
    
    private func getUsernames() async throws {
        isLoading = true
        let token = try await authVM.getFirebaseToken()
        let response = await SCServices.shared.getUsersInChat(chatId: self.chatId, token: token)
        isLoading = false
        
        switch response {
        case .success(let usernames):
            self.usernames = usernames
        case .failure(let error):
            print("Error trying to fetch usernames: \(error)")
        }
    }
}

#Preview {
    //    ChatDetailScreen()
}
