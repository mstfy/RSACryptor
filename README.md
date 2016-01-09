# RSACryptor
RSA encryption and decryption class written in Swift 2

## What It Is
This is the wrapper for Security framework written in Swift 2. It can do three things:
* It can generate public/private RSA keys
* It can encrypt NSData with public key
* It can decrypt NSData with private key


## Sample Usage

    let text = "Hello World"
    print("text to encrypt => \(text)")
        
    let cryptor = RSACryptor(keySize: 1024)
        
    guard let
      data = text.dataUsingEncoding(NSUTF8StringEncoding),
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
    
**Note** : The `keySize` parameter is important. If you choose 1024 as `keySize` then you can encrypt max 1024 bit data. 
That means `data.length <= 128`. Otherwise the encryption will be failed.

## Licence
There is no licence. You can use it anyway you want.
