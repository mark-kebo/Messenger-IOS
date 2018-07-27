//
//  VKProvider.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 23.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKProvider: FriendsListProviderProtocol {
    
    public func getFriendsList(treatmentFriends: @escaping ([Person]) -> Void) {
        var bioFriends = [Person]()
        VKRequest(method: "friends.get", parameters: ["fields":"photo_50"]).execute(resultBlock: { (response) in
            let json = response?.json as! Dictionary<String, Any>
            let items = json["items"] as! Array<Dictionary<String, Any>>
            items.forEach {
                bioFriends.append(Person(name: $0["first_name"] as! String, surname: $0["last_name"] as! String, avaImgUrl: $0["photo_50"] as! String))
            }
            treatmentFriends(bioFriends)
        }, errorBlock: { (error) in
            print("ERROR: \(error as! String)")
        })
    }
}
