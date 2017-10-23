//
//  Keychain.swift
//  AME
//
//  Created by Stephen Ulmer on 7/21/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import SwiftyJSON

class Keychain{
    
    class var username: String? {
        get{
            return KeychainWrapper.standard.string(forKey: "Username")
        }
        set{
            KeychainWrapper.standard.set(newValue!, forKey: "Username")
        }
    }
    
    class var password: String? {
        get{
            return KeychainWrapper.standard.string(forKey: "Password")
        }
        set{
            KeychainWrapper.standard.set(newValue!, forKey: "Password")
        }
    }
    
    class var token: JSON? {
        get{
            return JSON(KeychainWrapper.standard.string(forKey: "Token") ?? "")
        }
        set{
            KeychainWrapper.standard.set((newValue?.stringValue)!, forKey: "Token")
        }
    }
}
