//
//  UserDefaultsManager.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/12/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case autoPlay
    case color
    case numberOfExecutions
}

class UserDefaultsManager {
    static var defaults = UserDefaults.standard
    
    class func updateNumberOfExecutions() {
        let key = UserDefaultsKeys.numberOfExecutions.rawValue
        defaults.set(defaults.integer(forKey: key) + 1, forKey: key)
        defaults.synchronize()
    }
    
    class func numberOfExecutions() -> Int {
        return defaults.integer(forKey: UserDefaultsKeys.numberOfExecutions.rawValue)
    }
    
    class func setColor(to colorNumber: Int) {
        defaults.set(colorNumber, forKey: UserDefaultsKeys.color.rawValue)
        defaults.synchronize()
    }
    
    class func colorNumber() -> Int {
        return defaults.integer(forKey: UserDefaultsKeys.color.rawValue)
    }
    
    class func setAutoPlay(to isOn: Bool) {
        defaults.set(isOn, forKey: UserDefaultsKeys.autoPlay.rawValue)
        defaults.synchronize()
    }
    
    class func autoPlay() -> Bool {
        return defaults.bool(forKey: UserDefaultsKeys.autoPlay.rawValue)
    }
    
    class func synchronize() {
        defaults.synchronize()
    }
}
