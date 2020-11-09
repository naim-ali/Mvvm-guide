//
//  HomeViewModel.swift
//  Mvvm
//
//  Created by Sagepath on 2/18/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Bond
import CoreLocation
import Foundation

class HomeViewModel: BaseViewModel, CLLocationManagerDelegate {
    
    struct Image {
        let url = Observable<String>("")
        var height = Observable<Int>(Int.min)
        var width = Observable<Int>(Int.min)
    }
    
    weak var client: KKAPIClient?
    
    var image: Image
    var locationEnabled: Observable<Bool> = Observable<Bool>(true)
    var rewards: MutableObservableArray<String>
    
    override init() {
        image = Image()
        rewards = MutableObservableArray<String>()
        
        super.init()
    }
    
    func getImage(width: Int, height: Int) {
        let placeholderName = authentication.value.isAuthorized ? "Hotlight App - Home" : "Hotlight App - Home"
        
        client?.imagesGet(String(height), width: String(width), placeholderName: placeholderName)
            .continueWith {(task: AWSTask) -> Any? in
                
                if let error = task.error {
                    self.handleError(error: error)
                } else if task.result is KKImageResponse {
                    let res = task.result as! KKImageResponse
                    
                    self.image.url.value = res.url ?? ""
                    self.image.width.value = res.width?.intValue ?? 0
                    self.image.height.value = res.height?.intValue ?? 0
                }
                
            return nil
        }
    }
    
    var locationManager:CLLocationManager?
    
    func getMyShop() {
        if (locationManager == nil) {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func getRewards() {
        if (authentication.value.isAuthorized) {
            client?.rewardsAvailableGet(authentication.value.loyaltyCardNumber!)
                .continueWith {(task: AWSTask) -> Any? in
                    
                    if let error = task.error {
                        self.handleError(error: error)
                    } else if task.result is NSArray {
                        let rewards = task.result as! [KKRewardsResponse]
                        for reward in rewards {
                            self.rewards.append(reward.available ?? "")
                        }
                    }
                    
                    return nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        if (authentication.value.favoriteShopId == nil) {
            client?.shopsNearestGet(String(userLocation.coordinate.longitude), latitude: String(userLocation.coordinate.latitude))
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
        } else {
            client?.shopsShopIdGet((authentication.value.favoriteShopId?.stringValue)!, longitude: String(userLocation.coordinate.longitude), latitude: String(userLocation.coordinate.latitude))
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        self.locationEnabled.value = false
        
        // if they have a shop set, try to get it
        if (authentication.value.favoriteShopId != nil) {
            client?.shopsShopIdGet((authentication.value.favoriteShopId?.stringValue)!, longitude: nil, latitude: nil)
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
    }
}
