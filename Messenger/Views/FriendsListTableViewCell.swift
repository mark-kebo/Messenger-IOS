//
//  FriendsListTableViewCell.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 8/30/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {
    @IBOutlet weak private var avatar: UIImageView!
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var activity: UILabel!
    
    public func setAvatar(image: UIImage) {
        avatar?.image = image
        avatar?.layer.masksToBounds = false
        avatar?.layer.cornerRadius = avatar.layer.frame.height / 2
        avatar?.clipsToBounds = true
    }
    
    public func setName(name: String) {
        self.name?.text = name
    }
    
    public func setActivity(isOnline: Bool) {
        let colorGreen = UIColor(red: 60.0/255.0, green: 140.0/255.0, blue: 35.0/255.0, alpha: 0.9)
        if isOnline {
            activity?.text = "Online"
            activity?.textColor = colorGreen
        } else {
            activity?.text = "Offline"
            activity?.textColor = UIColor.lightGray
        }
    }
}
