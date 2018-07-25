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
    private var provider: FriendsListProviderProtocol?
    // идентификатор повторного использования ячеек (ячейки, которые прокручиваются вне поля зрения, могут быть повторно использованы)
    private let cellReuseIdentifier = "cell"
    private var bioFriends = [Person]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bioFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // создаем новую ячейку при необходимости или повторно используем старую
        let cell: UITableViewCell = (self.friendsList.dequeueReusableCell(withIdentifier: cellReuseIdentifier))!
        cell.textLabel?.text = "\(bioFriends[indexPath.row].Name) \(bioFriends[indexPath.row].Surname)"
        return cell
    }
    
    override func viewDidLoad() {
        provider = VKProvider()
        provider?.getFriendsList(treatmentFriends: { (friends) in
            self.bioFriends = friends
            self.friendsList.reloadData()
        })
        // Зарегистрируем класс ячейки представления таблицы и его идентификатор повторного использования
        friendsList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        friendsList.delegate = self
        friendsList.dataSource = self
    }
}
