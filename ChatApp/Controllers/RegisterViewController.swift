//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by 伊藤和也 on 2020/07/06.
//  Copyright © 2020 kazuya ito. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let lottieAnimation = LottieAnimation()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //Firebaseに新規ユーザーを追加する。
    @IBAction func registerNewUser(_ sender: Any) {
        
        //LodingAnimation
        view.addSubview(lottieAnimation.lodingAnimation(viewWidth: view.frame.size.width,
                                                        viewHeight: view.frame.size.height))
        
        //Firebase Reguster => createUser
        Auth.auth().createUser(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) {
                                (user, error) in
                                
                                if error != nil {
                                    
                                    print(error as Any)
                                    
                                    self.lottieAnimation.stopAnimation()
                    
                                } else {
                                    
                                    print("登録完了")
                                    
                                    //animation stop
                                    self.lottieAnimation.stopAnimation()
                                    
                                    //goto chat view modaly
                                    self.performSegue(withIdentifier: "chat", sender: nil)
                                    
                                }
                                
        }
        
    }
    
}
