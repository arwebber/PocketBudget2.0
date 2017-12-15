//
//  AppRegisterController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 10/8/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import Firebase

class AppRegisterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordCheck: UITextField!
    @IBOutlet weak var btnRegister: UIButton!

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
    }
    
    @IBAction func btnRegister_TouchUpInside(_ sender: Any) {
        
        if let email = txtEmail.text, let password = txtPassword.text{//, let name = txtName.text{
            
            var alertController = UIAlertController(title: "Registration Failed", message: (""), preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Okay" , style: UIAlertActionStyle.default){
                (result : UIAlertAction) -> Void in
                print("Okay")
            }
            
            if (txtFirstName.text == ""){
                alertController = UIAlertController(title: "Registration Failed", message: ("Please enter your frist name."), preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(okAction)
                self.present(alertController, animated:true, completion: nil)
            }else if (txtLastName.text == ""){
                alertController = UIAlertController(title: "Registration Failed", message: ("Please enter your last name."), preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(okAction)
                self.present(alertController, animated:true, completion: nil)
            }else if (txtEmail.text == ""){
                alertController = UIAlertController(title: "Registration Failed", message: ("Please enter your email."), preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(okAction)
                self.present(alertController, animated:true, completion: nil)
            }else if (txtPassword.text == ""){
                alertController = UIAlertController(title: "Registration Failed", message: ("Please enter a password."), preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(okAction)
                self.present(alertController, animated:true, completion: nil)
            }else if (txtPasswordCheck.text == ""){
                alertController = UIAlertController(title: "Registration Failed", message: ("Please confirm your password."), preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(okAction)
                self.present(alertController, animated:true, completion: nil)
            }
            
            if(txtFirstName.text != "" && txtLastName.text != "" && txtEmail.text != "" && txtPassword.text != "" && txtPasswordCheck.text != ""){
                if(txtPassword.text == txtPasswordCheck.text){
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if(user != nil){
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab")
                            self.present(vc!, animated: true, completion: nil)
                        }else{
                            alertController = UIAlertController(title: "Registration Failed", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(okAction)
                            self.present(alertController, animated:true, completion: nil)
                        }
                    }
                }else{
                    alertController = UIAlertController(title: "Registration Failed", message: ("Your passwords don't seem to match."), preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(okAction)
                    self.present(alertController, animated:true, completion: nil)
                }
            }
            
        }
    }
 

}
