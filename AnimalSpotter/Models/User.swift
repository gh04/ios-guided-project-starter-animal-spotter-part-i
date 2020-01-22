//
//  User.swift
//  AnimalSpotter
//
//  Created by Gerardo Hernandez on 1/21/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

//from json to swift
struct User: Codable {
    let username: String
    let password: String
}
