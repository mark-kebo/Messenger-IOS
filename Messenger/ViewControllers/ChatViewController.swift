//
//  ChatViewController.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 9/12/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var buttomView: UIView!
    public var chatId: String?
    public var chatName: String?
    private var provider: PrivateChatProviderProtocol?
    private var messages = [PrivateMessage]()
    private let cellReuseIdentifier = "privateMessagesCell"
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1);
        provider = VKProvider()
        chatTableView.separatorStyle = .none
        navigationItem.title = chatName
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerData()
    }
    
    private func registerData() {
        provider?.getChatMessagesList(byId: chatId!, treatmentMessages: { [weak self] (messages) in
            self?.messages = messages
            self?.chatTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let raw = messages[indexPath.row]
        let cell:PrivateMessagesListTableViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PrivateMessagesListTableViewCell
        cell.transform = CGAffineTransform(scaleX: 1, y: -1);
        cell.setTextMessage(text: raw.message, isMine: raw.isMine)
        cell.setDate(date: raw.date, isMine: raw.isMine)
        cell.prepareForReuse()
        return cell
    }

    @IBAction func sendMessage(_ sender: Any) {
        textField.resignFirstResponder()
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        contentScrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc func kbWillHide() {
        contentScrollView.contentOffset = CGPoint.zero
    }
}
