//
//  AuthScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 15/10/24.
//

import SwiftUI
import AuthenticationServices

struct AuthScreen: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        VStack {
            LogoView()
            
            Spacer()
            
            Inputs()
            
            Spacer()
            
            AuthButton()
            
            SiwA()
            
            Button(authVM.flow == .login ? "Create New Account" : "I already have an account") {
                authVM.flow = authVM.flow == .login ? .signUp : .login
            }
        }
        .padding()
    }
    
    //MARK: - Logo View
    
    @ViewBuilder
    private func LogoView() -> some View {
        Image(systemName: "lock.shield")
            .resizable()
            .scaledToFit()
            .frame(width: 128)
            .foregroundStyle(.gray)
        
        Text("Safe Chat")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.gray)
    }
    
    //MARK: - Inputs
    
    @ViewBuilder
    private func Inputs() -> some View {
        VStack {
            TextField("E-mail", text: $authVM.emailInput)
                
            SecureField("Password", text: $authVM.passwordInput)
        }
        .textInputAutocapitalization(.never)
        .textFieldStyle(.roundedBorder)
    }
    
    //MARK: - Auth Button
    
    @ViewBuilder
    private func AuthButton() -> some View {
        SCButton(title: authVM.flow == .login ? "Sign in" : "Sign up") {
            Task {
                switch authVM.flow {
                case .login:
                    await authVM.signInWithEmailPassword()
                case .signUp:
                    await authVM.signUpWithEmailPassword()
                }
            }
        }
    }
    
    //MARK: - SiwA
    
    @ViewBuilder
    private func SiwA() -> some View {
        SignInWithAppleButton(.continue) { request in
            authVM.handleSignInWithAppleRequest(request)
        } onCompletion: { result in
            authVM.handleSignInWithAppleCompletion(result)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 64, maxHeight: 64)
        .cornerRadius(10)
    }
}

#Preview {
    AuthScreen()
        .environmentObject(AuthViewModel())
}
