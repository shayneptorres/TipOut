//
//  UserDefaultsManager.swift
//  TipOut
//
//  Created by Shayne Torres on 8/16/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    enum UserDefault: String {
        case activePresetID = "activePresetID"
    }
    
    static func set(_ userDefault: UserDefault, value: Any?) {
        UserDefaults.standard.set(value, forKey: userDefault.rawValue)
    }
    
    static func get(_ userDefault: UserDefault) -> Any? {
        return UserDefaults.standard.value(forKey: userDefault.rawValue)
    }
}
