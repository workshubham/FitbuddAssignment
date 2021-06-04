//
//  MealViewModel.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 10/05/21.
//

import Foundation

struct ImagesViewModel {
    
    let id: String
    let pageURL: String
    let type: String
    let tags: String
    let userImageURL: String
    let user: String
    
    init(data: ImagesModel) {
        
        id = data.id
        pageURL = data.pageURL
        type = data.type
        tags = data.tags
        userImageURL = data.userImageURL
        user = data.user
    }
}
