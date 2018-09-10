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
        VKRequest(method: "friends.get", parameters: ["fields":"photo_50", "order":"hints"]).execute(resultBlock: { (response) in
            let json = response?.json as! Dictionary<String, Any>
            let items = json["items"] as! Array<Dictionary<String, Any>>
            items.forEach {
                bioFriends.append(Person(id: $0["id"] as? NSNumber,
                                         name: $0["first_name"] as? String,
                                         surname: $0["last_name"] as? String,
                                         avaImgUrl: $0["photo_50"] as? String,
                                         isOnline: $0["online"] as? Bool))
            }
            treatmentFriends(bioFriends)
        }, errorBlock: { (error) in
            print("ERROR: \(error as! String)")
        })
    }
    
    public func getMessagesList(treatmentMessages: @escaping ([PreliminaryMessage]) -> Void) {
        // get list prev messages
        var conversations = [PreliminaryMessage]()
        VKRequest(method: "messages.getConversations", parameters: ["extended":"1"]).execute(resultBlock: { [weak self] (response) in
            let json = response?.json as! Dictionary<String, Any>
            let profiles = json["profiles"] as! Array<Dictionary<String, Any>>
            let items = json["items"] as! Array<Dictionary<String, Any>>
            profiles.forEach {
                if let gettingMessage = (self?.getPreliminaryMessages(person: Person(id: $0["id"] as? NSNumber,
                                                                              name: $0["first_name"] as? String,
                                                                              surname: $0["last_name"] as? String,
                                                                              avaImgUrl: $0["photo_50"] as? String,
                                                                              isOnline: $0["online"] as? Bool),
                                                               objects: items)) {
                    conversations.append(gettingMessage)
                }
            }
            treatmentMessages(conversations)
        }, errorBlock: { (error) in
            print("Error: \(String(describing: error))")
        })
    }
    
    private func getPreliminaryMessages(person: Person, objects: Array<Dictionary<String, Any>>) -> PreliminaryMessage? {
        for object in objects {
            let lastMessage = object["last_message"] as! Dictionary<String, Any>
            let conversation = object["conversation"] as! Dictionary<String, Any>
            if let conversationIds = conversation["chat_settings"] as? Dictionary<String, Any> {
                let activeIds = conversationIds["active_ids"] as! Array<NSNumber>
                var photoUrl: String?
                if let photo = conversationIds["photo"] as? Dictionary<String, Any> {
                    photoUrl = photo["photo_50"] as? String
                } else {
                    photoUrl = person.avaImgUrl
                }
                //nid fix this. dont work with id
                if person.id == activeIds.first {
                    return PreliminaryMessage(person: Person(id: activeIds.first!,
                                                            name: conversationIds["title"] as? String,
                                                            surname: nil,
                                                            avaImgUrl: photoUrl,
                                                            isOnline: nil),
                                              lastMessage: lastMessage["text"] as! String,
                                              lastDateMessage: lastMessage["date"] as! NSNumber,
                                              id: nil)
                }
            }
            if person.id == (lastMessage["peer_id"] as! NSNumber) {
                return PreliminaryMessage(person: person,
                                          lastMessage: lastMessage["text"] as! String,
                                          lastDateMessage: lastMessage["date"] as! NSNumber,
                                          id: nil)
            }
        }
        return nil
    }
    
}
