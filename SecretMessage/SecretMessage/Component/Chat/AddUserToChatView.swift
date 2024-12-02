//
//  AddUserToChatView.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 12/11/24.
//

import SwiftUI

struct AddUserToChatView: View {
    
    @Binding var username: String
    
    let add: () -> ()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 16) {
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                
                SCButton(title: "Add") {
                    add()
                }
            }
            .padding()
            .navigationTitle("Add New User")
        }
    }
}

#Preview {
//    AddUserToChatView()
}
