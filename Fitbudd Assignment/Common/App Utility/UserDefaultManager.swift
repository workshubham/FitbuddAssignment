//
//  UserDefaultManager.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 11/05/21.
//

import Foundation

struct Key {
    
    static let favouriteMeals  = "favouriteMeal"
}

struct UserDefaultManager {
    
    static func saveFavouritesData(data: [String]) {
        userDefault.setValue(data, forKey: Key.favouriteMeals)
    }
    
    static func getFavouritesData() -> [String] {
        return userDefault.stringArray(forKey: Key.favouriteMeals) ?? []
    }
}
