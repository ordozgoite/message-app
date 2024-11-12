//
//  NewChatView.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import SwiftUI

struct NewChatView: View {
    
    @Binding var groupName: String
    @Binding var isPresented: Bool
    @Binding var isLoading: Bool
    
    let createChat: () -> ()
    
    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .systemMaterial)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 16) {
                Text("Create New Chat")
                    .fontWeight(.bold)
                
                TextField("Type the chat name...", text: $groupName)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Button("Cancel") {
                        self.isPresented = false
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.gray)
                    
                    Button {
                        createChat()
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                            }
                            Text(isLoading ? "Creating..." : "Create")
                                .foregroundStyle(isLoading ? .gray : .white)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 10)
            )
            .padding()
        }
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

#Preview {
    //    NewChatView(groupName: <#T##String#>, isPresented: <#T##Bool#>, isLoading: <#T##Bool#>)
}
