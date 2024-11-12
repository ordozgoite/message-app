//
//  SCButton.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import SwiftUI

struct SCButton: View {
    
    let title: LocalizedStringKey
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44, maxHeight: 44)
        }
        .buttonStyle(.borderedProminent)
    }
}

//#Preview {
//    SCButton()
//}
