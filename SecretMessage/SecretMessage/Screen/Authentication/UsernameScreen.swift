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
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    TextField("Choose a username...", text: $authVM.usernameInput)
                        .focused($authInputIsFocused)
                        .textFieldStyle(.roundedBorder)
                    
//                    AYTextField(imageName: "person.fill", title: "Choose a username...", error: $authVM.errorMessage.0, inputText: $authVM.usernameInput)
//                        .focused($authInputIsFocused)
//                        .onChange(of: authVM.usernameInput) { newValue in
//                            if newValue.count > Constants.maxUsernameLenght {
//                                authVM.usernameInput = String(newValue.prefix(Constants.maxUsernameLenght))
//                            }
//                        }
                    
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
