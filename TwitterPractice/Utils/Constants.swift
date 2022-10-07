//
//  Constants.swift
//  TwitterPractice
//
//  Created by 강창혁 on 2022/10/07.
//

import FirebaseDatabase
import FirebaseStorage
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
