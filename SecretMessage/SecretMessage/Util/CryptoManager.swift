//
//  CryptoManager.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 29/09/24.
//

import Foundation
import CryptoKit

struct CryptoManager {
    func generateECDHKeys() -> (privateKey: P256.KeyAgreement.PrivateKey, publicKey: P256.KeyAgreement.PublicKey) {
        let privateKey = P256.KeyAgreement.PrivateKey()
        let publicKey = privateKey.publicKey
        return (privateKey, publicKey)
    }
    
    func generateSharedSecret(privateKey: P256.KeyAgreement.PrivateKey, peerPublicKey: P256.KeyAgreement.PublicKey) -> SymmetricKey {
        let sharedSecret = try! privateKey.sharedSecretFromKeyAgreement(with: peerPublicKey)
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: Data(),
            sharedInfo: Data(),
            outputByteCount: 32
        )
        return symmetricKey
    }
    
    func encryptMessage(message: String, key: SymmetricKey) -> Data? {
        do {
            let messageData = message.data(using: .utf8)!
            let sealedBox = try ChaChaPoly.seal(messageData, using: key)
            return sealedBox.combined
        } catch {
            print("Erro na criptografia ChaCha20-Poly1305: \(error)")
            return nil
        }
    }
    
    func decryptMessage(ciphertext: Data, key: SymmetricKey) -> String? {
        do {
            let sealedBox = try ChaChaPoly.SealedBox(combined: ciphertext)
            let decryptedData = try ChaChaPoly.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            print("Erro na descriptografia ChaCha20-Poly1305: \(error)")
            return nil
        }
    }
    
    // Função para testar a criptografia e descriptografia
    func testEncryption() {
        // Gerando chaves ECDH para duas partes (usuário A e usuário B)
        let userAKeys = generateECDHKeys()
        let userBKeys = generateECDHKeys()

        // Gerando o segredo compartilhado (a chave simétrica)
        let sharedSecretA = generateSharedSecret(privateKey: userAKeys.privateKey, peerPublicKey: userBKeys.publicKey)
        let sharedSecretB = generateSharedSecret(privateKey: userBKeys.privateKey, peerPublicKey: userAKeys.publicKey)

        // Exemplo de mensagem a ser criptografada
        let mensagemOriginal = "Esta é uma mensagem secreta."

        // Criptografando a mensagem usando a chave compartilhada com ChaCha20-Poly1305
        if let mensagemCriptografada = encryptMessage(message: mensagemOriginal, key: sharedSecretA) {
            print("Mensagem criptografada: \(mensagemCriptografada.base64EncodedString())")
            
            // Descriptografando a mensagem usando a mesma chave
            if let mensagemDescriptografada = decryptMessage(ciphertext: mensagemCriptografada, key: sharedSecretB) {
                print("Mensagem descriptografada: \(mensagemDescriptografada)")
            } else {
                print("Falha na descriptografia.")
            }
        } else {
            print("Falha na criptografia.")
        }
    }
}
