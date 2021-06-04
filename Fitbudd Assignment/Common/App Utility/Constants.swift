//
//  Constants.swift
//  Foody CookBook
//
//  Created by Shubham Arora on 10/05/21.
//

import Foundation
import UIKit

let baseUrl: String = "https://pixabay.com/api/?key=21926606-f8fc641364447e8fec429f26b"
// AppDelegate
let appDelegate = UIApplication.shared.delegate as! AppDelegate
// Font
enum Font: String{
    case Bold = "HelveticaNeue-bold"
    case Medium = "HelveticaNeue-Medium"
    case Regular = "HelveticaNeue"
    case Light = "HelveticaNeue-light"

    func of(size: CGFloat) -> UIFont {
      return UIFont(name: self.rawValue, size: size)!
    }
}
// User Default
public let userDefault = UserDefaults.standard
