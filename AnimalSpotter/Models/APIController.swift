//
//  APIController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIController {
    
    private let baseUrl = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    //Its presence or absence will be used inside the app to flag whether we are signed in or not. 
    var bearer: Bearer?
    
    // create function for sign up. Void and () mean the same.
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        //endpoint in API "users/signup". appending it to the base URL line 19
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        //API docs tells us the method is a post.
        request.httpMethod = HTTPMethod.post.rawValue
        //telling the API how the data is formated. telling the server the format is json. method and value
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //taking swift objects to json
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        //with URL Request and completion handler. press returned when highlighted blue to get trailing syntax
        //handling the response.
        //getting called in the background queue
        URLSession.shared.dataTask(with: request) { _, response, error in
           //checking status code from API set response value.
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                //making up this errror to return the error
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            }
            //if we get a 200 response but there is still an error
            if let error = error {
                completion(error)
                return
            }
        //if we get here. there is no error and it worked properly.
            completion(nil)
            //at the end of the closure. appending resume()
        }.resume()
    }
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        //endpoint in API "users/login". appending it to the base URL
        let signInURL = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: signInURL)
        //API docs tells us the method is a post.
        request.httpMethod = HTTPMethod.post.rawValue
        //telling the API how the data is formated. telling the server the format is json. method and value
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //taking swift objects to json
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        //with URL Request and completion handler. press returned when highlighted blue to get trailing syntax
        //handling the response.
        //getting called in the background queue
        //data is the payload of the response. we receive a json document contains three key value pairs (id, token, user id. - id and user id get thrown out). We only want to extract token.
        URLSession.shared.dataTask(with: request) { data, response, error in
           //checking status code from API set response value.
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                //making up this errror to return the error
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
            }
            //if we get a 200 response but there is still an error
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
            //blank error object. not the best but good enough for this.
                completion(NSError())
                return
            }
    
            //decoding the data
            let decoder = JSONDecoder()
            do {
                //decoding a Bearer object. Decode the token and store it in the Bearer object.
                //from the data from the json document key value pair. Token in this instance.
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
        //if we get here. there is no error and it worked properly we pass nothing.
            completion(nil)
            //at the end of the closure. appending resume()
        }.resume()
    }
    
    // create function for fetching all animal names
    
    // create function to fetch image
}
