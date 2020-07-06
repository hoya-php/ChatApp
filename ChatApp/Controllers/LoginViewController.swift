//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 伊藤和也 on 2020/07/06.
//  Copyright © 2020 kazuya ito. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let lottieAnimation = LottieAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Login(_ sender: Any) {
        
        //LodingAnimation
        view.addSubview(lottieAnimation.lodingAnimation(viewWidth: view.frame.size.width,
                                                        viewHeight: view.frame.size.height))
        
        
        //Firebase Login => signIn
        Auth.auth().signIn(withEmail: emailTextField.text!,
                           password: passwordTextField.text!) {
                                (user, error) in
                                
                                if error != nil {
                                    
                                    print(error as Any)
                    
                                } else {
                                    
                                    print("ログイン完了")
                                    
                                    //animation stop
                                    self.lottieAnimation.stopAnimation()
                                    
                                    //goto chat view modaly
                                    self.performSegue(withIdentifier: "chat", sender: nil)
                                    
                                }
                                
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
