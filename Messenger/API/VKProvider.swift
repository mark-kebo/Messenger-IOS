//
//  VKProvider.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 23.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKProvider: FriendsListProviderProtocol, MessagesProviderProtocol {
    
    public func getFriendsList(treatmentFriends: @escaping ([Person]) -> Void) {
        var bioFriends = [Person]()
        VKRequest(method: "friends.get", parameters: ["fields":"photo_50"]).execute(resultBlock: { (response) in
            let json = response?.json as! Dictionary<String, Any>
            let items = json["items"] as! Array<Dictionary<String, Any>>
            items.forEach {
                bioFriends.append(Person(name: $0["first_name"] as! String,
                                         surname: $0["last_name"] as! String,
                                         avaImgUrl: $0["photo_50"] as! String,
                                         isOnline: $0["online"] as! Bool))
            }
            treatmentFriends(bioFriends)
        }, errorBlock: { (error) in
            print("ERROR: \(error as! String)")
        })
    }
    
    public func getMessagesList(treatmentMessages: @escaping ([PreliminaryMessage]) -> Void) {
        // get list prev messages
        var conversations = [PreliminaryMessage]()
        VKRequest(method: "messages.getConversations", parameters: ["fields":"photo_50"]).execute(resultBlock: { (response) in
            let json = response?.json as! Dictionary<String, Any>
            let items = json["items"] as! Array<Dictionary<String, Any>>
            items.forEach {
                print($0["last_message"])
//                conversations.append(PreliminaryMessage(person: Person(name: $0["user_id"] as! String,
//                                                                       surname: "",
//                                                                       avaImgUrl: "",
//                                                                       isOnline: false),
//                                                        lastMessage: $0["text"] as! String,
//                                                        lastDateMessage: $0["date"] as! Date))
            }
            treatmentMessages(conversations)
        }, errorBlock: { (error) in
            print("Error: \(String(describing: error))")
        })
    }
}
