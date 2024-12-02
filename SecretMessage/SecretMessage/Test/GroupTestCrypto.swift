//
//  GroupTestCrypto.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 11/11/24.
//

import SwiftUI
import CryptoKit

struct GroupTestCrypto: View {
    
    private let cryptoManager = CryptoManager()
    
    @State private var userAKeys: (privateKey: P256.KeyAgreement.PrivateKey?, publicKey: P256.KeyAgreement.PublicKey?) = (nil, nil)
    @State private var userBKeys: (privateKey: P256.KeyAgreement.PrivateKey?, publicKey: P256.KeyAgreement.PublicKey?) = (nil, nil)
    @State private var userCKeys: (privateKey: P256.KeyAgreement.PrivateKey?, publicKey: P256.KeyAgreement.PublicKey?) = (nil, nil)
    
    @State private var sharedSecretA: SymmetricKey?
    @State private var sharedSecretB: SymmetricKey?
    @State private var sharedSecretC: SymmetricKey?
    
    @State private var messageText: String = ""
    
    @State private var ciphertext: Data?
    
    @State private var encryptedText: String = ""
    
    @State private var bDecryptedText: String = ""
    @State private var cDecryptedText: String = ""
    
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
            
            Button("🔓 User B decrypt Text") {
                bDecryptedText = decryptText(withUserB: true)
            }
            .buttonStyle(.bordered)
            .disabled(encryptedText.isEmpty)
            
            Text("**Decrypted Text:** \(bDecryptedText)")
            
            Button("🔓 User C decrypt Text") {
                cDecryptedText = decryptText(withUserB: false)
            }
            .buttonStyle(.bordered)
            .disabled(encryptedText.isEmpty)
            
            Text("**Decrypted Text:** \(cDecryptedText)")
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
        userCKeys = cryptoManager.generateECDHKeys()
        
        print("🔑 User A Keys: \(userAKeys)")
        print("🔑 User B Keys: \(userBKeys)")
        print("🔑 User B Keys: \(userCKeys)")
    }
    
    private func generateSharedSecrets() {
        let shared_secret_AB = cryptoManager.generateSharedSecret(privateKey: userAKeys.privateKey!, peerPublicKey: userBKeys.publicKey!)
        let shared_secret_AC = cryptoManager.generateSharedSecret(privateKey: userAKeys.privateKey!, peerPublicKey: userCKeys.publicKey!)
        
        let shared_secret_BA = cryptoManager.generateSharedSecret(privateKey: userBKeys.privateKey!, peerPublicKey: userAKeys.publicKey!)
        let shared_secret_BC = cryptoManager.generateSharedSecret(privateKey: userBKeys.privateKey!, peerPublicKey: userCKeys.publicKey!)
        
        let shared_secret_CA = cryptoManager.generateSharedSecret(privateKey: userCKeys.privateKey!, peerPublicKey: userAKeys.publicKey!)
        let shared_secret_CB = cryptoManager.generateSharedSecret(privateKey: userCKeys.privateKey!, peerPublicKey: userBKeys.publicKey!)
        
        print("🤫 Shared Secret A: \(sharedSecretA)")
        print("🤫 Shared Secret B: \(sharedSecretB)")
        print("🤫 Shared Secret B: \(sharedSecretC)")
    }
    
    private func encryptText() {
        ciphertext = cryptoManager.encryptMessage(message: self.messageText, key: sharedSecretA!)
        self.encryptedText = ciphertext?.base64EncodedString() ?? "Não encriptou"
    }
    
    private func decryptText(withUserB isUserB: Bool) -> String {
        return cryptoManager.decryptMessage(ciphertext: ciphertext!, key: isUserB ? sharedSecretB! : sharedSecretC!) ?? "Não decriptou"
    }
}

#Preview {
    GroupTestCrypto()
}
