//
//  String.swift
//  SecretMessage
//
//  Created by Victor Ordozgoite on 26/09/24.
//

import Foundation

extension String {
    func convertToTimestamp() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return Int(date.timeIntervalSince1970)
        } else {
            return nil
        }
    }
    
    func nonEmptyOrNil() -> String? {
        return self.isEmpty ? nil : self
    }
}
