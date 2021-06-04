//
//  RequestGenerator.swift
//  Fitbudd Assignment
//
//  Created by Shubham Arora on 04/06/21.
//

import Foundation
import Alamofire

enum EndPoint {
    case searchImages(String, Int)
}

// MARK: EndPoint Extension
// Creating & Appending Endpoints to the URL
extension EndPoint {
    
    var endPoint: String {
        
        switch self {
        case .searchImages(let searchText, let pageNumber):
            return "&q=\(searchText)&image_type=photo&page=\(pageNumber)"
        }
    }
}

// MARK: Reguest Generator Protocol
// Header Param
protocol RequestGeneratorProtocol {
    
    var headerParams: HTTPHeaders {get}
}

extension RequestGeneratorProtocol {
    
    var headerParams: HTTPHeaders {
        
        get {
            
            var headerDictionary: HTTPHeaders = HTTPHeaders()
            headerDictionary = ["Content-Type": "application/json"]
            return headerDictionary
        }
    }
    
    // Get Complete Url
    func completeUrl(endpoint: EndPoint) -> String {
        
        let urlString = baseUrl + endpoint.endPoint
        return urlString
    }
}
