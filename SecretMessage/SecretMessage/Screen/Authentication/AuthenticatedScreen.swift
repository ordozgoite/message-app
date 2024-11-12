//
//  AuthenticatedScreen.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 17/10/24.
//

import SwiftUI

struct AuthenticatedScreen: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        if authVM.authenticationState == .authenticated {
            PreparingSessionScreen()
                .environmentObject(authVM)
        } else {
            AuthScreen()
                .environmentObject(authVM)
        }
    }
}

#Preview {
    AuthenticatedScreen()
}
