//
//  AlamofireRequestManager.swift
//  Fitbudd Assignment
//
//  Created by Shubham Arora on 04/06/21.
//

import Foundation
import Alamofire

final class AlamoRequestManager: RequestGeneratorProtocol {
    
    static let shared = AlamoRequestManager()
    private init() {}
    
    func requestDataFor(_ strURL: URLConvertible, methodType: HTTPMethod, params: [String: Any]?,
                        onSuccess:@escaping ([String: Any]?) -> Void,
                        onError:@escaping (Error?, [String: Any]?) -> Void ) {
        var encode: ParameterEncoding = JSONEncoding.default
        if methodType == .get {
            encode = URLEncoding.default
        }
        let headerDict = headerParams
        AF.request(strURL, method: methodType, parameters: params, encoding: encode, headers: headerDict).responseJSON {(response) in
            
            switch response.result {
            case .success:
                
                if let httpResponse = response.response {
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                        if let responseData = response.value as? [String: Any] {
                            onSuccess(responseData)
                        }
                    } else {
                        if let responseData = response.value as? [String: Any] {
                            onError(nil, responseData)
                        }
                    }
                }
                
            case .failure(let error):
                
                if let errorResponse = response.value as? [String: Any] {
                    onError(nil, errorResponse)
                } else {
                    onError(error, nil)
                }
            }
        }
    }
}
