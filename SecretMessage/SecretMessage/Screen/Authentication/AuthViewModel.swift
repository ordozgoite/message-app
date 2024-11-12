//
//  AuthViewModel.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 15/10/24.
//

import Foundation
import FirebaseAuth
import SwiftUI

// For Sign in with Apple
import AuthenticationServices
import CryptoKit

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: User?
    @Published var username: String = ""
    @Published var overlayError: (Bool, LocalizedStringKey) = (false, "")
    @Published var isUserInfoFetched: Bool = false
    
    @Published var usernameInput: String = ""
    
    private var currentNonce: String?
    
    init() {
        registerAuthStateHandler()
        verifySignInWithAppleAuthenticationState()
      }

      private var authStateHandler: AuthStateDidChangeListenerHandle?

      func registerAuthStateHandler() {
        if authStateHandler == nil {
          authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
            self.user = user
            self.authenticationState = user == nil ? .unauthenticated : .authenticated
//            self.displayName = user?.displayName ?? user?.email ?? ""
          }
        }
      }
    
    func getFirebaseToken() async throws -> String {
        return try await user?.getIDToken() ?? ""
    }
}

extension AuthViewModel {
    func signOut() {
        do {
          try Auth.auth().signOut()
        }
        catch {
          print(error)
          errorMessage = error.localizedDescription
        }
      }

      func deleteAccount() async -> Bool {
        do {
          try await user?.delete()
          return true
        }
        catch {
          errorMessage = error.localizedDescription
          return false
        }
      }
}

//MARK: - SiwA

extension AuthViewModel {

  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
  }

  func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
    if case .failure(let failure) = result {
      errorMessage = failure.localizedDescription
    }
    else if case .success(let authorization) = result {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: a login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetdch identify token.")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
          return
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        Task {
          do {
            let result = try await Auth.auth().signIn(with: credential)
//            await updateDisplayName(for: result.user, with: appleIDCredential)
          }
          catch {
            print("Error authenticating: \(error.localizedDescription)")
          }
        }
      }
    }
  }

//  func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
//    if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
//      // current user is non-empty, don't overwrite it
//    }
//    else {
//      let changeRequest = user.createProfileChangeRequest()
////      changeRequest.displayName = appleIDCredential.displayName()
//      do {
//        try await changeRequest.commitChanges()
//        self.displayName = Auth.auth().currentUser?.displayName ?? ""
//      }
//      catch {
//        print("Unable to update the user's displayname: \(error.localizedDescription)")
//        errorMessage = error.localizedDescription
//      }
//    }
//  }

  func verifySignInWithAppleAuthenticationState() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let providerData = Auth.auth().currentUser?.providerData
    if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
      Task {
        do {
          let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
          switch credentialState {
          case .authorized:
            break // The Apple ID credential is valid.
          case .revoked, .notFound:
            // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
            self.signOut()
          default:
            break
          }
        }
        catch {
        }
      }
    }
  }

}

//MARK: - SC Methods

extension AuthViewModel {
    func postNewUser(token: String) async -> Bool {
        let result = await SFServices.shared.postNewUser(username: self.usernameInput, token: token)
        
        switch result {
        case .success(let user):
            updateCurrentInformation(for: user)
        case .failure(let error):
            if error == .conflict {
                overlayError = (true, ErrorMessage.usernameInUseMessage)
                return true
            } else {
                signOut()
                overlayError = (true, ErrorMessage.defaultErrorMessage)
            }
        }
        return false
    }
    
    func getUserInfo(token: String) async -> Bool {
        let result = await SFServices.shared.getUserInfo(token: token)
        
        switch result {
        case .success(let user):
            updateCurrentInformation(for: user)
        case .failure(let error):
            if error == .dataNotFound {
                return true
            } else {
                signOut()
                overlayError = (true, ErrorMessage.defaultErrorMessage)
            }
        }
        return false
    }
    
//    private func deleteUser() async throws -> Bool {
//        let token = try await getFirebaseToken()
//        let result = await AYServices.shared.deleteUser(token: token)
//        
//        switch result {
//        case .success:
//            return true
//        case .failure:
//            return false
//        }
//    }
    
    private func updateCurrentInformation(for user: MongoUser) {
        LocalState.currentUserUid = user.userUid
        self.username = user.username
        self.isUserInfoFetched = true
    }
    
    func isUsernameValid() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9._]+$")
        let range = NSRange(location: 0, length: usernameInput.utf16.count)
        let isUserNameValid = regex.firstMatch(in: usernameInput, options: [], range: range) != nil
        if !isUserNameValid { overlayError.1 = "Invalid username format." }
        return isUserNameValid
    }
    
    private func resetUserInfo() {
        username = ""
        isUserInfoFetched = false
    }
    
    private func resetInputs() {
        usernameInput = ""
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: [Character] =
  Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}

private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()

  return hashString
}
