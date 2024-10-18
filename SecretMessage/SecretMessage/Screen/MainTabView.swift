//
//  MainTabView.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 18/10/24.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        TabView {
            ChatScreen()
                .tabItem {
                    Label("Chats", systemImage: "bubble.left.and.bubble.right")
                }
                .environmentObject(authVM)
            
            SettingScreen()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .environmentObject(authVM)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
