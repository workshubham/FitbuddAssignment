//
//  SearchWebService.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 11/05/21.
//

import Foundation

class SearchWebService {
    
    static let shared = SearchWebService()
    private init() {}
    
    internal func searchImages(url: URL, onCompletion: @escaping (ImageResponseModel?, String?, Error?) -> Void) {
        print("URL -\(url)")
        AlamoRequestManager.shared.requestDataFor(url, methodType: .get, params: nil) { response in
            
            DispatchQueue.global(qos: .background).async {
                if let response = response {
                    guard let data = ImageResponseModel(data: response) else { return }
                    DispatchQueue.main.async {
                        onCompletion(data, nil, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        onCompletion(nil, nil, nil)
                    }
                }
            }
            
        } onError: { error, errorResponse in
            
            if error == nil {
                onCompletion(nil, nil, error)
            } else {
                onCompletion(nil, nil, nil)
            }
        }
    }
}
