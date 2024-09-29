//
//  MessageViewModel.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import Foundation
import SwiftUI
import AVFoundation

@MainActor
class MessageViewModel: ObservableObject {
    
    private var audioPlayer: AVAudioPlayer?
    private var receivedMessageIds: [String] = []
    
    @Published var formattedMessages: [FormattedMessage] = []
    @Published var intermediaryMessages: [MessageIntermediary] = [] {
        didSet {
            formatMessages()
        }
    }
    @Published var receivedMessages: [Message] = []
    
    @Published var messageText: String = ""
    @Published var overlayError: (Bool, LocalizedStringKey) = (false, "")
    @Published var messageTimer: Timer?
    @Published var lastMessageAdded: String?
    
    //MARK: - Fetch Messages
    
    func getMessages(chatId: String, token: String) async {
        //        let result = await AYServices.shared.getMessages(chatId: chatId, timestamp: intermediaryMessages.first?.createdAt, token: token)
        //
        //        switch result {
        //        case .success(let messages):
        //            self.intermediaryMessages.insert(contentsOf: convertReceivedMessages(messages), at: 0)
        //        case .failure:
        //            overlayError = (true, ErrorMessage.defaultErrorMessage)
        //        }
    }
    
    private func convertReceivedMessages(_ messages: [Message]) -> [MessageIntermediary] {
        var convertedMessages: [MessageIntermediary] = []
        for message in messages {
            let intermediaryMessage = message.convertMessageToIntermediary(forCurrentUserUid: LocalState.currentUserUid)
            convertedMessages.append(intermediaryMessage)
        }
        return convertedMessages
    }
    
    //MARK: - Send Message
    
    func sendMessage(forChat chatId: String, text: String) async throws {
        resetInputs()
        let messagesToBeSent = getMessagesToBeSent(chatId: chatId, text: text)
        displayMessages(fromArray: messagesToBeSent)
        let encryptedText = encryptText(text)
        
        //        await withTaskGroup(of: Void.self) { group in
        //            for message in messagesToBeSent {
        //                group.addTask {
        //                    do {
        //                        try await self.sendMessage(message, token: token)
        //                    } catch {
        //                        print("Error sending message: \(error)")
        //                    }
        //                }
        //            }
        //        }
    }
    
    private func resetInputs() {
        self.messageText = ""
    }
    
    private func getMessagesToBeSent(chatId: String, text: String) -> [MessageIntermediary] {
        var messages: [MessageIntermediary] = []
        
        let message = MessageIntermediary(id: UUID().uuidString, chatId: chatId, text: text, isRead: false, createdAt: Int(Date().timeIntervalSince1970), status: .sending, isCurrentUser: true)
        messages.append(message)
        
        
        return messages
    }
    
    private func displayMessages(fromArray messages: [MessageIntermediary]) {
        for message in messages {
            intermediaryMessages.append(message)
            self.lastMessageAdded = message.id
        }
    }
    
    func encryptText(_ text: String) -> String {
        // encrypt message text
        return ""
    }
    
    private func sendMessage(_ message: MessageIntermediary, token: String) async throws {
        await postNewMessage(withTemporaryId: message.id, chatId: message.chatId, text: message.text, token: token)
    }
    
    private func postNewMessage(withTemporaryId tempId: String, chatId: String, text: String, token: String) async {
        //        let result = await AYServices.shared.postNewMessage(chatId: chatId, text: text, imageUrl: imageUrl, repliedMessageId: repliedMessageId, token: token)
        //
        //        switch result {
        //        case .success(let message):
        //            playSendMessageSound()
        //            updateMessage(withId: tempId, toStatus: .sent)
        //            updateMessage(withId: tempId, toPostedMessage: message)
        //        case .failure:
        //            updateMessage(withId: tempId, toStatus: .failed)
        //            overlayError = (true, ErrorMessage.defaultErrorMessage)
        //        }
    }
    
    private func updateMessage(withId messageId: String, toStatus newStatus: MessageStatus) {
        if let index = intermediaryMessages.firstIndex(where: { $0.id == messageId }) {
            intermediaryMessages[index].status = newStatus
        } else {
            print("❌ Error: Message with ID \(messageId) was not found.")
        }
    }
    
    private func updateMessage(withId messageId: String, toPostedMessage message: Message) {
        if let index = intermediaryMessages.firstIndex(where: { $0.id == messageId }) {
            intermediaryMessages[index].createdAt = message.createdAt
            intermediaryMessages[index].id = message._id
        } else {
            print("❌ Error: Message with ID \(messageId) was not found.")
        }
    }
    
    private func playSendMessageSound() {
        playSound(withName: "sent-message-sound")
    }
    
    func resendMessage(withTempId tempId: String, token: String) async {
        if let message = getMessage(withId: tempId) {
            await postNewMessage(withTemporaryId: tempId, chatId: message.chatId, text: message.text, token: token)
        }
    }
    
    func getMessage(withId messageId: String) -> FormattedMessage? {
        if let index = formattedMessages.firstIndex(where: { $0.id == messageId }) {
            return formattedMessages[index]
        } else {
            return nil
        }
    }
    
    //MARK: - Receive Message
    
    func processMessage(_ data: [Any], toChat chatId: String,  emitReadCommand: (String) -> ()) {
        let newMessage = decodeMessage(data)
        if let msg = newMessage, !msg.isCurrentUser, !wasMessageReceived(msg), msg.chatId == chatId {
            DispatchQueue.main.async {
                self.intermediaryMessages.append(msg)
                self.lastMessageAdded = msg.id
                self.playReceivedMessageSound(forMessageId: msg.id)
            }
            emitReadCommand(msg.id)
        }
    }
    
    private func wasMessageReceived(_ message: MessageIntermediary) -> Bool {
        return intermediaryMessages.contains { $0.id == message.id }
    }
    
    func decodeMessage(_ message: [Any]) -> MessageIntermediary? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message[0], options: [])
            let newMessage = try JSONDecoder().decode(Message.self, from: jsonData)
            return newMessage.convertMessageToIntermediary(forCurrentUserUid: LocalState.currentUserUid)
        } catch {
            print(error)
        }
        return nil
    }
    
    private func playReceivedMessageSound(forMessageId messageId: String) {
        if !receivedMessageIds.contains(messageId) {
            receivedMessageIds.append(messageId)
            print("🎶 Playing sound for messageId: \(messageId)")
            playSound(withName: "received-message-sound")
        }
    }
    
    //MARK: - Format Messages
    
    private func formatMessages() {
        var messages: [FormattedMessage] = []
        for (index, message) in intermediaryMessages.enumerated() {
            let formattedMessage = message.formatMessage(isFirst: getTail(forMessage: message, withIndex: index), timeDivider: getTimeDivider(forMessage: message, withIndex: index))
            messages.append(formattedMessage)
        }
        self.formattedMessages = messages
        //        updateMessagesToBePersisted()
        //        print("⚠️ messagesToBePersisted: \(messagesToBePersisted)")
    }
    
    private func getTail(forMessage message: MessageIntermediary, withIndex index: Int) -> Bool {
        guard index < intermediaryMessages.count - 1 else {
            return true
        }
        
        let nextMessage = intermediaryMessages[index + 1]
        let timeDifferenceSec = nextMessage.createdAt.timeIntervalSince1970InSeconds - message.createdAt.timeIntervalSince1970InSeconds
        return timeDifferenceSec >= 60
    }
    
    private func getTimeDivider(forMessage message: MessageIntermediary, withIndex index: Int) -> Int? {
        guard index > 0 else {
            return message.createdAt
        }
        
        let previousMessage = intermediaryMessages[index - 1]
        let timeDifferenceSec = message.createdAt.timeIntervalSince1970InSeconds - previousMessage.createdAt.timeIntervalSince1970InSeconds
        return timeDifferenceSec >= 3600 ? message.createdAt : nil
    }
    
    private func playSound(withName soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = audioPlayer else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
