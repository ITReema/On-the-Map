//
//  TableViewController.swift
//  On The Map
//
//  Created by mac_os on 04/05/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var Table: UITableView!
    
    var dataUser = Data.shared.usersData
    
    var locations: [StudentLocation] = [] {
        didSet {
            Table.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUsers()
    }
    
    func getUsers(){
        Parse.sharedInstance().getStudentLocations(){(locations, success, error)in
            if success {
                guard let userLocation = locations else {return}
                self.dataUser = userLocation as [StudentLocation]
                DispatchQueue.main.async {
                    self.Table.reloadData()}
            }else{
                let alert = UIAlertController(title: "Erorr", message: "Failed Request", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                }))
                self.present(alert, animated: true, completion: nil)
                return}
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataUser.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableView") as! TableViewCell
        let data = self.dataUser[indexPath.row] as! StudentLocation
        
        cell.icon?.image = UIImage(named: "icon_pin")
        let fullName = "\(data.firstName ?? "first name") \(data.lastName ?? "last name")"
        cell.nameLabel.text = fullName
        let mediaUrl = data.mediaURL
        cell.urlLabel.text = mediaUrl
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.dataUser[indexPath.row] as! StudentLocation
        if let url =  URL(string: data.mediaURL!){
            UIApplication.shared.open(url, options: [:])
        }else{
            let alert = UIAlertController(title: "Erorr", message: "Failed open URL", preferredStyle: .alert )
            alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        API.logout() { (success) in
            DispatchQueue.main.async {
                if success {
                    self.tabBarController?.dismiss(animated: true, completion: nil)
                    
                }else {
                    let alert = UIAlertController(title: "Erorr", message: "Error in Logout", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return}
            }
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        getUsers()
    }
    
    @IBAction func addButton(_ sender: Any) {
        if let addLocationController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocation") {
            self.present(addLocationController, animated: true, completion: nil)}
    }
    
}
