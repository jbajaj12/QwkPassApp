//
//  RegisterViewController.swift
//  QwkPassApp
//
//  Created by Jay Bajaj on 9/15/17.
//  Copyright © 2017 Jay Bajaj. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

//    //Button
//    @IBAction func nextbutton(_ sender: Any) {
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var Email_Registration: UITextField!
    @IBOutlet weak var Username_Registration: UITextField!
    @IBOutlet weak var Password_Registration: UITextField!
    @IBOutlet weak var Confpass_Registration: UITextField!
    
    var authverified = false
    
    @IBAction func NextButton(_ sender: Any) {
        if Email_Registration.text != "" && Password_Registration.text != "" && Confpass_Registration.text != ""{
            authverified = true
            shouldPerformSegue(withIdentifier: "Reg_to_Reg_with_Billing", sender: self)
        }
        else {
            self.showToast(message: "Error please fill in all fields")
            authverified = false
        }
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Reg_to_Reg_with_Billing" {
            if authverified == false {
                return false
            }
            else{
                print("Next Segue will occur")
                performSegue(withIdentifier: "Reg_to_Reg_with_Billing", sender: self)
            }
        }
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if segue.identifier == "Reg_to_Reg_with_Billing"{
                let secondcontroller = segue.destination as! RBVC
                secondcontroller.emailPassed = Email_Registration.text!
                secondcontroller.passwordPassed = Password_Registration.text!
                secondcontroller.confpassPassed = Confpass_Registration.text!
                secondcontroller.usernamePassed = Username_Registration.text!
            }
        
            else if segue.identifier == "Cancel_go_back_to_login"{
                
            }
    }
    
    //code needs to change below
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/80, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 10, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Nunito", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }


}
