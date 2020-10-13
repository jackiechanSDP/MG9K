//
//  ViewController.swift
//  MG9K
//
//  Created by Jackie Chan on 10/6/20.
//

import UIKit
import AWSAuthUI
import AWSAuthCore
import AWSMobileClient
//import Amplify

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeAWSMobileClient()
        showSignIn()
        //signOutLocally()
    }
    
    func showSignIn(){
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController
                .presentViewController(with: self.navigationController!,
                                       configuration: nil,
                                       completionHandler: { (provider: AWSSignInProvider, error:
                                                             Error?) in
                                        if error != nil {
                                            print("Error occurred: \(String(describing: error))")
                                        } else {
                                            // Sign In Successful
                                            print("Logged in with provider: \(provider.identityProviderName) with Token:\(provider.token())")
                                        }
                                       })
        }
    }
    
    func initializeAWSMobileClient(){
        AWSMobileClient.default().initialize { (userState, error) in
            
            //self.addUserStateListener() // Register for user state changes
            
            if let userState = userState{
                switch(userState){
                case.signedIn: // is Signed IN
                    print("Logged In")
                    print("Cognito Identity ID (authenticated): \(AWSMobileClient.default().identityId))")

                case.signedOut: // is Signed OUT
                    print("Logged Out")
                    DispatchQueue.main.async {
                       // self.signOutLocally()
                        self.showSignIn()
                }
                case.signedOutUserPoolsTokenInvalid: // UserPools refresh token Invalid
                    print("User Pools refresh token is invalid or expired.")
                    DispatchQueue.main.async {
                        self.showSignIn()
                    }
                case.signedOutFederatedTokensInvalid: // FaceBook or Google refresh token invalid
                    print("Federated refresh token is invalid or expired.")
                    DispatchQueue.main.async {
                        self.showSignIn()
                    }
                default:
                    AWSMobileClient.default().signOut()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    /*
    func signOutLocally() {
        Amplify.Auth.signOut(){ result in
            switch result {
            case.success:
                print("Successfully signed out")
            case.failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }*/






}
    




