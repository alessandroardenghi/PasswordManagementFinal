//
//  KeychainManager.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 03/01/24.
//

import Foundation

class KeychainManager: ObservableObject {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    
    
    func save(id: String, data: Data) throws {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: id as AnyObject,
            kSecValueData as String: data as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    func get(id: String) -> KeychainItem? {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: id as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var retrievedData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &retrievedData)

        guard status == errSecSuccess, let encodedData = retrievedData as? Data else {
            print("Failed to retrieve data for ID: \(id)")
            return nil
        }
        
        var decodedObject: KeychainItem?
        do {
            decodedObject = try JSONDecoder().decode(KeychainItem.self, from: encodedData)
            
        } catch {
            print("Failed to decode object for ID \(id): \(error)")
        }
        
        return decodedObject
    }
    
    func update(id: String, new_data: Data) {
            
            delete(id: id)

            let add_query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: id as AnyObject,
                kSecValueData as String: new_data as AnyObject
            ]
            let add_status = SecItemAdd(add_query as CFDictionary, nil)

            guard add_status == errSecSuccess else {
                
                print("Error adding updated item: \(add_status)")
                return
            }
            print("Data updated successfully in Keychain")
        }
    
    func delete(id: String) {
        
        let delete_query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: id as AnyObject
        ]
        let delete_status = SecItemDelete(delete_query as CFDictionary)

        guard delete_status == errSecSuccess || delete_status == errSecItemNotFound else {
            
            print("Error deleting existing item: \(delete_status)")
            return
        }

    }
    
}
