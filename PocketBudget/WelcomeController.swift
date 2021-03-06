//
//  WelcomeController.swift
//  PocketBudget
//
//  Created by Andrew Webber on 10/8/17.
//  Copyright © 2017 Andrew Webber. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class WelcomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func googleSignOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
            dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: Constants.Segues.GoogleSignOut, sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
       // self.performSegue(withIdentifier: Constants.Segues.GoogleSignOut, sender: nil)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
