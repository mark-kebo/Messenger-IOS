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
    private var session: SessionProtocol?
    private var images = [UIImage]()
//    private var images: Dictionary<NSURL, UIImage>?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bioFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // создаем новую ячейку при необходимости или повторно используем старую
        let cell: UITableViewCell = (self.friendsList.dequeueReusableCell(withIdentifier: cellReuseIdentifier))!
        cell.textLabel?.text = "\(bioFriends[indexPath.row].name) \(bioFriends[indexPath.row].surname)"
        cell.imageView?.image = images[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        provider = VKProvider()
        session = DownloadSession()
        
        //захват self
        provider?.getFriendsList(treatmentFriends: { [weak self] (friends) in
            self?.bioFriends = friends
            self?.startDownloadImage()
        })
        // Зарегистрируем класс ячейки представления таблицы и его идентификатор повторного использования
        friendsList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        friendsList.delegate = self
        friendsList.dataSource = self
    }
    
    private func startDownloadImage() {
        var urlFriendsImage = [URL]()
        bioFriends.forEach() {
            urlFriendsImage.append($0.avaImgUrl)
        }
        session?.downloadImage(url: urlFriendsImage, setImage: { [weak self] (imageFromUrl) in
            self?.images.append(imageFromUrl)
            DispatchQueue.main.async { () -> Void in
                self?.friendsList.reloadData()
            }
        })
    }
}


