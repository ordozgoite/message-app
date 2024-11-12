//
//  ErrorMessage.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 05/11/24.
//

import Foundation
import SwiftUI

struct ErrorMessage {
    
    static let defaultErrorMessage: LocalizedStringKey = "Oops! Looks like something went wrong. Try again later."
    static let invalidUsernameMessage: LocalizedStringKey = "The username you have chosen contains invalid characters. Please try another."
    static let usernameInUseMessage: LocalizedStringKey = "This username isn't available. Please try another."
    static let encryptErrorMessage: LocalizedStringKey = "Something went wrong while encrypting your message."
}
