//
//  MapSubViewController.swift
//
//  Created by Naim Ali on 3/5/18.
//

import UIKit
import MapKit
import CoreLocation
import MapKitGoogleStyler

public protocol MapSubViewControllerDelegate: class {
    func regionDidChange(centerCoordinate: CLLocationCoordinate2D)
}

class MapSubViewController: UIViewController, MKMapViewDelegate ,CLLocationManagerDelegate {
    
    var delegate : MapSubViewControllerDelegate?
    var boundingRegion : MKCoordinateRegion = MKCoordinateRegion()
    var localSearch : MKLocalSearch!
    var locationManager : CLLocationManager!
    var userCoordinate : CLLocationCoordinate2D!
    var locValue:CLLocationCoordinate2D!
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var places: [MKMapItem] = []
    let placeMarks: NSMutableArray = NSMutableArray()
    var strCategory : String!
    var viewDetail : UIView!
    
    var mapItemList: [MKMapItem] = []
    
    var mapview: MKMapView!
    
    private var mapChangedFromUserInteraction = false
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapview.subviews[0]
        
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            delegate?.regionDidChange(centerCoordinate: mapview.centerCoordinate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strCategory = "krispy kreme"
        self.navigationItem.title = strCategory
        self.locationManager = CLLocationManager()
        
        self.mapview = MKMapView()
        self.mapview.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 260)
        self.mapview.mapType = MKMapType.standard
        self.mapview.isZoomEnabled = true
        self.mapview.isScrollEnabled = true
        self.mapview.delegate = self
        self.mapview.showsUserLocation = true
        self.mapview.mapType = MKMapType(rawValue: 0)!
        self.mapview.userTrackingMode = MKUserTrackingMode(rawValue: 1)!
        self.view.addSubview(self.mapview)
        
        if(authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingHeading()
        configureTileOverlay()
        self.mapview.showAnnotations(self.mapview.annotations, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        self.userCoordinate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        self.locationManager.stopUpdatingLocation()
        
        manager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: report any errors returned back from Location Services
    }

    func addAnnotation(_ item: Shop){
        let annotation = PlaceAnnotation()
    
        annotation.coordinate.latitude = item.latitude as! CLLocationDegrees
        annotation.coordinate.longitude = item.longitude as! CLLocationDegrees
        annotation.title = item.shopName
        annotation.detailAddress = item.address1
        annotation.id = item.shopId
        annotation.favorite = item.isFavorite
        annotation.hotlightOn = item.hotLightOn == 1
        
        self.mapview!.addAnnotation(annotation)
        placeMarks.add(annotation)
    }
    
    func removeAnnotations() {
        self.mapview!.removeAnnotations(placeMarks as! [MKAnnotation])
        placeMarks.removeAllObjects()
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("failed to load map")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
        }
        
        let annotation = view.annotation as? PlaceAnnotation
        let parentVC = self.parent as! ShopFinderController
  
        let sum = parentVC.viewModel?.shops.count
        for index in 0..<sum! {
            let shop = parentVC.viewModel?.shops[index]
            if annotation?.id == shop?.shopId {
                parentVC.viewModel?.selectedShop.value = shop
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView? = nil
        if annotation is PlaceAnnotation {
            annotationView = self.mapview!.dequeueReusableAnnotationView(withIdentifier: "Pin")
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
                annotationView!.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            let placeAnnotation = annotation as! PlaceAnnotation
            if (placeAnnotation.hotlightOn ?? false) {
                annotationView!.image = UIImage(named:"hot-annotation.png")!
            } else if (placeAnnotation.favorite ?? false) {
                annotationView!.image = UIImage(named:"fav-annotation.png")!
            } else {
                annotationView!.image = UIImage(named:"reg-annotation.png")!
            }
        }
        
        return annotationView
    }
    
    func zoomMapFitAnnotation(_ shopId : NSNumber) {
        if let annotation = placeMarks.first(where: {($0 as! PlaceAnnotation).id == shopId}) {
            self.mapview.showAnnotations([annotation as! PlaceAnnotation], animated: true)
        }
    }
    
    func zoomMapFitAnnotations() {
        var zoomRect = MKMapRectNull
        for annotation in mapview.annotations {
            if (annotation is PlaceAnnotation) {
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                if (MKMapRectIsNull(zoomRect)) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
        }
        self.mapview.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(50, 50, 50, 50), animated: true)
    }
    
    private func configureTileOverlay() {
        // We first need to have the path of the overlay configuration JSON
        guard let overlayFileURLString = Bundle.main.path(forResource: "overlay", ofType: "json") else {
            return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        mapview.add(tileOverlay)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
