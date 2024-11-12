//
//  FormattedChat.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import Foundation

struct FormattedChat: Codable, Identifiable, Equatable {
    let id: String
    let chatName: String
    let participantUserUids: [String]
    let publicKeys: [String: String]
}
