//
//  BaseViewModel.swift
//  Mvvm
//
//  Created by Sagepath on 2/18/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit

class BaseViewModel: NSObject {
    
    var authentication: Observable<Authentication> {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDelegate.authentication
    }
    
    let errorMessages = PublishSubject<String, NoError>()
    
    func handleError(error: Error) {
        let httpBody = (error as NSError).userInfo["HTTPBody"] as! NSDictionary?
        if (httpBody != nil) {
            let message = httpBody?["message"] as! String
            handleError(error: message)
        } else {
            handleError(error: error.localizedDescription)
        }
    }
    
    func handleError(error: String) {
        print(error)
        self.errorMessages.next(error)
    }
    
}
