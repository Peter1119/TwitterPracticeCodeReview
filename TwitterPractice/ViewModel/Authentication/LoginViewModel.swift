//
//  LoginViewModel.swift
//  TwitterPractice
//
//  Created by 강창혁 on 2022/11/05.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    
    func userLogin(email: String, password: String, completion: @escaping ((AuthDataResult?, Error?)) -> Void) {
        AuthService.shared.logUserIn(withEmail: email, password: password) { result, error in
            completion((result, error))
        }
    }
}
