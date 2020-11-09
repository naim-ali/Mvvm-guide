//
//  newShop.swift
//  Mvvm
//
//  AWS API Gateway gives us a KKShopResponse and a KKShopsResponse, but they're basically the same thing
//  This class is used as a common representation for both
//
//  Created by Sagepath on 3/21/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation

class Shop: KKShopsResponse {
    
    var isFavorite: Bool {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return (appDelegate.authentication.value.favoriteShopId == self.shopId)
    }
    
    static func create(shop: KKShopsResponse) -> Shop? {
        let newShop = Shop()
        newShop?.siteId = shop.siteId
        newShop?.shopId = shop.shopId
        newShop?.shopName = shop.shopName
        newShop?.address1 = shop.address1
        newShop?.address2 = shop.address2
        newShop?.city = shop.city
        newShop?.state = shop.state
        newShop?.zipCode = shop.zipCode
        newShop?.phoneNumber = shop.phoneNumber
        newShop?.faxNumber = shop.faxNumber
        newShop?.latitude = shop.latitude
        newShop?.longitude = shop.longitude
        newShop?.isClosed = shop.isClosed
        newShop?.hoursDescriptionDineIn = shop.hoursDescriptionDineIn
        newShop?.hoursDescriptionDriveThru = shop.hoursDescriptionDriveThru
        
        newShop?.hoursDineIn = [KKShopsResponse_item_hoursDineIn_item]()
        let hoursDineIn = shop.hoursDineIn as! [KKShopsResponse_item_hoursDineIn_item]?
        if (hoursDineIn != nil) {
            for hours in hoursDineIn! {
                let h = KKShopsResponse_item_hoursDineIn_item()
                h?.key = hours.key
                h?.value = hours.value
                
                newShop?.hoursDineIn?.append(h!)
            }
        }
        
        newShop?.hoursDriveThru = [KKShopsResponse_item_hoursDriveThru_item]()
        let hoursDriveThru = shop.hoursDriveThru as! [KKShopsResponse_item_hoursDriveThru_item]?
        if (hoursDriveThru != nil) {
            for hours in hoursDriveThru! {
                let h = KKShopsResponse_item_hoursDriveThru_item()
                h?.key = hours.key
                h?.value = hours.value
                
                newShop?.hoursDriveThru?.append(h!)
            }
        }
        
        newShop?.distance = shop.distance
        newShop?.hotLightOn = shop.hotLightOn
        
        return newShop
    }
    
    static func create(shop: KKShopResponse) -> Shop? {
        let newShop = Shop()
        newShop?.siteId = shop.siteId
        newShop?.shopId = shop.shopId
        newShop?.shopName = shop.shopName
        newShop?.address1 = shop.address1
        newShop?.address2 = shop.address2
        newShop?.city = shop.city
        newShop?.state = shop.state
        newShop?.zipCode = shop.zipCode
        newShop?.phoneNumber = shop.phoneNumber
        newShop?.faxNumber = shop.faxNumber
        newShop?.latitude = shop.latitude
        newShop?.longitude = shop.longitude
        newShop?.isClosed = shop.isClosed
        newShop?.hoursDescriptionDineIn = shop.hoursDescriptionDineIn
        newShop?.hoursDescriptionDriveThru = shop.hoursDescriptionDriveThru
        
        newShop?.hoursDineIn = [KKShopsResponse_item_hoursDineIn_item]()
        let hoursDineIn = shop.hoursDineIn as! [KKShopResponse_hoursDineIn_item]?
        if (hoursDineIn != nil) {
            for hours in hoursDineIn! {
                let h = KKShopsResponse_item_hoursDineIn_item()
                h?.key = hours.key
                h?.value = hours.value
                
                newShop?.hoursDineIn?.append(h!)
            }
        }
        
        newShop?.hoursDriveThru = [KKShopsResponse_item_hoursDriveThru_item]()
        let hoursDriveThru = shop.hoursDriveThru as! [KKShopResponse_hoursDriveThru_item]?
        if (hoursDriveThru != nil) {
            for hours in hoursDriveThru! {
                let h = KKShopsResponse_item_hoursDriveThru_item()
                h?.key = hours.key
                h?.value = hours.value
                
                newShop?.hoursDriveThru?.append(h!)
            }
        }
        
        newShop?.distance = shop.distance
        newShop?.hotLightOn = shop.hotLightOn
        
        return newShop
    }
}
