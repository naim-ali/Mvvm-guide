//
//  MessagesViewModel.swift
//  Mvvm
//
//  Created by Naim Ali on 4/3/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit
import Bond
class MessagesViewModel: BaseViewModel {
    
     weak var client: KKAPIClient?
    
    var messages : MutableObservableArray<Any>
    

    override init() {
        messages = MutableObservableArray<Any>()
        super.init()
    }
    
    
    func getmessages(){
        if self.messages.count <= 0 {
            if (authentication.value.isAuthorized) {
                var msgs: NSArray = [
                    ["title": "Title text", "body": "Body text for cell", "date":"2/12/2018"],
                    ["title": "Test", "body": "Body sample cell", "date":"1/11/2018"]
                ]
                
                for msg in msgs {
                    let message = msg as! [String : String]
                    self.messages.append(message as! Any)
                }
//                client?.messages(authentication.value.accessToken!, customerId: authentication.value.customerId!)
//                    .continueWith {(task: AWSTask) -> Any? in
//                        if let error = task.error {
//                            self.handleError(error: error)
//                        } else {
//                            let paymentMethods = task.result as! KKPaymentMethodsResponse
//                            if paymentMethods.paymentMethods!.count > 0 {
//                                for paymentMethod in paymentMethods.paymentMethods! {
//                                    let pm = paymentMethod as Any
//
//                                    print("pmap", pm); self.paymentMethods.append(paymentMethod as! KKPaymentMethodsResponse_paymentMethods_item)
//                                }
//                            }
//                        }
//                        return nil
//                }
            }
        }
    }
    
}
