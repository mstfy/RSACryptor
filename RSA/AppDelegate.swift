//
//  AppDelegate.swift
//  RSA
//
//  Created by Mustafa Yusuf on 7.01.2016.
//  Copyright © 2016 Mustafa Yusuf. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let start = "Hello World"
        print("text to encrypt => \(start)")
        
        let cryptor = RSACryptor(keySize: 1024)
        
        guard let
            data = start.dataUsingEncoding(NSUTF8StringEncoding),
            rsaKeys = cryptor.generateKeyPair(),
            encryptedData = cryptor.encryptData(data, key: rsaKeys.publicKey),
            decryptedData = cryptor.decryptData(encryptedData, key: rsaKeys.privateKey),
            decryptedText = String(data: decryptedData, encoding: NSUTF8StringEncoding)
        else {
            print("error")
            return true
        }
        
        
        print("data to encrypt => \(data)")
        print("encrypted data => \(encryptedData)")
        print("decrypted text => \(decryptedText)")
        
        return true
    }
}

