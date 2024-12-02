//
//  SettingScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 18/10/24.
//

import SwiftUI

struct SettingScreen: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationView {
            Form {
                //MARK: - Exit
                
                Section {
                    HStack {
                        Spacer()
                        Button("Sign Out") {
                            print("👉 SIGN OUT")
                            authVM.signOut()
                        }
                        .foregroundStyle(.red)
                        Spacer()
                    }
                }
            }
            
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingScreen()
        .environmentObject(AuthViewModel())
}
