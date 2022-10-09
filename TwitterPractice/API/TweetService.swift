//
//  TweetService.swift
//  TwitterPractice
//
//  Created by 강창혁 on 2022/10/10.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "likes":0, "retweets":0, "caption": caption] as [String : Any]
        
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
}
