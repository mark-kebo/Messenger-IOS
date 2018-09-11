//
//  MessagesListTableViewCell.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 9/11/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class MessagesListTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var countUnreadMessages: UILabel!
    
    public func setAvatar(image: UIImage) {
        avatar?.image = image
        avatar?.layer.masksToBounds = false
        avatar?.layer.cornerRadius = avatar.layer.frame.height / 2
        avatar?.clipsToBounds = true
    }
    
    public func setName(name: String) {
        self.name?.text = name
    }
    
    public func setTextLastMessage(text: String) {
        self.lastMessage?.text = text
    }
    
    public func setDate(date: NSNumber) {
        let date = Date(timeIntervalSince1970: date as! Double)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd.MM"  //yyyy-MM-dd HH:mm
        let strDate = dateFormatter.string(from: date)
        self.date?.text = strDate
    }
    
    public func setCountUnreadMessages(count: NSNumber) {
        if count != 0 {
            countUnreadMessages.isHidden = false
            countUnreadMessages?.text = count.stringValue
            self.backgroundColor = UIColor(red:0.88, green:0.95, blue:0.98, alpha:1.0)
        } else {
            countUnreadMessages.isHidden = true
            self.backgroundColor = nil
        }
    }
}
