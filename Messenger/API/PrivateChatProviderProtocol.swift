//
//  PrivateChatProviderProtocol.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 9/14/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import Foundation

protocol PrivateChatProviderProtocol {
    func getChatMessagesList(byId: String, treatmentMessages: @escaping ([PrivateMessage]) -> Void)
    func send(message: String, userId: String)
    func getLongPollServer(callBack: @escaping () -> Void)
    func registrationLongPoll(callBack: @escaping () -> Void)
}
