//
//  PrivateMessagesTableViewCell.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 9/14/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import UIKit

class PrivateMessagesListTableViewCell: UITableViewCell {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var bubbleMessage: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var leadingConstraintBubble: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintBubble: NSLayoutConstraint!
    private let colorBackgroundMine = UIColor(red:0.88, green:0.95, blue:0.98, alpha:1.0)
    private let colorBackgroundDontMine = UIColor(red:0.93, green:0.93, blue:0.95, alpha:1.0)

    
    public func set(textMessage text: String, isMine: Bool, isRead: Bool, attachments: [AttachmentMessage]?) {
        self.message.text = text
        self.prepareUI(isMine: isMine, isRead: isRead)
        attachments?.forEach() {
            let attributedString = NSMutableAttributedString()
            let imgAttachment = NSTextAttachment()
            imgAttachment.image = $0.img
            imgAttachment.bounds.size = $0.img!.size
            attributedString.append(NSAttributedString(attachment: imgAttachment))
            self.message.attributedText = attributedString
        }
    }
    
    private func prepareUI(isMine: Bool, isRead: Bool) {
        bubbleMessage.layer.cornerRadius = 20
        if !isMine {
            leadingConstraintBubble.priority = UILayoutPriority(rawValue: 999.0);
            trailingConstraintBubble.priority = UILayoutPriority(rawValue: 10.0);
            message.textAlignment = .left
            dateLabel.textAlignment = .left
            bubbleMessage.backgroundColor = colorBackgroundDontMine
            backgroundColor = nil
        } else {
            leadingConstraintBubble.priority = UILayoutPriority(rawValue: 10.0);
            trailingConstraintBubble.priority = UILayoutPriority(rawValue: 999.0);
            message.textAlignment = .right
            dateLabel.textAlignment = .right
            bubbleMessage.backgroundColor = colorBackgroundMine
            isRead ? (backgroundColor = nil) : (backgroundColor = colorBackgroundMine)
        }
    }
    
    public func set(date: NSNumber, isMine: Bool) {
        let date = Date(timeIntervalSince1970: date as! Double)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm\ndd.MM.yy"
        let strDate = dateFormatter.string(from: date)
        self.dateLabel?.text = strDate
    }
}
