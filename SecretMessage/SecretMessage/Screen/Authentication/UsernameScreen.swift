//
//  UsernameScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import SwiftUI

struct UsernameScreen: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @FocusState private var authInputIsFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    
                    TextField("Choose a username...", text: $authVM.usernameInput)
                        .focused($authInputIsFocused)
                        .textFieldStyle(.roundedBorder)
                    
                    Spacer()
                    
                    SCButton(title: "Done") {
                        Task {
                            try await chooseUsername()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Username")
            .toolbar {
                ToolbarItem {
                    Button {
                        authVM.signOut()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
    
    //MARK: - Private Method
    
    private func chooseUsername() async throws {
        if authVM.isUsernameValid() {
            let token = try await authVM.getFirebaseToken()
            _ = await authVM.postNewUser(token: token)
        }
    }
}

#Preview {
    UsernameScreen()
        .environmentObject(AuthViewModel())
}
