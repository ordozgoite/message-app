//
//  PreparingSessionScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import SwiftUI

struct PreparingSessionScreen: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isMissingUsername: Bool = false
    
    var body: some View {
        VStack {
            if authVM.isUserInfoFetched {
                MainTabView()
                        .environmentObject(authVM)
            } else {
                if isMissingUsername {
                    UsernameScreen()
                        .environmentObject(authVM)
                } else {
                    LoadingView()
                }
            }
        }
    }
    
    //MARK: - LoadingView
    
    @ViewBuilder
    private func LoadingView() -> some View {
        VStack {
            ProgressView()
            Text("Preparing your session...")
                .foregroundStyle(.gray)
        }
        .onAppear {
            Task {
                let token = try await authVM.getFirebaseToken()
                self.isMissingUsername = await authVM.getUserInfo(token: token)
            }
        }
    }
}

#Preview {
    PreparingSessionScreen()
}
