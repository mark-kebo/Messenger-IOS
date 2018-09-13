//
//  PreliminaryMessage.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 8/24/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import Foundation

struct PreliminaryMessage {
    var person: Person
    var lastMessage: String
    var lastDateMessage: NSNumber
    var id: NSNumber?
    var unreadCount: NSNumber?
    var isSentRead: Bool?
}
