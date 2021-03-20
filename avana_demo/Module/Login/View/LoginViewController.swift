//
//  ViewController.swift
//  avana_demo
//
//  Created by Iglo-macpro on 19/03/21.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setLoginButton()
    }
    
    private func setLoginButton(){
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        
        if let token = AccessToken.current, !token.isExpired {
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
            request.start(completionHandler: {connection, result, error in
                self.setNewController()
                self.firebaseLogin(accessToken: token)

            })
        }
    }
    
    private func setNewController(){
        let viewController = UINavigationController(rootViewController: HomeViewController())
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start(completionHandler: {connection, result, error in
            if result != nil {
                self.setNewController()
                self.firebaseLogin(accessToken: token ?? "")
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
    func firebaseLogin(accessToken: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential, completion: { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            print(authResult)
            if let user = Auth.auth().currentUser {
                print(user)
            }
        })
    }
    
}
