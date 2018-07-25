//
//  ConnectedViewController.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 18.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class ConnectedViewController: UITabBarController {
    var tabFriendsList : FriendsListController?
    var tabViewControllerSecond : SecondTab?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabFriendsList = FriendsListController(nibName: "FriendsList", bundle: nil)
        self.tabViewControllerSecond = SecondTab(nibName: "SecondTab", bundle: nil)
        
        self.viewControllers = [tabFriendsList!, tabViewControllerSecond!]
        let itemFriendsList = UITabBarItem(title: "Friends list", image: nil, tag: 0)
        let itemSecond = UITabBarItem(title: "2nd Tab", image: nil, tag: 1)
        
        tabFriendsList?.tabBarItem = itemFriendsList
        tabViewControllerSecond?.tabBarItem = itemSecond
    }
}
