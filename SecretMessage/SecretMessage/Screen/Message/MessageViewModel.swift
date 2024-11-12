//
//  MessageViewModel.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import Foundation
import SwiftUI
import AVFoundation
import CryptoKit

@MainActor
class MessageViewModel: ObservableObject {
    
    private var audioPlayer: AVAudioPlayer?
    private var receivedMessageIds: [String] = []
    private let cryptoManager = CryptoManager()
    
    @Published var sharedSecretA: SymmetricKey?
    
    @Published var formattedMessages: [FormattedMessage] = []
    @Published var isAddUserSheetDisplayed: Bool = false
    @Published var newUserUsername: String = ""
    
    @Published var messageText: String = ""
    @Published var overlayError: (Bool, LocalizedStringKey) = (false, "")
    @Published var messageTimer: Timer?
    @Published var lastMessageAdded: String?
    
    //MARK: - Fetch Messages
    
    func getMessages(chat: FormattedChat, token: String) async {
        let result = await SCServices.shared.getMessagesByChat(chatId: chat.id, token: token)
        
        switch result {
        case .success(let messages):
            let decryptedMessages = decryptMessages(messages, inChat: chat)
            formatMessages(decryptedMessages)
        case .failure:
            overlayError = (true, ErrorMessage.defaultErrorMessage)
        }
    }
    
    private func decryptMessages(_ messages: [MongoMessage], inChat chat: FormattedChat) -> [MongoMessage] {
        var decryptedMessages: [MongoMessage] = []
        
        for message in messages {
            let privateKey = cryptoManager.retrievePrivateKey(chatId: chat.id)!
            print("⚠️ privateKey: \(privateKey)")
            let secret = cryptoManager.generateSharedSecret(privateKey: cryptoManager.stringToPrivateKey(base64String: privateKey)!, peerPublicKey: cryptoManager.stringToPublicKey(base64String: chat.publicKeys[message.senderUserUid]!)!)
            print("⚠️ secret: \(secret)")
            print("⚠️ messageText: \(message.text)")
            let cipherData = cryptoManager.convertBase64ToData(base64String: message.text)!
            print("⚠️ cipherData: \(cipherData)")
            let plainText = cryptoManager.decryptMessage(ciphertext: cipherData, key: secret)!
            let plainMessage = MongoMessage(_id: message._id, chatId: message.chatId, senderUserUid: message.senderUserUid, text: plainText, targetUserUid: message.targetUserUid)
            decryptedMessages.append(plainMessage)
        }
        return decryptedMessages
    }
    
    private func formatMessages(_ messages: [MongoMessage]) {
        for message in messages {
            formattedMessages.append(message.format())
        }
    }
    
    //MARK: - Send Message
    
    func sendMessage(_ text: String, forChat chat: FormattedChat, token: String) async throws {
        resetInputs()
        displayMessage(chatId: chat.id, text: text)
        let userUids = chat.publicKeys.keys
        for userUid in userUids {
            let encryptedText = encryptText(text, withPubKey: chat.publicKeys[userUid]!, forChat: chat.id)
            await postNewEncryptedMessage(encryptedText!, forChat: chat.id, forUser: userUid, token: token)
        }
    }
    
    private func resetInputs() {
        self.messageText = ""
    }
    
    func displayMessage(chatId: String, text: String) {
        formattedMessages.append(FormattedMessage(id: UUID().uuidString, chatId: chatId, text: text, isCurrentUser: true, isFirst: false, status: .sent))
    }
    
    private func encryptText(_ text: String, withPubKey pubKey: String, forChat chatId: String) -> String? {
        let myPrivKey = cryptoManager.retrievePrivateKey(chatId: chatId)
        if let pubKeyData = cryptoManager.stringToPublicKey(base64String: pubKey), let privKey = cryptoManager.stringToPrivateKey(base64String: myPrivKey!) {
            let secret = cryptoManager.generateSharedSecret(privateKey: privKey, peerPublicKey: pubKeyData)
            let cipher = cryptoManager.encryptMessage(message: text, key: secret)
            return cipher?.base64EncodedString()
        } else {
            print("⚠️ Error: Could not convert pub key to data")
                  return nil
        }
    }
    
    func postNewEncryptedMessage(_ encryptedText: String, forChat chatId: String, forUser userUid: String, token: String) async {
        _ = await SCServices.shared.postMessage(chatId: chatId, text: encryptedText, targetUserUid: userUid, token: token)
    }
    
    //MARK: - Add User
    
    func addUser(_ username: String, toChat chatId: String, token: String) async {
        self.newUserUsername = ""
        _ = await SCServices.shared.addUserToChat(chatId: chatId, username: username, token: token)
    }
}
