//
//  TestCrypto.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 05/11/24.
//

import SwiftUI
import CryptoKit

struct TestCrypto: View {
    
    private let cryptoManager = CryptoManager()
    
    @State private var userAKeys: (privateKey: P256.KeyAgreement.PrivateKey?, publicKey: P256.KeyAgreement.PublicKey?) = (nil, nil)
    @State private var userBKeys: (privateKey: P256.KeyAgreement.PrivateKey?, publicKey: P256.KeyAgreement.PublicKey?) = (nil, nil)
    
    @State private var sharedSecretA: SymmetricKey?
    @State private var sharedSecretB: SymmetricKey?
    
    @State private var messageText: String = ""
    
    @State private var ciphertext: Data?
    
    @State private var encryptedText: String = ""
    @State private var decryptedText: String = ""
    
    var body: some View {
        VStack(spacing: 32) {
            TextField("Your Message...", text: $messageText)
                .textFieldStyle(.roundedBorder)
            
            Button("🔐 Encrypt Text") {
                encryptText()
            }
            .buttonStyle(.bordered)
            .disabled(messageText.isEmpty)
            
            Text("**Encrypted Text:** \(encryptedText)")
            
            Button("🔓 Decrypt Text") {
                decryptText()
            }
            .buttonStyle(.bordered)
            .disabled(encryptedText.isEmpty)
            
            Text("**Decrypted Text:** \(decryptedText)")
        }
        .padding()
        .onAppear {
            generateKeys()
            generateSharedSecrets()
        }
    }
    
    //MARK: - Private Methods
    
    private func generateKeys() {
        userAKeys = cryptoManager.generateECDHKeys()
        userBKeys = cryptoManager.generateECDHKeys()
        
        print("🔑 User A Keys: \(userAKeys)")
        print("🔑 User B Keys: \(userBKeys)")
    }
    
    private func generateSharedSecrets() {
        sharedSecretA = cryptoManager.generateSharedSecret(privateKey: userAKeys.privateKey!, peerPublicKey: userBKeys.publicKey!)
        sharedSecretB = cryptoManager.generateSharedSecret(privateKey: userBKeys.privateKey!, peerPublicKey: userAKeys.publicKey!)
        
        print("🤫 Shared Secret A: \(sharedSecretA)")
        print("🤫 Shared Secret B: \(sharedSecretB)")
    }
    
    private func encryptText() {
        ciphertext = cryptoManager.encryptMessage(message: self.messageText, key: sharedSecretA!)
        self.encryptedText = ciphertext?.base64EncodedString() ?? "Não encriptou"
    }
    
    private func decryptText() {
        decryptedText = cryptoManager.decryptMessage(ciphertext: ciphertext!, key: sharedSecretB!) ?? "Não decriptou"
    }
}

#Preview {
    TestCrypto()
}
