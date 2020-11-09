
//
//  AuthCoordinator.swift
//  Mobile
//
//  Created by Sagepath on 1/16/18.
//  Copyright © 2018 Krispy Kreme. All rights reserved.
//

import Foundation
import UIKit

protocol AuthCoordinatorDelegate: class {
    func authComplete(authCoordinator: AuthCoordinator)
}

//BASE COORDINATOR
//---------------------------
class AuthCoordinator: BaseCoordinator {
    
    weak var coordinator: AuthCoordinatorDelegate?
    
    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
    let splashFadeAnimator = SplashFadeAnimator()
    let slideFadeAnimator = SlideFadeAnimator()
    
    let signInViewModel = SignInViewModel()
    
    override func start() {
        
        let email = UserDefaults.standard.string(forKey: "email")
        let password = UserDefaults.standard.string(forKey: "password")
        let _ = SideMenuAnimator.sharedInstance.loadMenuTabs {
            if email != nil && password != nil{
                self.signInViewModel.client = KKAPIClient.default()
                self.signInViewModel.email.value = email
                self.signInViewModel.password.value = password
                _ = self.signInViewModel.authentication.observeNext { value in
                    if (value.isAuthorized) {
                        DispatchQueue.main.async {
                            self.coordinator?.authComplete(authCoordinator: self)
                        }
                    }
                }
                
                self.signInViewModel.signIn()
            } else {
                let signInOptionsController = self.storyboard.instantiateInitialViewController() as! SignInOptionsViewController
                signInOptionsController.coordinator = self
                
                self.navigationController.delegate = self.splashFadeAnimator
                self.navigationController.pushViewController(signInOptionsController, animated: true)
            }
        }
    }
    
    func signUp() {
        let signInOptionsController = self.storyboard.instantiateInitialViewController() as! SignInOptionsViewController
        signInOptionsController.coordinator = self
        
        self.navigationController.delegate = self.slideFadeAnimator
        self.navigationController.pushViewController(signInOptionsController, animated: false)
        
        self.createAccount(signInOptionsViewController: signInOptionsController)
    }
}

//SIGNIN OPTIONS COORDINATOR
//--------------------------
extension AuthCoordinator: SignInOptionsViewControllerDelegate {
    func signIn(signInOptionsViewController: SignInOptionsViewController) {
        let signInViewModel = SignInViewModel()
        signInViewModel.client = KKAPIClient.default()
        
        let signInController = storyboard.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
        signInController.coordinator = self
        signInController.viewModel = signInViewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(signInController, animated: true)
    }
    
    func createAccount(signInOptionsViewController: SignInOptionsViewController) {
        let createAccountViewModel = CreateAccountViewModel()
        createAccountViewModel.client = KKAPIClient.default()
        
        let createAccount1ViewController = storyboard.instantiateViewController(withIdentifier: "CreateAccount1") as! CreateAccount1ViewController
        createAccount1ViewController.coordinator = self
        createAccount1ViewController.viewModel = createAccountViewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(createAccount1ViewController, animated: true)
    }
    
    func continueAsGuest(signInOptionsViewController: SignInOptionsViewController) {
        self.coordinator?.authComplete(authCoordinator: self)
    }
}

//SIGNIN COORDINATOR
//------------------
extension AuthCoordinator: SignInViewControllerDelegate {
    func signIn(signInViewController: SignInViewController) {
        self.coordinator?.authComplete(authCoordinator: self)
    }
    
    func signInWithFacebook(signInViewController: SignInViewController) {
        self.coordinator?.authComplete(authCoordinator: self)
    }
    
    func forgotPassword(signInViewController: SignInViewController) {
        let forgotPasswordViewModel = ForgotPasswordViewModel()
        forgotPasswordViewModel.client = KKAPIClient.default()
        forgotPasswordViewModel.email.value = signInViewController.viewModel?.email.value
        
        let forgotPasswordController = storyboard.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPasswordViewController
        forgotPasswordController.coordinator = self
        forgotPasswordController.viewModel = forgotPasswordViewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(forgotPasswordController, animated: true)
    }
    
    func goBack(signInViewController: SignInViewController) {
        self.navigationController.popViewController(animated: true)
    }
}

//CREATE ACCOUNT 1 COORDINATOR
//-------------------
extension AuthCoordinator: CreateAccount1ViewControllerDelegate {
    
    func next(createAccount1ViewController: CreateAccount1ViewController) {
        let createAccount2Controller = storyboard.instantiateViewController(withIdentifier: "CreateAccount2") as! CreateAccount2ViewController
        createAccount2Controller.coordinator = self
        createAccount2Controller.viewModel = createAccount1ViewController.viewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(createAccount2Controller, animated: true)
    }
    
    func goBack(createAccount1ViewController: CreateAccount1ViewController) {
        self.navigationController.popViewController(animated: true)
    }
}

//CREATE ACCOUNT 2 COORDINATOR
//-------------------
extension AuthCoordinator: CreateAccount2ViewControllerDelegate {
    
    func next(createAccount2ViewController: CreateAccount2ViewController) {
        let createAccount3Controller = storyboard.instantiateViewController(withIdentifier: "CreateAccount3") as! CreateAccount3ViewController
        createAccount3Controller.coordinator = self
        createAccount3Controller.viewModel = createAccount2ViewController.viewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(createAccount3Controller, animated: true)
    }
    
    func goBack(createAccount2ViewController: CreateAccount2ViewController) {
        self.navigationController.popViewController(animated: true)
    }
}

//CREATE ACCOUNT 3 COORDINATOR
//------------------
extension AuthCoordinator: CreateAccount3ViewControllerDelegate {
    func createAccount(createAccount3ViewController: CreateAccount3ViewController) {
        self.coordinator?.authComplete(authCoordinator: self)
    }
    
    func goBack(createAccount3ViewController: CreateAccount3ViewController) {
        self.navigationController.popViewController(animated: true)
    }
}

//VERIFY CODE COORDINATOR
//-----------------------
extension AuthCoordinator: VerifyCodeViewControllerDelegate {
    func newPassword(verifyCodeViewController: VerifyCodeViewController) {
        let newPasswordController = storyboard.instantiateViewController(withIdentifier: "NewPassword") as! NewPasswordViewController
        newPasswordController.coordinator = self
        newPasswordController.viewModel = verifyCodeViewController.viewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(newPasswordController, animated: true)
    }
    
    func startOver(verifyCodeViewController: VerifyCodeViewController) {
        self.navigationController.popViewController(animated: false)    // forgot password
        self.navigationController.popViewController(animated: false)    // sign in
        self.navigationController.popViewController(animated: true)     // sign in options
        // we could probably just reset the stack and call start() on this coordinator again
    }
    
    func goBack(verifyCodeViewController: VerifyCodeViewController) {
        self.navigationController.popViewController(animated: true)
    }
}

//NEW PASSWORD COORDINATOR
//------------------------
extension AuthCoordinator: NewPasswordViewControllerDelegate {
    func confirm(newPasswordViewController: NewPasswordViewController) {
        self.coordinator?.authComplete(authCoordinator: self)
    }
    
    func goBack(newPasswordViewController: NewPasswordViewController) {
        self.navigationController.popViewController(animated: true)
    }
}

//FORGOT PASSWORD COORDINATOR
//---------------------------
extension AuthCoordinator: ForgotPasswordViewControllerDelegate {
    func sendVerificationCode(forgotPasswordViewController: ForgotPasswordViewController) {
        let verifyCodeController = storyboard.instantiateViewController(withIdentifier:"VerifyCode") as! VerifyCodeViewController
        verifyCodeController.coordinator = self
        verifyCodeController.viewModel = forgotPasswordViewController.viewModel
        
        self.navigationController.delegate = slideFadeAnimator
        self.navigationController.pushViewController(verifyCodeController, animated: true)
    }
    
    func goBack(forgotPasswordViewController: ForgotPasswordViewController) {
        self.navigationController.popViewController(animated: true)
    }
}

