//
//  CreateAccountViewModel.swift
//  Mvvm
//
//  Created by Sagepath on 2/26/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Bond
import CoreLocation
import Foundation

class CreateAccountViewModel: BaseViewModel {
    
    weak var client: KKAPIClient?
    
    var firstName: Observable<String?>
    var lastName: Observable<String?>
    var birthday: Observable<String?>
    var zip: Observable<String?>
    var phone: Observable<String?>
    var promo: Observable<String?>
    var email: Observable<String?>
    var password: Observable<String?>
    
    override init() {
        firstName = Observable<String?>(nil)
        lastName = Observable<String?>(nil)
        birthday = Observable<String?>(nil)
        zip = Observable<String?>(nil)
        phone = Observable<String?>(nil)
        promo = Observable<String?>(nil)
        email = Observable<String?>(nil)
        password = Observable<String?>(nil)
        
        super.init()
    }
    
    func createAccount() {
        let createAccountRequest = KKCreateAccountRequest()!
        createAccountRequest.source = "iOS"
        createAccountRequest.firstName = firstName.value
        createAccountRequest.lastName = lastName.value
        createAccountRequest.birthday = birthday.value
        createAccountRequest.zipCode = zip.value
        createAccountRequest.phoneNumber = phone.value
        createAccountRequest.promoCode = promo.value
        createAccountRequest.email = email.value
        createAccountRequest.password = password.value
        
        client?.authCreateaccountPost(createAccountRequest)
            .continueWith {(task: AWSTask) -> Any? in
                
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKAuthResponse {
                    let res = task.result as! KKAuthResponse
                    
                    DispatchQueue.main.async {
                        self.authentication.value = Authentication.create(authResponse: res)
                    }
                }
                
                return nil
        }
    }
}

