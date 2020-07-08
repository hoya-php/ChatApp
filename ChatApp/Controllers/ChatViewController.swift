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

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!

    @IBOutlet weak var sendButton: UIButton!
    
    let screenSize = UIScreen.main.bounds.size
    
    var chatArray = [Message()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?
        
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil),
                           forCellReuseIdentifier: "Cell")

        //セル高さを可変にするメソッド
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 44
        
        //テーブルビューレイアウト　セルのハイライトを消す
        tableView.separatorStyle = .none
        
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
        fetchChatData()
        
    }
    
    // キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
        }
    }
    
    //// キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    //関係ないところをタップすると戻す。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.messageTextField.isFirstResponder == true {
            self.messageTextField.resignFirstResponder()
        }
    }
    
    //キーボードでリターン押されると戻す。
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //send button method
    @IBAction func sendAction(_ sender: Any) {
        //TextFieldの編集を終わらせる。
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        //Message Count send faild
        if messageTextField.text!.count > 15 { return }
        
        let chatDB = Database.database().reference().child("chats")
        
        //キーバリュー型にて内容を送信（辞書型 Dictionary）
        let messageInfo = ["sender": Auth.auth().currentUser?.email,
                           "message": messageTextField.text!]
        
        //chatDBに保存
        chatDB.childByAutoId().setValue(messageInfo) {
            (error, result) in
              
            if error != nil {
                print(error!)
            } else {
                
                print("send complete")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
                
            }
            
        }
        
    }
    
    //Database fetch method
    func fetchChatData() {
        //どこからデータを引っ張るか
        let fetchDataRef = Database.database().reference().child("chats")
        
        //新しく更新があったときだけ取得したい
        fetchDataRef.observe(.childAdded) {
            (snapShot) in
            
            let snapShotData = snapShot.value as AnyObject
            let sender = snapShotData.value(forKey: "sender")
            let text = snapShotData.value(forKey: "message")

            var message = Message()
            message.sender = sender as! String
            message.message = text as! String
            self.chatArray.append(message)
            self.tableView.reloadData()
            
        }
    }
    
    //TableView Config
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Message Count (Int)
        return chatArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        cell.userName.text = chatArray[indexPath.row].sender
        cell.messageLabel.text = chatArray[indexPath.row].message
        cell.iconImageView.image = UIImage(named: "dogAvatarImage")
        
        if cell.userName.text == Auth.auth().currentUser?.email! {
        
            cell.messageLabel.backgroundColor = UIColor.flatGreen()
            cell.messageLabel.layer.cornerRadius = 10.0
            cell.messageLabel.layer.masksToBounds = true
            
        } else {
            
            cell.messageLabel.backgroundColor = UIColor.flatBlue()
            cell.messageLabel.layer.cornerRadius = 10.0
            cell.messageLabel.layer.masksToBounds = true
            
        }
        
        return cell
        
    }
    

}
