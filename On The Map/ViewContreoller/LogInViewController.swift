//
//  LogInViewController.swift
//  On The Map
//
//  Created by mac_os on 04/05/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var singUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if (email!.isEmpty) || (password!.isEmpty) {
            let alert = UIAlertController (title: "Error", message: "Email and Password cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present (alert, animated: true, completion: nil)
            
        } else {
            API.login(email, password){(success, key, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        let alert = UIAlertController(title: "Erorr", message: "Failed Request", preferredStyle: .alert )
                        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    if !success {
                        let alert = UIAlertController(title: "Erorr", message: "Password or Email uncorrect", preferredStyle: .alert )
                        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("Success Request")
                        if let mapAndTableController = self.storyboard?.instantiateViewController(withIdentifier: "MapAndTableController") {
                            self.present(mapAndTableController, animated: true, completion: nil)}
                    }
                }
            }
        }
    }
    
    @IBAction func singUp(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url, options: [:])}
    }
    
}
