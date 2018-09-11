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
                    conversations = conversations + gettingMessage
                }
            }
            //sort
            let sortedConversations = conversations.sorted {$0.lastDateMessage.compare($1.lastDateMessage) == .orderedDescending}
            treatmentMessages(sortedConversations)
        }, errorBlock: { (error) in
            print("Error: \(String(describing: error))")
        })
    }
    
    private func getPreliminaryMessages(person: Person, objects: Array<Dictionary<String, Any>>) -> [PreliminaryMessage]? {
        var messages = [PreliminaryMessage]()
        for object in objects {
            let lastMessage = object["last_message"] as! Dictionary<String, Any>
            let conversation = object["conversation"] as! Dictionary<String, Any>
            let peer = conversation["peer"] as! Dictionary<String, Any>
            let count = conversation["unread_count"] as? NSNumber
            var textLastMessage = lastMessage["text"] as! String
            if textLastMessage == "" {
                if let attachments = lastMessage["attachments"] as? Array<Dictionary<String, Any>> {
                    attachments.forEach {
                        switch $0["type"] as! String {
                        case "photo": textLastMessage = "Photo"
                        case "video": textLastMessage = "Video"
                        case "audio": textLastMessage = "Audio"
                        case "doc": textLastMessage = "Document"
                        case "link": textLastMessage = "Link"
                        case "market": textLastMessage = "Market"
                        case "market_album": textLastMessage = "Market album"
                        case "wall": textLastMessage = "Wall post"
                        case "wall_reply": textLastMessage = "Wall reply"
                        case "sticker": textLastMessage = "Sticker"
                        case "gift": textLastMessage = "Gift"
                        default:
                            break
                        }
                        return
                    }
                }
            }
            if peer["type"] as? String == "user" {
                if person.id == (lastMessage["peer_id"] as! NSNumber) {
                    messages.append(PreliminaryMessage(person: person,
                                              lastMessage: textLastMessage,
                                              lastDateMessage: lastMessage["date"] as! NSNumber,
                                              id: nil,
                                              unreadCount: count != nil ? count : 0))
                }
            } else {
                if let conversationIds = conversation["chat_settings"] as? Dictionary<String, Any> {
                    let activeIds = conversationIds["active_ids"] as! Array<NSNumber>
                    var photoUrl: String?
                    if let photo = conversationIds["photo"] as? Dictionary<String, Any> {
                        photoUrl = photo["photo_50"] as? String
                    } else {
                        photoUrl = "https://vk.com/images/community_50.png?ava=1"
                    }
                    //nid fix this. dont work with id???
                    if person.id == activeIds.first {
                        messages.append(PreliminaryMessage(person: Person(id: activeIds.first!,
                                                                 name: conversationIds["title"] as? String,
                                                                 surname: "",
                                                                 avaImgUrl: photoUrl,
                                                                 isOnline: nil),
                                                  lastMessage: textLastMessage,
                                                  lastDateMessage: lastMessage["date"] as! NSNumber,
                                                  id: nil,
                                                  unreadCount: count != nil ? count : 0))
                    }
                }
            }
        }
        return messages
    }
    
}
