//
//  Data.swift
//  On The Map
//
//  Created by mac_os on 04/05/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import Foundation
class Data {
    static let shared = Data()
    var usersData = [Any?]()
    private init() { }
}
