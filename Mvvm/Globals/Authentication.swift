//
//  Authentication.swift
//  Mvvm
//
//  Created by Sagepath on 2/21/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Bond
import Foundation

class Authentication: KKAuthResponse {
    
    var isAuthorized: Bool {
        return self.accessToken != nil && (self.accessToken?.count ?? 0) > 0
    }
    
    var favoriteShop: Observable<Shop?> = Observable<Shop?>(nil)
    
    static func create(authResponse: KKAuthResponse) -> Authentication! {
        let authentication = Authentication()
        
        authentication?.customerId = authResponse.customerId
        authentication?.loyaltyId = authResponse.loyaltyId
        authentication?.firstName = authResponse.firstName
        authentication?.lastName = authResponse.lastName
        authentication?.birthday = authResponse.birthday
        authentication?.email = authResponse.email
        authentication?.voicePhone = authResponse.voicePhone
        authentication?.favoriteShopId = authResponse.favoriteShopId
        authentication?.loyaltyCardNumber = authResponse.loyaltyCardNumber
        authentication?.accessToken = authResponse.accessToken
        authentication?.refreshToken = authResponse.refreshToken
        authentication?.expiresInSeconds = authResponse.expiresInSeconds
        authentication?.loyaltyZipCode = authResponse.loyaltyZipCode
        
        return authentication!
    }
}
