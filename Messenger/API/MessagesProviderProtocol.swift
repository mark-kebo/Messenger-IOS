//
//  MessagesProviderProtocol.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 9/4/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import Foundation

protocol MessagesProviderProtocol {
    func get(messagesListWith treatmentMessages: @escaping ([PreliminaryMessage]) -> Void)
    func delete(chatBy id: NSNumber)
    func get(longPollServerWith callBack: @escaping () -> Void)
    func registration(longPollWith callBack: @escaping () -> Void)
}
