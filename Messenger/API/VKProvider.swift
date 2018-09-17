//
//  VKProvider.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 23.07.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKProvider: FriendsListProviderProtocol, MessagesProviderProtocol, PrivateChatProviderProtocol {
    private var ts: NSNumber?
    private var server: String?
    private var key: String?
    private let serialQueue: DispatchQueue
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    init() {
        serialQueue = DispatchQueue(label: "queue")
    }
    
    // MARK: LongPoll
    public func getLongPollServer(callBack: @escaping () -> Void) {
        serialQueue.async {
            VKRequest(method: "messages.getLongPollServer", parameters: ["need_pts":"0"]).execute(resultBlock: { [weak self] (response) in
                let json = response?.json as! Dictionary<String, Any>
                self?.ts = json["ts"] as? NSNumber
                self?.key = json["key"] as? String
                self?.server = json["server"] as? String
                DispatchQueue.main.async {
                    callBack()
                }
                }, errorBlock: { (error) in
                    print("ERROR: \(String(describing: error))")
            })
        }
    }
    
    public func registrationLongPoll(callBack: @escaping () -> Void) {
        serialQueue.async {
            let url: URL! = URL(string: "https://\(self.server!)?act=a_check&key=\(self.key!)&ts=\(self.ts!.stringValue)&wait=25&mode=2&version=2")
            self.session.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
                DispatchQueue.main.async {
                    callBack()
                }
            }).resume()
        }
    }
    
    // MARK: FriendsList
    public func getFriendsList(treatmentFriends: @escaping ([Person]) -> Void) {
        serialQueue.async {
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
                DispatchQueue.main.async {
                    treatmentFriends(bioFriends)
                }
            }, errorBlock: { (error) in
                print("ERROR: \(String(describing: error))")
            })
        }
    }

    public func deleteFriend(byId: NSNumber) {
        serialQueue.async {
            VKRequest(method: "friends.delete", parameters: ["user_id":byId.stringValue]).execute(resultBlock: { (response) in
                print("Friend \(byId.stringValue) was deleted")
            }, errorBlock: { (error) in
                print("ERROR: \(String(describing: error))")
            })
        }
    }
    
    //MARK: MessagesList
    public func getMessagesList(treatmentMessages: @escaping ([PreliminaryMessage]) -> Void) {
        serialQueue.async {
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
                DispatchQueue.main.async {
                    treatmentMessages(sortedConversations)
                }
                }, errorBlock: { (error) in
                    print("Error: \(String(describing: error))")
            })
        }
    }
    
    private func getPreliminaryMessages(person: Person, objects: Array<Dictionary<String, Any>>) -> [PreliminaryMessage]? {
        var messages = [PreliminaryMessage]()
        for object in objects {
            let lastMessage = object["last_message"] as! Dictionary<String, Any>
            let conversation = object["conversation"] as! Dictionary<String, Any>
            let peer = conversation["peer"] as! Dictionary<String, Any>
            let count = conversation["unread_count"] as? NSNumber
            let textLastMessage: String
            let isSentRead: Bool
            conversation["in_read"] as! NSNumber != conversation["out_read"] as! NSNumber ? (isSentRead = false) : (isSentRead = true)
            if let out = lastMessage["out"] as? Bool {
                out ? (textLastMessage = "You: \(setTextLastMessages(byLastMessages: lastMessage))") : (textLastMessage = setTextLastMessages(byLastMessages: lastMessage))
            } else {
                textLastMessage = setTextLastMessages(byLastMessages: lastMessage)
            }
            if peer["type"] as? String == "user" {
                if person.id == (lastMessage["peer_id"] as! NSNumber) {
                    messages.append(PreliminaryMessage(person: person,
                                              lastMessage: textLastMessage,
                                              lastDateMessage: lastMessage["date"] as! NSNumber,
                                              id: peer["id"] as? NSNumber,
                                              unreadCount: count != nil ? count : 0,
                                              isSentRead: isSentRead))
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
                    //nid fix this. mb???
                    if person.id == activeIds.first {
                        messages.append(PreliminaryMessage(person: Person(id: activeIds.first!,
                                                                 name: conversationIds["title"] as? String,
                                                                 surname: "",
                                                                 avaImgUrl: photoUrl,
                                                                 isOnline: nil),
                                                  lastMessage: textLastMessage,
                                                  lastDateMessage: lastMessage["date"] as! NSNumber,
                                                  id: peer["id"] as? NSNumber,
                                                  unreadCount: count != nil ? count : 0,
                                                  isSentRead: isSentRead))
                    }
                }
            }
        }
        return messages
    }
    
    private func setTextLastMessages(byLastMessages: Dictionary<String, Any>) -> String {
        var textLastMessage = byLastMessages["text"] as! String
        if textLastMessage == "" {
            if let attachments = byLastMessages["attachments"] as? Array<Dictionary<String, Any>> {
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
        return textLastMessage
    }
    
    private func setTextMessages(byMessages: Dictionary<String, Any>) -> String {
        var textMessage = byMessages["body"] as! String
        if let attachments = byMessages["attachments"] as? Array<Dictionary<String, Any>> {
            attachments.forEach {
                switch $0["type"] as! String {
                case "photo": textMessage = setText(name: "photo", object: $0)
                case "video": textMessage = setText(name: "video", object: $0)
                case "audio": textMessage = setText(name: "audio", object: $0)
                case "doc": textMessage = setText(name: "doc", object: $0)
                case "link": textMessage = "Link"
                case "market": textMessage = "Market"
                case "market_album": textMessage = "Market album"
                case "wall": textMessage = setText(name: "wall", object: $0)
                case "wall_reply": textMessage = setText(name: "wall_reply", object: $0)
                case "sticker": textMessage = setText(name: "sticker", object: $0)
                case "gift": textMessage = "Gift"
                default:
                    break
                }
                return
            }
        }
        return textMessage
    }
    
    private func setText(name: String, object: Dictionary<String, Any>) -> String {
        let currentObject = object[name] as! Dictionary<String, Any>
        switch name {
        case "wall": return currentObject["text"] as! String
        case "video": return currentObject["description"] as! String
        case "audio": return currentObject["url"] as! String
        case "sticker": return currentObject["photo_256"] as! String
        case "photo": return currentObject["photo_130"] as! String
        case "doc": return currentObject["url"] as! String
        default:
            return ""
        }
    }
    
    public func deleteChat(byId: NSNumber) {
        serialQueue.async {
            VKRequest(method: "messages.deleteConversation", parameters: ["peer_id":byId.stringValue]).execute(resultBlock: { (response) in
                print("Chat \(byId.stringValue) was deleted")
            }, errorBlock: { (error) in
                print("ERROR: \(error as! String)")
            })
        }
    }
    
    //MARK: Chat
    public func getChatMessagesList(byId: String, treatmentMessages: @escaping ([PrivateMessage]) -> Void) {
        serialQueue.async {
            var messages = [PrivateMessage]()
            VKRequest(method: "messages.getHistory", parameters: ["user_id":byId, "count":"20", "rew":"1"]).execute(resultBlock: { [weak self] (response) in
                let json = response?.json as! Dictionary<String, Any>
                let items = json["items"] as! Array<Dictionary<String, Any>>
//                print(json)
                items.forEach {
                    let text = self?.setTextMessages(byMessages: $0)
                    messages.append(PrivateMessage(message: text!,
                                                   date: $0["date"] as! NSNumber,
                                                   isMine: $0["out"] as! Bool) )
                }
                DispatchQueue.main.async {
                    treatmentMessages(messages)
                }
            }, errorBlock: { (error) in
                print("ERROR: \(String(describing: error))")
            })
        }
    }
    
    public func send(message: String, userId:String) {
        serialQueue.async {
            if message != "" && userId != "" {
                VKRequest(method: "messages.send", parameters: ["message":message, "peer_id":userId]).execute(resultBlock: { (response) in
                    print("Message was sent!")
                }, errorBlock: { (error) in
                    print("ERROR: \(error as! String)")
                })
            }
        }
    }
    
}
