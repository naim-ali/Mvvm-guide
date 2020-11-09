//
//  AccountViewModel.swift
//  Mvvm
//
//  Created by Naim Ali on 3/28/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit
import Bond

class AccountViewModel: BaseViewModel {
    
    weak var client: KKAPIClient?
    
    var paymentMethods : MutableObservableArray<KKPaymentMethodsResponse_paymentMethods_item>
    var shops : MutableObservableArray<KKSubscriptionsResponse_shopSubscriptions_item>
   
    
    var balance: Observable<KKCardBalanceResponse>
    
    var firstName: Observable<String?>
    var lastName: Observable<String?>
    var birthday: Observable<String?>
    var zip: Observable<String?>
    var phone: Observable<String?>
    var promo: Observable<String?>
    var email: Observable<String?>
    var password: Observable<String?>
    var phoneNumber: Observable<String?>
    var subscriptions = Observable<KKSubscriptionsResponse>(KKSubscriptionsResponse())
    
    override init() {
        paymentMethods = MutableObservableArray<KKPaymentMethodsResponse_paymentMethods_item>()
        shops = MutableObservableArray<KKSubscriptionsResponse_shopSubscriptions_item>()
        balance = Observable<KKCardBalanceResponse>(KKCardBalanceResponse())
        
        firstName = Observable<String?>(nil)
        lastName = Observable<String?>(nil)
        birthday = Observable<String?>(nil)
        zip = Observable<String?>(nil)
        phone = Observable<String?>(nil)
        promo = Observable<String?>(nil)
        email = Observable<String?>(nil)
        password = Observable<String?>(nil)
        phoneNumber = Observable<String?>(nil)
        
        super.init()
    }
    
    func getSubscriptions() {
        print("shops count objects", self.shops.count)
        if self.shops.count <= 0 {
            client?
                .customerSubscriptionsGet(
                    authentication.value.accessToken!,
                    deviceId: "test",
                    customerId: self.authentication.value.customerId!)
                .continueWith {(task: AWSTask) -> Any? in
                    if let error = task.error {
                        self.handleError(error: error)
                    } else if task.result is KKSubscriptionsResponse {
                        let subscription = Observable<KKSubscriptionsResponse>(task.result as! KKSubscriptionsResponse)
                        let subs = subscription.value.shopSubscriptions
                        for sub in subs! {
                            self.shops.append(sub as! KKSubscriptionsResponse_shopSubscriptions_item)
                        }
                    }
                    return nil
            }
        }
    }
    
    func updateSubscription(_ body : KKUpdateSubscriptionRequest ){
        client?
            .customerSubscriptionsUpdatePost(
                self.authentication.value.accessToken ?? "",
                body: body)
            .continueWith {(task: AWSTask) -> Any? in
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKSuccessResponse {
                    let successResponse = task.result as! KKSuccessResponse
                    if (successResponse.success != 1) {
                        self.handleError(error: "Unable to change subscription.")
                    } else {
 
                    }
                }
                return nil
        }
    }
    
    
    func changePassword(_ body : KKChangePasswordRequest ){
        client?
            .authChangepasswordPost(body)
            .continueWith {(task: AWSTask) -> Any? in
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKSuccessResponse {
                    let successResponse = task.result as! KKSuccessResponse
                    if (successResponse.success != 1) {
                        self.handleError(error: "Unable to change password.")
                    } else {
                        print("password changed succefully")
                    }
                }
                return nil
        }
    }
    
    
    func getShop(shopId: NSNumber?) {
        client?
            .shopsShopIdGet(
                (shopId?.stringValue)!,
                longitude: nil,
                latitude: nil)
            .continueWith {(task: AWSTask) -> Any? in
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKShopResponse {
                    let res = task.result as! KKShopResponse
                    let shop = Shop.create(shop: res)!
                    print("the res", shop)
                    //self.shops.append(shop)
                }
                return nil
        }
    }
    
    func changeSubscription(shopId: NSNumber?, subscribe: Bool) {
        let updateSubscriptionRequest = KKUpdateSubscriptionRequest()
        updateSubscriptionRequest?.customerId = self.authentication.value.customerId
        updateSubscriptionRequest?.deviceId = "test"
        updateSubscriptionRequest?.shopId = shopId
        updateSubscriptionRequest?.subscribe = subscribe ? 1 : 0
        
        client?
            .customerSubscriptionsUpdatePost(
                self.authentication.value.accessToken ?? "",
                body: updateSubscriptionRequest!)
            .continueWith {(task: AWSTask) -> Any? in
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKSuccessResponse {
                    let successResponse = task.result as! KKSuccessResponse
                    if (successResponse.success != 1) {
                        self.handleError(error: "Unable to change subscription.")
                    } else {
                        self.getSubscriptions()
                    }
                }
                return nil
        }
    }
    
    func addPaymentMethod(_ body : KKUpdatePaymentMethodRequest){
        if (authentication.value.isAuthorized) {
            client?.paymentsPaymentmethodsUpdatePost(authentication.value.accessToken!, body: body)
                .continueWith {(task: AWSTask) -> Any? in
                    if let error = task.error {
                        print("error addin", error)
                        self.handleError(error: error)
                    } else{
                        print("added paymrnt method", task.result)
                        self.paymentMethods.removeAll()
                        self.getPaymentMethods()
                    }
                    return nil
            }
        }
    }
    
    func removePaymentMethod(_ body : KKRemovePaymentMethodRequest , index: Int){
        if (authentication.value.isAuthorized) {
            self.paymentMethods.remove(at: index)
           print(body, "brre")
            client?.paymentsPaymentmethodsRemovePost(authentication.value.accessToken!, body: body)
                .continueWith {(task: AWSTask) -> Any? in
                    if let error = task.error {
                        self.handleError(error: error)
                    }
                    print(task, "task at hand")
                    return nil
            }
        }
    }
    
    func getPaymentMethods(){
        
        if self.paymentMethods.count <= 0 {
            print("count payments", self.paymentMethods.count)
            if (authentication.value.isAuthorized) {
            client?.paymentsPaymentmethodsGet(authentication.value.accessToken!, customerId: authentication.value.customerId!)
                    .continueWith {(task: AWSTask) -> Any? in
                        if let error = task.error {
                            self.handleError(error: error)
                        } else {
                            let paymentMethods = task.result as! KKPaymentMethodsResponse
                            
                            if paymentMethods.paymentMethods!.count > 0 {
                                for paymentMethod in paymentMethods.paymentMethods! {
                                    let pm = paymentMethod as Any
                                    
                                    print("pmap", pm); self.paymentMethods.append(paymentMethod as! KKPaymentMethodsResponse_paymentMethods_item)
                                }
                            }
                        }
                        
                        return nil
                }
            }
        }
        
    }
    
    func getCardBalance() {
        if (authentication.value.isAuthorized) {
            client?.paymentsCardbalanceGet( authentication.value.accessToken!, loyaltyCardNumber: authentication.value.loyaltyCardNumber!, customerId: authentication.value.customerId!)
                .continueWith {(task: AWSTask) -> Any? in
                    if let error = task.error {
                        self.handleError(error: error)
                    } else {
                        self.balance.value = (task.result as? KKCardBalanceResponse)!
                    }
                    return nil
            }
        }
    }
    
    
    func updateAccount() {
        let updateAccountRequest = KKUpdateCustomerRequest()!
        updateAccountRequest.firstName = firstName.value != "" ? firstName.value : authentication.value.firstName
        updateAccountRequest.lastName = lastName.value != "" ? lastName.value : authentication.value.lastName
        updateAccountRequest.zipCode = zip.value != "" ? zip.value : authentication.value.loyaltyZipCode
        if phoneNumber.value != ""{
            phoneNumber.value = phoneNumber.value!.replacingOccurrences(of: "-", with: "")
            print(phoneNumber.value, "phone value")
        }
        updateAccountRequest.phoneNumber = phoneNumber.value != "" ? phoneNumber.value : authentication.value.voicePhone
        updateAccountRequest.customerId = authentication.value.customerId
        
        
        client?.customerUpdatePost(authentication.value.accessToken!, body: updateAccountRequest)
            .continueWith {(task: AWSTask) -> Any? in
                
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKSuccessResponse {
                    DispatchQueue.main.async {
                        self.authentication.value.firstName = updateAccountRequest.firstName
                        self.authentication.value.lastName = updateAccountRequest.lastName
                        self.authentication.value.loyaltyZipCode = updateAccountRequest.zipCode
                        self.authentication.value.voicePhone = updateAccountRequest.phoneNumber
                        
                    }
                }
                
                return nil
        }
    }
    
    
    
    

}
