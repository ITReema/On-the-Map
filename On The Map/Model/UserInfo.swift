//
//  UserInfo.swift
//  On The Map
//
//  Created by mac_os on 11/05/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import Foundation
struct UserInfo {
    
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(dictionary: [String : AnyObject]) {
        id = dictionary["id"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
    }
}
