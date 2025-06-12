//
//  String+Extension.swift
//  PhotoPicsum
//
//  Created by ThienTran on 12/6/25.
//

import Foundation

extension String {
    func normalizedSearchText(limit: Int = 15) -> String {
        // Keep only letters, numbers, and selected special characters
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*():.,<>/[]?")
        let filtered = self.unicodeScalars.filter { allowedCharacters.contains($0) }
        let filteredString = String(String.UnicodeScalarView(filtered))

        // Remove diacritics
        let normalized = filteredString.folding(options: .diacriticInsensitive, locale: .current)

        // Limit to desired character count
        return String(normalized.prefix(limit))
    }
}
