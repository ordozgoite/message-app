//
//  FormattedMessage.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import Foundation
import SwiftUI

struct FormattedMessage: Identifiable, Equatable, Hashable {
    let id: String
    let chatId: String
    var text: String
    var isCurrentUser: Bool
    var isFirst: Bool
    var status: MessageStatus
}
