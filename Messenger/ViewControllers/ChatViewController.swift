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
    private var isKeyboardHide = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        provider = VKProvider()
        
        chatTableView.separatorStyle = .none
        navigationItem.title = chatName
        textField.clearButtonMode = .whileEditing
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        registerForKeyboardNotifications()
        startLongPoll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerData()
    }
    
    private func startLongPoll() {
        provider?.get(longPollServerWith: { [weak self] in
            self?.updateUI()
        })
    }
    
    private func updateUI() {
        provider?.registration(longPollWith: { [weak self] () in
            self?.registerData()
            self?.startLongPoll()
        })
    }
    
    private func registerData() {
        provider?.get(chatMessagesListBy: chatId!, with: { [weak self] (messages) in
            self?.messages = messages
            self?.provider?.markAsRead(messagesBy: self!.chatId!)
            self?.chatTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.resignFirstResponder()
        if isKeyboardHide {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Copy text to clipboard", style: .default, handler: { [weak self] action in
                UIPasteboard.general.string = self?.messages[indexPath.row].message
            }))
            if self.messages[indexPath.row].isMine {
                alert.addAction(UIAlertAction(title: "Delete message", style: .destructive, handler: { [weak self] action in
                    self?.provider?.delete(messageBy: (self?.messages[indexPath.row].id)!)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell:PrivateMessagesListTableViewCell = self.chatTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PrivateMessagesListTableViewCell
        cell.transform = CGAffineTransform(scaleX: 1, y: -1);
        cell.set(textMessage: message.message, isMine: message.isMine, isRead: message.isRead)
        cell.set(date: message.date, isMine: message.isMine)
        cell.selectionStyle = .none
        cell.prepareForReuse()
        if message.id == messages.last?.id {
            //new data
        }
        return cell
    }

    @IBAction func sendMessage(_ sender: Any) {
        provider?.send(message: textField.text!, byUserId: chatId!)
        textField.resignFirstResponder()
        textField.text = nil
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        contentScrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
        isKeyboardHide = false
    }
    
    @objc func kbWillHide() {
        contentScrollView.contentOffset = CGPoint.zero
    }
    
    @objc func kbDidHide() {
        isKeyboardHide = true
    }
}
