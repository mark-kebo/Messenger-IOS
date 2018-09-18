//
//  PrivateChatProviderProtocol.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 9/14/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import Foundation

protocol PrivateChatProviderProtocol {
    func get(chatMessagesListBy id: String, with treatmentMessages: @escaping ([PrivateMessage]) -> Void)
    func send(message: String, byUserId id: String)
    func get(longPollServerWith callBack: @escaping () -> Void)
    func registration(longPollWith callBack: @escaping () -> Void)
    func markAsRead(messagesBy id: String)
    func delete(messageBy id: NSNumber)
}
