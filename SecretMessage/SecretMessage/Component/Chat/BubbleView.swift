//
//  BubbleView.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import SwiftUI

struct BubbleView: View {
    
    var message: String
    var isCurrentUser: Bool
    var isFirst: Bool
    var username: String?
    
    var body: some View {
        HStack {
            if !isCurrentUser, let initial = username?.first {
                Text(initial.uppercased())
                    .font(.caption)
                    .padding(6)
                    .background(Circle().fill(Color.gray))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
            }
            
            Text(message)
                .foregroundStyle(isCurrentUser ? .white : .primary)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    isCurrentUser ? .blue : Color(uiColor: .secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
                .background(alignment: isCurrentUser ? .bottomTrailing : .bottomLeading) {
                    isFirst
                    ?
                    Image(isCurrentUser ? "outgoingTail" : "incomingTail")
                        .renderingMode(.template)
                        .foregroundStyle(isCurrentUser ? .blue : Color(uiColor: .secondarySystemBackground))
                    :
                    nil
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isCurrentUser ? .trailing : .leading)
                .padding(isCurrentUser ? .leading : .trailing, 64)
                .padding(.bottom, isFirst ? 8 : 2)
        }
    }
}

#Preview {
    BubbleView(message: "Essa mensagem é secreta", isCurrentUser: true, isFirst: true)
}
