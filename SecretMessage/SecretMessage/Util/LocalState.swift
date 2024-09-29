//
//  LocalState.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import Foundation

public class LocalState {
    
    private enum Keys: String {
        case currentUserUid
    }
    
    public static var currentUserUid: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.currentUserUid.rawValue) ?? ""
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.currentUserUid.rawValue)
        }
    }
}
