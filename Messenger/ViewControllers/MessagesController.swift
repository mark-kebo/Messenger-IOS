//
//  SecondTab.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 18.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class MessagesController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private var provider: MessagesProviderProtocol?
    @IBOutlet weak var messagesList: UITableView!
    @IBOutlet weak var searchChat: UISearchBar!
    private let cellReuseIdentifier = "messagesCell"
    private var messages = [PreliminaryMessage]()
    private var filteredMessages = [PreliminaryMessage]()
    private var refreshControl:UIRefreshControl!
    private var downloadImageProcess: DownloaderImageProtocol?
    private var currentId: String?
    private var currentName: String?
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider = VKProvider()
        downloadImageProcess = DownloaderImage()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        messagesList.addSubview(refreshControl)
        messagesList.separatorStyle = .none
        
        messagesList.delegate = self
        messagesList.dataSource = self
        searchChat.delegate = self
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.registerData()
        refreshControl.endRefreshing()
    }
    
    private func registerData() {
        provider?.getMessagesList(treatmentMessages: { [weak self] (messages) in
            self?.messages = messages
            self?.filteredMessages = messages
            self?.messagesList.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let raw = filteredMessages[indexPath.row]
        let cell:MessagesListTableViewCell = self.messagesList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MessagesListTableViewCell
        cell.setName(name: "\(raw.person.name!) \(raw.person.surname!)")
        downloadImageProcess?.downloadImage(session: session, imagePath: raw.person.avaImgUrl!,
                                            name: "\(raw.person.name!)\(raw.person.surname!)") { [weak self] (image) in
                                                cell.setAvatar(image: image)
                                                cell.setDate(date: (self?.filteredMessages[indexPath.row].lastDateMessage)!)
                                                cell.setTextLastMessage(text: (self?.filteredMessages[indexPath.row].lastMessage)!,
                                                                        isRead: (self?.filteredMessages[indexPath.row].isSentRead)!)
                                                cell.setCountUnreadMessages(count: (self?.filteredMessages[indexPath.row].unreadCount)!)
                                                cell.prepareForReuse()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //go to messages
        self.currentId = self.filteredMessages[indexPath.row].id?.stringValue
        self.currentName = "\(self.filteredMessages[indexPath.row].person.name!) \(self.filteredMessages[indexPath.row].person.surname!)"
        self.performSegue(withIdentifier: "showChatFromMessagesList", sender: nil)
    }
    
    //Swipe to delete and send messages
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexPath) in
            let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                self?.provider?.deleteChat(byId: (self?.filteredMessages[indexPath.row].id)!)
                self?.registerData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in }))
            self?.present(alert, animated: true, completion: nil)
        }
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChatViewController
        destinationVC.chatId = currentId!
        destinationVC.chatName = currentName!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMessages = searchText.isEmpty ? messages : messages.filter { (item: PreliminaryMessage) -> Bool in
            return "\(item.person.name!) \(item.person.surname!)".range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        messagesList.reloadData()
    }
    
}
