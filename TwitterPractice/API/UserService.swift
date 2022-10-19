//
//  UserService.swift
//  TwitterPractice
//
//  Created by 강창혁 on 2022/10/07.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        userRef.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        userRef.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        userFollowingRef.child(currentUid).updateChildValues([uid: 1]) { _, _ in
            userFollowerRef.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        userFollowingRef.child(currentUid).child(uid).removeValue { _, _ in
            userFollowerRef.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        userFollowingRef.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            print(snapshot.exists())
            completion(snapshot.exists())
        }
    }
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        userFollowerRef.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            userFollowingRef.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
}
