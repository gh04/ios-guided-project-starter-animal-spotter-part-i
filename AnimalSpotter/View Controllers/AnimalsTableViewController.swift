//
//  AnimalsTableViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var animalNames: [String] = []
//creating a new model controller AT launch. Use for all API request. that API controller will be able to tell whether we need to log in or not.
    
    //bearer
    let apiController = APIController()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //we want the transition to be visible to the user. Not viewWillAppear
    //giving context to where they were and where they went. 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //if there is no bearer object segue to the login mode.
        if apiController.bearer == nil {
            //triggering the segue in code. (like in storyboard.) Segue to the login mode.
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = animalNames[indexPath.row]

        return cell
    }

    // MARK: - Actions
    
    @IBAction func getAnimals(_ sender: UIBarButtonItem) {
        // fetch all animals from API
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            // inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                //injecting apiController we made in this class into loginVC apiController property so they are the same thing.
                //Important design pattern to deal with different objects in code.. Commonly asked in interviews. 
                loginVC.apiController = apiController
            }
            
            //APIController. Forwarding from table view controller to the login view controller to make sure it is the same  APIController and thus the same bearer token. One of the dependencies . We are doing dependency injection .
        }
    }
}
