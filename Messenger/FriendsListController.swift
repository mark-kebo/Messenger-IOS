//
//  FirstTab.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 18.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var friendsList: UITableView!
    // идентификатор повторного использования ячеек (ячейки, которые прокручиваются вне поля зрения, могут быть повторно использованы)
    private let cellReuseIdentifier = "cell"
    private var provider: FriendsListProviderProtocol?
    private var bioFriends = [Person]()
    private var downloadImageProcess: DownloaderImageProtocol?
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bioFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // создаем новую ячейку при необходимости или повторно используем старую
        let cell: UITableViewCell = (self.friendsList.dequeueReusableCell(withIdentifier: cellReuseIdentifier))!
        cell.textLabel?.text = "\(bioFriends[indexPath.row].name) \(bioFriends[indexPath.row].surname)"
        downloadImageProcess?.downloadImage(session: session, imagePath: bioFriends[indexPath.row].avaImgUrl, name: "\(bioFriends[indexPath.row].name)\(bioFriends[indexPath.row].surname)") { (image) in
            if let updateCell = tableView.cellForRow(at: indexPath) {
                updateCell.imageView?.image = image
                updateCell.imageView?.layer.masksToBounds = false
                updateCell.imageView?.layer.cornerRadius = 13
                updateCell.imageView?.clipsToBounds = true
                //перезагрузка содержимого перед переиспользованием
                updateCell.prepareForReuse()
                print(indexPath.row)
            }
        }
        return cell
    }
    
    override func viewDidLoad() {
        provider = VKProvider()
        downloadImageProcess = DownloaderImage()
        
        //захват self
        provider?.getFriendsList(treatmentFriends: { [weak self] (friends) in
            self?.bioFriends = friends
            self?.friendsList.reloadData()
        })
        // Зарегистрируем класс ячейки представления таблицы и его идентификатор повторного использования
        friendsList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        friendsList.delegate = self
        friendsList.dataSource = self
    }
}
