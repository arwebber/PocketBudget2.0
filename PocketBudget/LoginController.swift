//
//  LoginController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 10/8/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginController: UIViewController, GIDSignInUIDelegate {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtUsername.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    @IBAction func btnLogin_TouchUpInside(_ sender: Any) {
        if let email = txtUsername.text, let password = txtPassword.text{
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if(user != nil){
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab")
                    self.present(vc!, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "Login Failed", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "Okay" , style: UIAlertActionStyle.default){
                        (result : UIAlertAction) -> Void in
                        print("Okay")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated:true, completion: nil)
                }
            }
        }
    }
    
    //@IBOutlet weak var google: GIDSignInButton!
   //@objc(LoginController)
    @IBOutlet weak var btnGoogleSignIn: GIDSignInButton!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //added from step 5 to automatically sign user in
        GIDSignIn.sharedInstance().signInSilently()
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil {
                MeasurementHelper.sendLoginEvent()

                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab")
                self.present(vc!, animated: true, completion: nil)

                //self.performSegue(withIdentifier: Constants.Segues.GoogleSignIn, sender: nil)
            }
        }
        
    }
    //step 5 for auto sign in
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
}
