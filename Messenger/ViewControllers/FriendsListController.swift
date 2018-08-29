//
//  FirstTab.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 18.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var friendsList: UITableView!
    @IBOutlet weak var searchFriends: UISearchBar!
    // идентификатор повторного использования ячеек (ячейки, которые прокручиваются вне поля зрения, могут быть повторно использованы)
    private let cellReuseIdentifier = "cell"
    private var provider: FriendsListProviderProtocol?
    private var bioFriends = [Person]()
    private var downloadImageProcess: DownloaderImageProtocol?
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private var filteredData = [Person]()
    private var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider = VKProvider()
        downloadImageProcess = DownloaderImage()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        friendsList.addSubview(refreshControl)
        
        // Зарегистрируем класс ячейки представления таблицы и его идентификатор повторного использования
        friendsList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        friendsList.delegate = self
        friendsList.dataSource = self
        searchFriends.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // создаем новую ячейку при необходимости или повторно используем старую
        let cell: UITableViewCell = (self.friendsList.dequeueReusableCell(withIdentifier: cellReuseIdentifier))!
        cell.textLabel?.text = "\(filteredData[indexPath.row].name) \(filteredData[indexPath.row].surname)"
        downloadImageProcess?.downloadImage(session: session, imagePath: filteredData[indexPath.row].avaImgUrl,
                                            name: "\(filteredData[indexPath.row].name)\(filteredData[indexPath.row].surname)") { [weak self] (image) in
            if let updateCell = tableView.cellForRow(at: indexPath) {
                updateCell.imageView?.image = image
                updateCell.imageView?.layer.masksToBounds = false
                updateCell.imageView?.layer.cornerRadius = 13
                updateCell.imageView?.clipsToBounds = true
                if (self?.filteredData[indexPath.row].isOnline)! {
                    updateCell.imageView?.layer.borderWidth = 4
                    updateCell.imageView?.layer.borderColor = UIColor(red: 60.0/255.0, green: 140.0/255.0, blue: 35.0/255.0, alpha: 0.6).cgColor
                    cell.textLabel?.textColor = UIColor(red: 60.0/255.0, green: 140.0/255.0, blue: 35.0/255.0, alpha: 0.9)
                } else {
                    updateCell.imageView?.layer.borderWidth = 0
                    cell.textLabel?.textColor = UIColor.black
                }
                updateCell.prepareForReuse()
            }
        }
        return cell
    }
    
    func registerData() {
        //захват self
        provider?.getFriendsList(treatmentFriends: { [weak self] (friends) in
            self?.bioFriends = friends
            self?.filteredData = friends
            self?.friendsList.reloadData()
        })
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.registerData()
        refreshControl.endRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? bioFriends : bioFriends.filter { (item: Person) -> Bool in
            return "\(item.name) \(item.surname)".range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        friendsList.reloadData()
    }
}
