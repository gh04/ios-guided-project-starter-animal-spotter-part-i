//
//  Bearer.swift
//  AnimalSpotter
//
//  Created by Gerardo Hernandez on 1/21/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
//what we will receive as an authenticated user. Passed to the server to authenticate user. Also flag inside the app to the status of authentication. 
struct Bearer: Codable {
    let token: String
}
