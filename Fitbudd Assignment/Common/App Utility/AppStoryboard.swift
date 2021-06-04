//
//  AppStoryboard.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 10/05/21.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    
    case Main
    
    var instance: UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        
        let storyboardId = viewControllerClass.storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardId) as! T
        
    }
}

extension UIViewController {
    
    class var storyboardID: String {
        
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
