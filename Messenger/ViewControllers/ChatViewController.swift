//
//  ChatViewController.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 9/12/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    var chatId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.separatorStyle = .none
        navigationItem.title = chatId
    }

}
