//
//  NavigationController.swift
//  Mvvm
//
//  Created by Sean Davis on 12/6/17.
//  Copymain © 2017 Sean Davis. All mains reserved.
//
import UIKit

protocol BaseNavigationViewControllerDelegate: class {
    func home(viewController: UIViewController)
    func signUp(viewController: UIViewController)
    func findAShop(viewController: UIViewController)
    func messages(viewController: UIViewController)
    func myAcccount(viewController: UIViewController)
}

class BaseNavigationViewController: UIViewController {
    
    weak var baseNavigationCoordinator : BaseNavigationViewControllerDelegate?
    
    var navContainer:PassThroughView!
    var menuButtonContainer:UIImageView!
    var menuButton:UIButton!
    var mainButton:UIButton!
    
    var menuButtonLeadingConstraint = NSLayoutConstraint()
    var sideMenuAnimator:SideMenuAnimator?
    var sideMenu:SideMenuViewController!
    
    var currentMainButtonTag: Int = 0 {
        didSet {
            if let mainButton = mainButton {
                mainButton.tag = currentMainButtonTag
                
                let attributedString = NSMutableAttributedString(string: NavigationButtonTag.NavigationButtonTitleText[currentMainButtonTag])
                attributedString.addAttribute(.kern, value: CGFloat(1.0), range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedString.length))
                mainButton.setAttributedTitle(attributedString, for: .normal)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func setupUI() {
        setupNavContainer()
        setupMenuButton()
    }
    
    public func setupNavContainer() {
        if navContainer == nil {
            navContainer = PassThroughView()
            navContainer.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(navContainer)
        }
        print(navContainer.superview, "superview")
        navContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        navContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navContainer.heightAnchor.constraint(equalToConstant: 170.0).isActive = true
    }
    
    public func setupMainButton() {
        if mainButton == nil {
            mainButton = RedButton()
            mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
            mainButton.translatesAutoresizingMaskIntoConstraints = false
            navContainer.addSubview(mainButton)
        }
    
        mainButton.leadingAnchor.constraint(equalTo: navContainer.leadingAnchor, constant: 66.0).isActive = true
        mainButton.trailingAnchor.constraint(equalTo: navContainer.trailingAnchor, constant: -16.0).isActive = true
        mainButton.bottomAnchor.constraint(equalTo: navContainer.bottomAnchor, constant:-42.0).isActive = true
    }
    
    public func setupMenuButton() {
        
        if menuButtonContainer == nil{
            menuButtonContainer = SideMenuAnimator.sharedInstance.redTabContainer
            navContainer.addSubview(menuButtonContainer)
            menuButtonContainer.tag = 999
        }
        print(menuButtonContainer.superview, "superview")
        menuButtonContainer.leadingAnchor.constraint(equalTo: navContainer.leadingAnchor, constant: -2).isActive = true
        menuButtonContainer.topAnchor.constraint(equalTo: navContainer.topAnchor).isActive = true
        menuButtonContainer.bottomAnchor.constraint(equalTo: navContainer.bottomAnchor).isActive = true
        menuButtonContainer.widthAnchor.constraint(equalToConstant: 185.0).isActive = true
        
        
        if menuButton == nil {
            menuButton = UIButton()
            menuButton.addTarget(self, action: #selector(animateNavigation), for: .touchDown)
            menuButton.translatesAutoresizingMaskIntoConstraints = false
            navContainer.addSubview(menuButton)
        }
        
        menuButtonLeadingConstraint = self.menuButtonContainer.leadingAnchor.constraint(equalTo: self.menuButtonContainer.leadingAnchor)
        menuButtonLeadingConstraint.isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        menuButton.topAnchor.constraint(equalTo: menuButtonContainer.topAnchor, constant: 72.0).isActive = true
        menuButton.setImage(UIImage(named: "Side Nav Icon"), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFill
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button events
    
    @objc func animateNavigation() {
        sideMenuAnimator = SideMenuAnimator.sharedInstance
        sideMenuAnimator?.baseViewController = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let menu = (UIApplication.shared.delegate as! AppDelegate).authentication.value.isAuthorized ? "authenticatedSideMenu" : "guestSideMenu"
        let sideMenu = storyboard.instantiateViewController(withIdentifier: menu) as! SideMenuViewController
        sideMenu.baseNavigationCoordinator = baseNavigationCoordinator
        sideMenu.transitioningDelegate = sideMenuAnimator
        present(sideMenu, animated: true, completion: nil)
    }
    
    @objc func mainButtonTapped()
    {
        switch(mainButton.tag) {
        case NavigationButtonTag.signUpForRewards:
            baseNavigationCoordinator?.signUp(viewController: self)
        case NavigationButtonTag.myRewards:
            /*
            let storyboard = UIStoryboard(name: "RewardsStoryboard", bundle: nil)
            
            if let rewardsController = storyboard.instantiateViewController(withIdentifier: "rewards") as? RewardsViewController {
                navigationController?.pushViewController(rewardsController, animated: true)
            }*/
            break
        /*case NavigationButtonTag.rewardsProgress:
            
            let storyboard = UIStoryboard(name: "RewardsStoryboard", bundle: nil)
            
            if let rewardsProgressController = storyboard.instantiateViewController(withIdentifier: "rewardsProgress") as? RewardsProgressViewController {
                
                let rewardsService = TestRewardsService()
                let rewards = rewardsService.GetRewards(forUser: "me")
                rewardsProgressController.rewards = rewards
                navigationController?.pushViewController(rewardsProgressController, animated: true)
            }
            break*/
        default:
            return
        }
    }
}
