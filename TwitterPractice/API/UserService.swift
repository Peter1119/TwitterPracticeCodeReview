//
//  UserService.swift
//  TwitterPractice
//
//  Created by 강창혁 on 2022/10/07.
//

import UIKit
import FirebaseAuth

struct UserService {
    static let shared = UserService()
    
    func fetchUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let username = dictionary["username"] as? String else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}
