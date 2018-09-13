//
//  FirstTab.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 18.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak private var friendsList: UITableView!
    @IBOutlet weak private var searchFriends: UISearchBar!
    private let cellReuseIdentifier = "friendsCell"
    private var provider: FriendsListProviderProtocol?
    private var bioFriends = [Person]()
    private var downloadImageProcess: DownloaderImageProtocol?
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private var filteredData = [Person]()
    private var refreshControl: UIRefreshControl!
    private var currentId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider = VKProvider()
        downloadImageProcess = DownloaderImage()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        friendsList.addSubview(refreshControl)
        friendsList.allowsSelection = false;
        friendsList.separatorStyle = .none
        
        friendsList.delegate = self
        friendsList.dataSource = self
        searchFriends.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerData()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // создаем новую ячейку при необходимости или повторно используем старую
        let raw = filteredData[indexPath.row]
        let cell:FriendsListTableViewCell = self.friendsList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! FriendsListTableViewCell
        cell.setName(name: "\(raw.name!) \(raw.surname!)")
        downloadImageProcess?.downloadImage(session: session, imagePath: raw.avaImgUrl!,
                                            name: "\(raw.name!)\(raw.surname!)") { [weak self] (image) in
                                                cell.setAvatar(image: image)
                                                cell.setActivity(isOnline: (self?.filteredData[indexPath.row].isOnline)!)
                                                cell.prepareForReuse()
        }
        return cell
    }
    
    //Swipe to delete and send messages
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexPath) in
            let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                self?.provider?.deleteFriend(byId: (self?.filteredData[indexPath.row].id)!)
                self?.registerData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in }))
            self?.present(alert, animated: true, completion: nil)
        }
        let messages = UITableViewRowAction(style: .normal, title: "Messages") { [weak self] (_, indexPath) in
            //go to messages
            self?.currentId = self?.filteredData[indexPath.row].id?.stringValue
            self?.performSegue(withIdentifier: "showChatFromFriends", sender: nil)
        }
        return [delete, messages]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChatViewController
        destinationVC.chatId = currentId!
    }
    
    private func registerData() {
        //захват self
        provider?.getFriendsList(treatmentFriends: { [weak self] (friends) in
            self?.bioFriends = friends
            self?.filteredData = friends
            self?.friendsList.reloadData()
        })
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.registerData()
        refreshControl.endRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? bioFriends : bioFriends.filter { (item: Person) -> Bool in
            return "\(item.name!) \(item.surname!)".range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        friendsList.reloadData()
    }
}
