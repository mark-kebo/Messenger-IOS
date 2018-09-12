//
//  MessagesProviderProtocol.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 9/4/18.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import Foundation

protocol MessagesProviderProtocol {
    func getMessagesList(treatmentMessages: @escaping ([PreliminaryMessage]) -> Void)
    func deleteChat(byId: NSNumber)
}
