//
//  ContentView.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        GroupTestCrypto()
        AuthenticatedScreen()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
