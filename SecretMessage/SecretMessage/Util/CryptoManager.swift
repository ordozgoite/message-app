//
//  CryptoManager.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 29/09/24.
//

import CryptoKit
import Foundation

class CryptoManager {
    
    // Gerar chave pública e privada
    func generatePrivateKey() -> P256.KeyAgreement.PrivateKey {
        return P256.KeyAgreement.PrivateKey()
    }

    func getPublicKey(from privateKey: P256.KeyAgreement.PrivateKey) -> P256.KeyAgreement.PublicKey {
        return privateKey.publicKey
    }

    // Gerar um segredo compartilhado
    func generateSharedSecret(privateKey: P256.KeyAgreement.PrivateKey, publicKey: P256.KeyAgreement.PublicKey) throws -> SharedSecret {
        return try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
    }

    // Derivar uma chave simétrica do segredo compartilhado
    func deriveSymmetricKey(from sharedSecret: SharedSecret) -> SymmetricKey {
        return sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: Data(), sharedInfo: Data(), outputByteCount: 32)
    }

    // Criptografar mensagem
    func encryptMessage(_ message: Data, using symmetricKey: SymmetricKey) throws -> AES.GCM.SealedBox {
        return try AES.GCM.seal(message, using: symmetricKey)
    }

    // Descriptografar mensagem
    func decryptMessage(_ sealedBox: AES.GCM.SealedBox, using symmetricKey: SymmetricKey) throws -> Data {
        return try AES.GCM.open(sealedBox, using: symmetricKey)
    }
}

