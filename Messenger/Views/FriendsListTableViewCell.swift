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
    
    public func set(avatar image: UIImage) {
        avatar?.image = image
        avatar?.layer.masksToBounds = false
        avatar?.layer.cornerRadius = avatar.layer.frame.height / 2
        avatar?.clipsToBounds = true
    }
    
    public func set(name: String) {
        self.name?.text = name
    }
    
    public func set(activity isOnline: Bool) {
        if isOnline {
            activity.isHidden = false
            activity.clipsToBounds = true
            activity.layer.cornerRadius = activity.layer.frame.height / 2
        } else {
            activity.isHidden = true
        }
    }
}
