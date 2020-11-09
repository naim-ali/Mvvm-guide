//
//
//

import UIKit
import CoreLocation
import MaterialComponents

protocol ShopFinderControllerDelegate: BaseNavigationViewControllerDelegate {
    func toAccount()
}

class ShopFinderController: BaseNavigationViewController, UITableViewDelegate, UITableViewDataSource, MapSubViewControllerDelegate {
    
    weak var coordinator: ShopFinderControllerDelegate? {
        didSet {
            super.baseNavigationCoordinator = coordinator
        }
    }
    var viewModel: ShopFinderViewModel?
    
    var header : MapHeader!
    
    var closeDetails : UIButton!
    var searchButton : UIButton!
    var locationButton : UIButton!
    
    @IBOutlet weak var detailsVerticleConstraint: NSLayoutConstraint!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var tableViewHeader : UIView!
    
    // SHOP DETAILS OUTLETS
    //----------------------------------
    @IBOutlet var shopDetails : UIView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopDirections: UIButton!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var shopPhone: UIButton!
    @IBOutlet weak var shopCity: UILabel!
    @IBOutlet weak var shopHoursSitIn: UILabel!
    @IBOutlet weak var shopHoursPullUp: UILabel!
    @IBOutlet weak var shopTimeSitIn: UILabel!
    @IBOutlet weak var shopTimePullUp: UILabel!
    @IBOutlet weak var hotLightLabel: UILabel!
    @IBOutlet weak var hotlightButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var hotLightToggle: UISwitch!
    @IBOutlet weak var shareBtn: UIButton!
    //----------------------------------
    
    @IBAction func switchHotLightToggle() {
        viewModel?.changeSubscription(shopId: viewModel?.selectedShop.value?.shopId, subscribe: hotLightToggle.isOn)
    }
    
    @IBAction func shareButtonClicked(sender: AnyObject)
    {
        let subject = "Come Join Me! "
        let message = "Join me at the nearest Krispy Kreme shop for a sweet treet!\n"
        
        // TODO: probably going to have to get the URL from the middleware layer
        var shopName = viewModel?.selectedShop.value?.shopName ?? ""
        shopName = shopName.replacingOccurrences(of: " ", with: "")
        
        if let link = NSURL(string: "http://Mvvm.com/location/\(shopName)") {
            let objectsToShare = [subject,message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.setValue(subject, forKey: "Subject")
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    var map : MapSubViewController!
    var navigationView = UIView()
    
    var regionChanging = false
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (viewModel?.selectedShop.value == nil) {
            closeDetails.alpha = 0
        }
        searchButton.alpha = 1
        locationButton.alpha = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        
        view.sendSubview(toBack: tableView)
        setupHeaderView()
        setupDetailsView()
        
        tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        // bind viewmodel shops to tableview
        _ = viewModel?.shopsUpdated.observeNext { value in
            if (value && self.viewModel!.shops.count > 0 ) {
                DispatchQueue.main.async() {
                    self.updateShops()
                }
            }
        }
        
        viewModel?.getShops()
        
        if (viewModel?.authentication.value.isAuthorized)! {
            viewModel?.getSubscriptions()
        }
        
        // NavigationHeader
        let navibarHeight : CGFloat = navigationController!.navigationBar.bounds.height
        let statusbarHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height
        navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: navibarHeight + statusbarHeight)
        navigationView.backgroundColor = UIColor.clear
        navigationView.alpha = 0.0
        view.addSubview(navigationView)
        
        closeDetails = UIButton(type: .custom)
        closeDetails.frame = CGRect(x: 8, y: 8, width: 40, height: 40)
        closeDetails.backgroundColor = Project.Colors.white
        closeDetails.layer.cornerRadius = 44 / 2
        closeDetails.setTitleColor(Project.Colors.darkGreen, for: .normal)
        closeDetails.layer.shadowColor = Project.Colors.gray.cgColor
        closeDetails.layer.shadowRadius = 21.0
        closeDetails.layer.shadowOpacity = 0.8
        closeDetails.layer.shadowOffset.height = 10.0
        closeDetails.setImage(UIImage(named: "Arrow Icon Green"), for: UIControlState())
        closeDetails.addTarget(self, action: #selector(ShopFinderController.leftButtonAction), for: .touchUpInside)
        view.addSubview(closeDetails)
        
        searchButton = UIButton(type: .custom)
        searchButton.frame = CGRect(x: self.view.frame.size.width - 48, y: 8, width: 40, height: 40)
        searchButton.backgroundColor = Project.Colors.white
        searchButton.layer.cornerRadius = 44 / 2
        searchButton.setTitleColor(Project.Colors.darkGreen, for: .normal)
        searchButton.layer.shadowColor = Project.Colors.gray.cgColor
        searchButton.layer.shadowRadius = 21.0
        searchButton.layer.shadowOpacity = 0.8
        searchButton.layer.shadowOffset.height = 10.0
        searchButton.setImage(UIImage(named: "ic_search"), for: UIControlState())
        searchButton.addTarget(self, action: #selector(ShopFinderController.rightButtonAction), for: .touchUpInside)
        view.addSubview(searchButton)
        
        locationButton = UIButton(type: .custom)
        locationButton.frame = CGRect(x: header.frame.width - 48, y: header.frame.height - 56, width: 40, height: 40)
        locationButton.layer.shadowColor = Project.Colors.gray.cgColor
        locationButton.layer.shadowRadius = 21.0
        locationButton.layer.shadowOpacity = 0.8
        locationButton.layer.shadowOffset.height = 10.0
        locationButton.setImage(UIImage(named: "my-location"), for: UIControlState())
        locationButton.addTarget(self, action: #selector(ShopFinderController.locationButtonAction), for: .touchUpInside)
        view.addSubview(locationButton)
        
        _ = viewModel?.selectedShop.observeNext {_ in
            DispatchQueue.main.async {
                if (self.viewModel?.selectedShop.value != nil) {
                    self.showDetails()
                } else {
                    //self.hideDetails()
                }
            }
        }
    }
    
    func updateShops() {
        self.tableView.reloadData()
        
        self.map.removeAnnotations()
        for i in 0..<(self.viewModel!.shops.count-1){
            let shop = self.viewModel?.shops[i]
            self.map.addAnnotation(shop!)
        }
        
        if (!regionChanging) {
            if (self.viewModel?.selectedShop.value != nil) {
                self.map.zoomMapFitAnnotation((self.viewModel?.selectedShop.value?.shopId)!)
            } else {
                self.map.zoomMapFitAnnotations()
            }
        }
        regionChanging = false
    }
    
    func regionDidChange(centerCoordinate: CLLocationCoordinate2D) {
        regionChanging = true
        viewModel?.findShops(centerCoordinate)
    }
    
    func setupDetailsView() {
        shopDetails.superview?.layer.zPosition = 1
        let frame = shopDetails.frame
        self.view.layoutIfNeeded()
        self.detailsVerticleConstraint.constant += frame.size.height * 2
        let scrollView = shopDetails.superview as? UIScrollView
        scrollView?.backgroundColor = UIColor.white
        scrollView?.contentInset = UIEdgeInsetsMake(20, 0, 10, 0);
    }
    
    func setupHeaderView() {
        header = MapHeader()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: tableViewHeader.frame.size.height),
                                 imageSize: CGSize(width: view.frame.size.width, height: tableViewHeader.frame.size.height),
                                 controller: self)
        
        map = MapSubViewController()
        map.delegate = self
        addChildViewController(map)
        header.mapView.addSubview(map.view)
        map.didMove(toParentViewController: self)
        
        let label = UILabel()
        label.frame = CGRect(x: 10, y: header.frame.size.height - 40, width: header.frame.size.width - 20, height: 40)
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        header.addSubview(label)
        
        tableViewHeader.addSubview(header)
        tableViewHeader.layer.zPosition = -1
        tableView.tableHeaderView = tableViewHeader
    }
    
    @objc func leftButtonAction() {
        hideDetails()
    }
    
    @objc func locationButtonAction() {
        viewModel?.getShops()
    }
    
    @objc func rightButtonAction() {
        hideDetails()
        searchButton.alpha = 0
        let storyboard = UIStoryboard(name: "ShopFinder", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "searchController") as! SearchShopViewController
        
        addChildViewController(searchViewController)
        self.view.addSubview(searchViewController.view)
        searchViewController.didMove(toParentViewController: self)
    }
    
    @objc func phoneAction(sender: UIButton) {
        let phoneNumber = sender.title(for: .normal)!
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.openURL(phoneCallURL as URL);
            }
        }
    }
    
    @objc func directionsAction(sender: UIButton) {
        var address = (viewModel?.selectedShop.value?.address1 ?? "") + " "
        if (viewModel?.selectedShop.value?.address2 != nil) {
            address = address + (viewModel?.selectedShop.value?.address2)! + " "
        }
        address = address + "\(viewModel?.selectedShop.value?.city ?? ""), \(viewModel?.selectedShop.value?.state ?? "") \(viewModel?.selectedShop.value?.zipCode ?? "")"
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        let latitude = viewModel?.selectedShop.value?.latitude
        let longitude = viewModel?.selectedShop.value?.longitude
        let url = "http://maps.apple.com/?address=\(encodedAddress)&sll=\(latitude ?? 0),\(longitude ?? 0)"
        if let directionsURL:NSURL = NSURL(string: url) {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(directionsURL as URL)) {
                application.openURL(directionsURL as URL);
            }
        }
    }
    
    func hideDetails(){
      
        viewModel?.selectedShop.value = nil
        coordinator?.toAccount()
        self.map.zoomMapFitAnnotations()
        closeDetails.alpha = 0
        let frame = shopDetails.frame
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4, animations: {
            self.detailsVerticleConstraint.constant = frame.size.height * 2
            self.view.layoutIfNeeded()
        })
    }
    
    func showDetails(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.tableView.contentOffset.y = CGFloat(0)
            }, completion: nil)
        }
        
        closeDetails.alpha = 1
        
        let province = (viewModel?.selectedShop.value?.city)!+" "+(viewModel?.selectedShop.value?.state)!
        
        shopName?.text = viewModel?.selectedShop.value?.shopName
        shopAddress?.text = viewModel?.selectedShop.value?.address1
        shopCity.text = province+" "+(viewModel?.selectedShop.value?.zipCode)!
        shopPhone.setTitle(viewModel?.selectedShop.value?.phoneNumber, for: .normal)
        shopPhone.addTarget(self, action: #selector(ShopFinderController.phoneAction), for: .touchUpInside)
        
        shopDirections.addTarget(self, action: #selector(ShopFinderController.directionsAction), for: .touchUpInside)

        shopHoursSitIn.text = ""
        shopTimeSitIn.text = ""
        
        let hoursDineIn = viewModel?.selectedShop.value?.hoursDineIn as! [KKShopsResponse_item_hoursDineIn_item]?
        if (hoursDineIn != nil) {
            for hours in hoursDineIn! {
                shopHoursSitIn.text = shopHoursSitIn.text! + hours.key! + "\n\n"
                shopTimeSitIn.text = shopTimeSitIn.text! + hours.value! + "\n\n"
            }
            shopHoursSitIn.text = String(shopHoursSitIn.text!.dropLast())
            shopTimeSitIn.text = String(shopTimeSitIn.text!.dropLast())
        }
        
        shopHoursPullUp.text = ""
        shopTimePullUp.text = ""
        let hoursDriveThru = viewModel?.selectedShop.value?.hoursDriveThru as! [KKShopsResponse_item_hoursDriveThru_item]?
        if (hoursDriveThru != nil) {
            for hours in hoursDriveThru! {
                shopHoursPullUp.text = shopHoursPullUp.text! + hours.key! + "\n\n"
                shopTimePullUp.text = shopTimePullUp.text! + hours.value! + "\n\n"
            }
            shopHoursPullUp.text = String(shopHoursPullUp.text!.dropLast())
            shopTimePullUp.text = String(shopTimePullUp.text!.dropLast())
        }
        
        hotLightLabel.isHidden = !((viewModel?.authentication.value.isAuthorized)!)
        hotLightToggle.isHidden = !((viewModel?.authentication.value.isAuthorized)!)
        hotLightToggle.isOn = viewModel?.getSelectedShopNotification() ?? false
        
        if (viewModel?.selectedShop.value?.hotLightOn == 1) {
            hotlightButton.setImage(UIImage(named: "ic_hotlight"), for: UIControlState())
        } else {
            hotlightButton.setImage(UIImage(named: "ic_coldlight"), for: UIControlState())
        }
        hotlightButton.addTarget(self, action: #selector(ShopFinderController.hotlightAction(_:)), for: .touchUpInside)
        
        if (viewModel?.selectedShop.value?.isFavorite)! {
            likeButton.setImage(UIImage(named: "ic_heart_full"), for: UIControlState())
        } else {
            likeButton.setImage(UIImage(named: "ic_heart_empty"), for: UIControlState())
        }
        likeButton.addTarget(self, action: #selector(ShopFinderController.toggleLike(_:)), for:.touchUpInside)
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.detailsVerticleConstraint.constant = self.tableViewHeader.frame.size.height
            self.view.layoutIfNeeded()
        })
        
        self.map.zoomMapFitAnnotation((viewModel?.selectedShop.value?.shopId)!)
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.updateScrollViewOffset(scrollView)
        
        let offset : CGFloat = scrollView.contentOffset.y
        if (offset > 16) {
            locationButton.isHidden = true
        } else {
            locationButton.isHidden = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel?.shops.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectedShop.value = self.viewModel?.shops[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! LocationCell
        let shop = self.viewModel?.shops[indexPath.row]
        let province = (shop?.city ?? "") + " " + (shop?.state ?? "")
        
        cell.headerViewHeight.constant = 0
        if (indexPath.row == 0) {
            if (shop?.isFavorite ?? false) {
                cell.headerViewHeight.constant = 26
                cell.headerLabel.text = "FAVORITE"
                cell.headerLabel.adjust(characterSpacing: 1, lineHeight: 24)
            } else {
                cell.headerViewHeight.constant = 26
                cell.headerLabel.text = "NEAR ME"
                cell.headerLabel.adjust(characterSpacing: 1, lineHeight: 24)
            }
        } else if (indexPath.row == 1) {
            if (viewModel?.shops[0].isFavorite)! {
                cell.headerViewHeight.constant = 26
                cell.headerLabel.text = "NEAR ME"
                cell.headerLabel.adjust(characterSpacing: 1, lineHeight: 24)
            }
        }
        
        cell.openHours?.text = shop?.hoursDescriptionDineIn
        cell.driveThruHours?.text = shop?.hoursDescriptionDriveThru
        cell.storeName?.text = shop?.shopName
        cell.address?.text = shop?.address1
        cell.province?.text = province + " " + (shop?.zipCode ?? "")
        cell.distance?.text = String(round(100.0 * (shop?.distance?.doubleValue)!) / 100.0) + " Miles"
        
        if (shop?.hotLightOn == 1) {
            cell.hotlight.setImage(UIImage(named: "ic_hotlight"), for: UIControlState())
        } else {
            cell.hotlight.setImage(UIImage(named: "ic_coldlight"), for: UIControlState())
        }
        cell.hotlight.addTarget(self, action: #selector(ShopFinderController.hotlightAction(_:)), for: .touchUpInside)
        
        if (shop?.isFavorite)! {
            cell.toggleLikeBtn.setImage(UIImage(named: "ic_heart_full"), for: UIControlState())
        } else {
            cell.toggleLikeBtn.setImage(UIImage(named: "ic_heart_empty"), for: UIControlState())
        }
        if (viewModel?.authentication.value.isAuthorized)! {
            cell.toggleLikeBtnWidth.constant = 40
            cell.toggleLikeBtn.addTarget(self, action: #selector(ShopFinderController.toggleLike(_:)), for:.touchUpInside)
        } else {
            cell.toggleLikeBtnWidth.constant = 0
        }
        
        return cell
    }
    
    @objc func hotlightAction(_ sender: UIButton) {
        // TODO: this is hacky - move to delegate/coordinator
        let storyboard = UIStoryboard(name: "ShopFinder", bundle: nil)
        let hotlightViewController = storyboard.instantiateViewController(withIdentifier: "hotlightController")
        self.navigationController?.pushViewController(hotlightViewController, animated: true)
    }
    
    @objc func toggleLike(_ sender: UIButton){
        var shop = self.viewModel?.selectedShop.value
        if (sender.superview?.superview?.superview is UITableViewCell) {
            let cell = sender.superview?.superview?.superview as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            shop = self.viewModel?.shops[(indexPath?.row)!]
        }
        (UIApplication.shared.delegate as! AppDelegate).fsn = shop?.shopName
        if (shop?.isFavorite)! {
            
            viewModel?.updateFavoriteShop(shopId: shop?.shopId, favorite: false)
            if let image = UIImage(named: "ic_heart_empty") {
                sender.setImage(image, for: .normal)
            }
        } else {
            viewModel?.updateFavoriteShop(shopId: shop?.shopId, favorite: true)
            if let image = UIImage(named: "ic_heart_full") {
                sender.setImage(image, for: .normal)
            }
        }
        
        tableView.reloadData()
    }
}

