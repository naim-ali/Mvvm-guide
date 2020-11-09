//
//  ForgotPasswordViewModel.swift
//  Mvvm
//
//  Created by Sagepath on 2/26/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Bond
import CoreLocation
import Foundation

class ForgotPasswordViewModel: BaseViewModel {
    
    weak var client: KKAPIClient?
    
    var email: Observable<String?>
    var code: Observable<String?>
    var password: Observable<String?>
    
    var codeIsSent: Observable<Bool>
    var codeIsValid: Observable<Bool>
    
    override init() {
        email = Observable<String?>(nil)
        code = Observable<String?>(nil)
        password = Observable<String?>(nil)
        
        codeIsSent = Observable<Bool>(false)
        codeIsValid = Observable<Bool>(false)
        
        super.init()
    }
    
    func forgotPassword() {
        let forgotPasswordRequest = KKForgotPasswordRequest()!
        forgotPasswordRequest.email = email.value
        
        client?.authForgotpasswordPost(forgotPasswordRequest)
            .continueWith {(task: AWSTask) -> Any? in
                
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKSuccessResponse {
                    let res = task.result as! KKSuccessResponse
                    
                    self.codeIsSent.value = res.success == 1
                }
                
                return nil
        }
    }
    
    func verifyCode() {
        let forgotPasswordRequest = KKForgotPasswordRequest()!
        forgotPasswordRequest.email = email.value
        forgotPasswordRequest.code = code.value
        
        client?.authVerifycodePost(forgotPasswordRequest)
            .continueWith {(task: AWSTask) -> Any? in
                
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKSuccessResponse {
                    let res = task.result as! KKSuccessResponse
                    
                    self.codeIsValid.value = res.success == 1
                }
                
                return nil
        }
    }
    
    func resetPassword() {
        let forgotPasswordRequest = KKForgotPasswordRequest()!
        forgotPasswordRequest.source = "iOS"
        forgotPasswordRequest.email = email.value
        forgotPasswordRequest.code = code.value
        forgotPasswordRequest.password = password.value
        
        client?.authResetpasswordPost(forgotPasswordRequest)
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
