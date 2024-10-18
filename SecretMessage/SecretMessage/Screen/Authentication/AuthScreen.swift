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
            Spacer()
            
            LogoView()
            
            Spacer()
            
            SiwA()
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
