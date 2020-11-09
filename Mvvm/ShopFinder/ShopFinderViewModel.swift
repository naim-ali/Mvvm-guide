//
//  ShopFinderViewModel.swift
//  Mvvm
//
//  Created by Sagepath on 3/6/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Bond
import CoreLocation
import Foundation

class ShopFinderViewModel: BaseViewModel, CLLocationManagerDelegate {
    
    weak var client: KKAPIClient?
    
    var locationManager:CLLocationManager?
    var physicalLocation:Observable<CLLocation?> = Observable<CLLocation?>(nil)
    var currentLocation:Observable<CLLocation?> = Observable<CLLocation?>(nil)
    
    var shops = MutableObservableArray<Shop>()
    var shopsUpdated = Observable<Bool>(false)
    var selectedShop = Observable<Shop?>(nil)
    var subscriptions = Observable<KKSubscriptionsResponse>(KKSubscriptionsResponse())
    
    override init() {
        super.init()
    }
    
    func getShops() {
        if (locationManager == nil) {
            initializeLocationManager()
        } else {
            currentLocation.value = nil
            currentLocation.value = physicalLocation.value
        }
    }
    
    private func initializeLocationManager() {
        _ = currentLocation.observeNext { value in
            if (value == nil) {
                return
            }
            
            self.client?
                .shopsGet(
                    String((value?.coordinate.longitude)!),
                    latitude: String((value?.coordinate.latitude)!),
                    count: String(10))
                .continueWith {(task: AWSTask) -> Any? in
                    if let error = task.error {
                        self.handleError(error: error)
                    } else if task.result is NSArray {
                        let shops = task.result as! [KKShopsResponse]
                        
                        DispatchQueue.main.async {
                            self.shops.removeAll()
                            if (self.authentication.value.isAuthorized &&
                                self.authentication.value.favoriteShopId != nil &&
                                self.authentication.value.favoriteShop.value != nil) {
                                let favoriteShopLocation = CLLocation(
                                    latitude: CLLocationDegrees((self.authentication.value.favoriteShop.value?.latitude)!),
                                    longitude: CLLocationDegrees((self.authentication.value.favoriteShop.value?.longitude)!))
                                let distanceInMeters = value?.distance(from: favoriteShopLocation)
                                let distance = round(100 * (distanceInMeters! * 0.000621371)) / 100
                                self.authentication.value.favoriteShop.value?.distance = distance as NSNumber
                                self.shops.append(self.authentication.value.favoriteShop.value!)
                            }
                            for shop in shops {
                                let s = Shop.create(shop: shop)!
                                if !s.isFavorite {
                                    self.shops.append(s)
                                }
                            }
                            
                            self.shopsUpdated.value = true
                        }
                    }
                    return nil
            }
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func findShops(_ coordinate: CLLocationCoordinate2D) {
        currentLocation.value = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func getShop(shopId: NSNumber?) {
        if (locationManager == nil) {
            initializeLocationManager()
        }
        
        client?
            .shopsShopIdGet(
                (shopId?.stringValue)!,
                longitude: String(currentLocation.value?.coordinate.longitude ?? 0),
                latitude: String(currentLocation.value?.coordinate.latitude ?? 0))
            .continueWith {(task: AWSTask) -> Any? in
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKShopResponse {
                    let res = task.result as! KKShopResponse
                    self.selectedShop.value = Shop.create(shop: res)
                }
                return nil
        }
    }
    
    func getFavoriteShop() {
        client?
            .shopsShopIdGet(
                (authentication.value.favoriteShopId?.stringValue)!,
                longitude: String((currentLocation.value?.coordinate.longitude)!),
                latitude: String((currentLocation.value?.coordinate.latitude)!))
            .continueWith {(task: AWSTask) -> Any? in
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKShopResponse {
                    let res = task.result as! KKShopResponse
                    
                    DispatchQueue.main.async {
                        self.authentication.value.favoriteShop.value = Shop.create(shop: res)
                    }
                }
                return nil
        }
    }
    
    func getSubscriptions() {
        client?
            .customerSubscriptionsGet(
                authentication.value.accessToken!,
                deviceId: "test",
                customerId: self.authentication.value.customerId!)
            .continueWith {(task: AWSTask) -> Any? in
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKSubscriptionsResponse {
                    self.subscriptions = Observable<KKSubscriptionsResponse>(task.result as! KKSubscriptionsResponse)
                }
                return nil
        }
    }
    
    func getSelectedShopNotification() -> Bool {
        return ((subscriptions.value.shopSubscriptions?.first(where:{($0 as! KKSubscriptionsResponse_shopSubscriptions_item).shopId == selectedShop.value?.shopId})) != nil)
    }
    
    func changeSubscription(shopId: NSNumber?, subscribe: Bool) {
        let updateSubscriptionRequest = KKUpdateSubscriptionRequest()
        updateSubscriptionRequest?.customerId = self.authentication.value.customerId
        updateSubscriptionRequest?.deviceId = "test"
        updateSubscriptionRequest?.shopId = shopId
        updateSubscriptionRequest?.subscribe = subscribe ? true : false
        
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
    
    func updateFavoriteShop(shopId: NSNumber?, favorite: Bool) {
        if (favorite) {
            self.authentication.value.favoriteShopId = shopId
            self.getFavoriteShop()
        } else {
            self.authentication.value.favoriteShopId = nil
            self.authentication.value.favoriteShop.value = nil
        }
        
        let updateFavoriteShopRequest = KKUpdateFavoriteShopRequest()
        updateFavoriteShopRequest?.customerId = self.authentication.value.customerId
        updateFavoriteShopRequest?.shopId = shopId
        updateFavoriteShopRequest?.favorite = favorite ? true : false
        
        client?
            .customerFavoriteshopUpdatePost(
                self.authentication.value.accessToken ?? "",
                body: updateFavoriteShopRequest!)
            .continueWith {(task: AWSTask) -> Any? in
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKSuccessResponse {
                    let successResponse = task.result as! KKSuccessResponse
                    
                    DispatchQueue.main.async {
                        if (successResponse.success != 1) {
                            self.handleError(error: "Unable to update favorite shop.")
                        }
                    }
                }
                return nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        physicalLocation.value = locations[0] as CLLocation
        currentLocation.value = locations[0] as CLLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.errorMessages.next(error.localizedDescription)
    }
}
