//
//  SignInViewModel.swift
//  Mvvm
//
//  Created by Sagepath on 2/21/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Bond
import Foundation

class SignInViewModel: BaseViewModel {
    
    weak var client: KKAPIClient?
    
    var email: Observable<String?>
    var password: Observable<String?>
    
    override init() {
        email = Observable<String?>(nil)
        password = Observable<String?>(nil)
        
        super.init()
    }
    
    func signIn() {
        let signInRequest = KKSignInRequest()!
        signInRequest.source = "iOS"
        signInRequest.email = email.value
        signInRequest.password = password.value
        
        client?.authSigninPost(signInRequest)
            .continueWith{(task: AWSTask) -> Any? in
                
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKAuthResponse {
                    let res = task.result as! KKAuthResponse
                    
                    DispatchQueue.main.async {
                        self.authentication.value = Authentication.create(authResponse: res)
                        UserDefaults.standard.set(self.email.value, forKey: "email")
                        UserDefaults.standard.set(self.password.value, forKey: "password")
                    }
                }
                
                return nil
        }
    }
}
