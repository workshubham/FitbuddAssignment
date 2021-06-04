//
//  MealModel.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 10/05/21.
//

import Foundation

struct ImageResponseModel {
    
    let totalItems: Int
    var images: [ImagesModel] = [ImagesModel]()
    
    init?(data: [String: Any]) {
        
        totalItems = data["total"] as? Int ?? -1
        if let imagesData = data["hits"] as? [[String: Any]] {
            for image in imagesData {
                images.append(ImagesModel(data: image))
            }
        }
    }
}

struct ImagesModel {
    
    let id: String
    let pageURL: String
    let type: String
    let tags: String
    let userImageURL: String
    let user: String
    
    init(data: [String: Any]) {
        
        id = data["id"] as? String ?? ""
        pageURL = data["pageURL"] as? String ?? ""
        type = data["type"] as? String ?? ""
        tags = data["tags"] as? String ?? ""
        userImageURL = data["largeImageURL"] as? String ?? ""
        user = data["user"] as? String ?? ""
    }
}

class Slide: NSObject {
    
    public var name: String!
    public var image: String!

    public var imageURL: URL!{
        get{
            if let url: URL = URL(string: image) {
                return url
            }else{
                return nil
            }
        }
    }

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
