//
//  ChatViewController.swift
//  ChatApp
//
//  Created by 伊藤和也 on 2020/07/06.
//  Copyright © 2020 kazuya ito. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!

    let screenSize = UIScreen.main.bounds.size
    
    var chatArray = [Message()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil),
                           forCellReuseIdentifier: "Cell")

        //セル高さを可変にするメソッド
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 44
        
        //キーボード出現メソッド
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ChatViewController.keyboardWillShow(_ :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        //キーボード戻すメソッド
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ChatViewController.keyboardWillHide(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    
        //Firebaseからデータをfetchしてくる（チャットログ取得）
        
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height
        
        messageTextField.frame.origin.y = screenSize.height - keyboardHeight - messageTextField.frame.height
        
    }
    
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        messageTextField.frame.origin.y = screenSize.height - messageTextField.frame.height
        
        guard let _ = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        UIView.animate(withDuration: duration) {
            
            let transform = CGAffineTransform(translationX: 0,
                                              y: 0)
            self.view.transform = transform
            
        }
        
    }
    
    //send button method
    @IBAction func sendButton(_ sender: Any) {
    }
    
    
    
    //TableView Config
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Message Count (Int)
        return chatArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        cell.messageLabel.text = chatArray[indexPath.row].message
        cell.userName.text = chatArray[indexPath.row].message
        cell.iconImageView.image = UIImage(named: "dogAvatarImage")
        
        if cell.userName.text == Auth.auth().currentUser?.email! {
        
            cell.messageLabel.backgroundColor = UIColor.flatGreen()
            
        } else {
            
            cell.messageLabel.backgroundColor = UIColor.flatBlue()
            
        }
        
        return cell
        
    }
    

}

//キーボード操作プロトコルパターン
extension ChatViewController: UITextFieldDelegate {
    
    //関係ないところをタップすると戻す。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        messageTextField.resignFirstResponder()
    }
    
    //キーボードでリターン押されると戻す。
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
