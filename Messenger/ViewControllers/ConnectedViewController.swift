//
//  ConnectedViewController.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 18.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class ConnectedViewController: UITabBarController {
    var tabFriendsList: FriendsListController?
    var tabMessagesList: MessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabFriendsList = FriendsListController(nibName: "FriendsList", bundle: nil)
        self.tabMessagesList = MessagesController(nibName: "MessagesList", bundle: nil)
        
        self.viewControllers = [tabFriendsList!, tabMessagesList!]
        let itemFriendsList = UITabBarItem(title: "Friends", image: nil, tag: 0)
        let itemSecond = UITabBarItem(title: "Messages", image: nil, tag: 1)
        
        tabFriendsList?.tabBarItem = itemFriendsList
        tabMessagesList?.tabBarItem = itemSecond
    }
}
