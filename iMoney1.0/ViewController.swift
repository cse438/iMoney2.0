//
//  ViewController.swift
//  iMoney1.0
//
//  Created by 文静 on 18/11/2016.
//  Copyright © 2016 文静. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "signIn", sender: nil)
        }
        ref = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        print("start to sign in")
        self.outputLabel.text = "successful signed in"
        guard let email = self.emailField.text, let password = self.passwordField.text else {
            return
        }
        
        // Sign user in
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            guard let user = user, error == nil else {
                self.outputLabel.text = "successful signed in"
                return
            }
            
            self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Check if user already exists
                guard !snapshot.exists() else {
//                    self.performSegue(withIdentifier: "signIn", sender: nil)
                    return
                }
                
            }) // End of observeSingleEvent
            
        }) // End of signIn
    }
    
}

