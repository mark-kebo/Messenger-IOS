//
//  ProviderProtocol.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 23.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import Foundation

protocol FriendsListProviderProtocol {
    //замыкание было передано в функцию в качестве аргумента и вызывается уже после того, как функция вернулась
    func getFriendsList(treatmentFriends: @escaping ([Person]) -> Void)
}
