//
//  Cryptor.swift
//  RSA
//
//  Created by Mustafa Yusuf on 7.01.2016.
//  Copyright © 2016 Mustafa Yusuf. All rights reserved.
//

import Foundation
import Security

private let privateTag = "com.apple.sample.privatekey".dataUsingEncoding(NSUTF8StringEncoding)!
private let publicTag = "com.apple.sample.publickey".dataUsingEncoding(NSUTF8StringEncoding)!

public class RSACryptor {
    
    private let keySize: Int
    
    public init(keySize: Int) {
        self.keySize = keySize
    }
    
    public func encryptData(data: NSData, key: SecKeyRef) -> NSData? {
        guard data.length <= SecKeyGetBlockSize(key)
        else { return nil }
        
        let plainText = UnsafePointer<UInt8>(data.bytes)
        let cipherText = UnsafeMutablePointer<UInt8>.alloc(keySize)
        defer {
            free(cipherText)
        }
        var length = keySize
        
        let result = SecKeyEncrypt(key, .None, plainText, data.length, cipherText, &length)
        
        guard result == noErr else { return nil }
        
        return NSData(bytes: cipherText, length: length)
    }
    
    public func decryptData(data: NSData, key: SecKeyRef) -> NSData? {
        let cipherText = UnsafePointer<UInt8>(data.bytes)
        let plainText = UnsafeMutablePointer<UInt8>.alloc(keySize / 8)
        defer {
            free(plainText)
        }
        var length = keySize / 8
        
        let result = SecKeyDecrypt(key, .None, cipherText, data.length, plainText, &length)
        
        guard result == noErr else { return nil }
        
        return NSData(bytes: plainText, length: length)
    }
    
    public func generateKeyPair() -> (publicKey: SecKeyRef, privateKey: SecKeyRef)? {
        let prvAttr: CFDictionaryRef = [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: privateTag
        ]
        
        let pblcAttr: CFDictionaryRef = [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: publicTag
        ]
        
        let keyPairAttr: CFDictionaryRef = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA as String,
            kSecAttrKeySizeInBits as String: keySize,
            kSecPrivateKeyAttrs as String: prvAttr,
            kSecPublicKeyAttrs as String: pblcAttr
        ]
        
        var privateKey: SecKey? = nil
        var publicKey: SecKey? = nil
        
        let result = SecKeyGeneratePair(keyPairAttr, &publicKey, &privateKey)
        
        if let privateKey = privateKey, publicKey = publicKey where result == noErr {
            return (publicKey, privateKey)
        } else {
            return nil
        }
    }
}
