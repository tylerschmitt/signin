//
//  ViewController.swift
//  SignIn
//
//  Created by Tyler Schmitt on 6/6/18.
//  Copyright © 2018 Tyler Schmitt. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //allFieldsValid = false
    }
    
    //MARK: Constants
    let URL_REGISTER_USER = "https://localhost:8080/RegisterUser"
    
    var allFieldsValid : Bool?
    {
        didSet
        {
            if (allFieldsValid!)
            {
                registerButton.isEnabled = true
            }
            else
            {
                if (registerButton != nil){
                    registerButton.isEnabled = true
                }
            }
        }
    }
    
    //MARK: Properties
    @IBOutlet var username: UITextField!{
        didSet{
            allFieldsValid = validateUserInfo()
        }
    }
    
    @IBOutlet var passwordPlainText: UITextField!{
        didSet{
            allFieldsValid = validateUserInfo()
        }
    }
    
    @IBOutlet var confirmPasswordPlainText: UITextField!{
        didSet{
            allFieldsValid = validateUserInfo()
        }
    }
    
    @IBOutlet var registerButton: UIButton!
    
    //MARK: Functions
    //Registration action that occurs on the register button click.
    @IBAction private func register(_ sender: UIButton)
    {
        var pass = passwordPlainText.text!
        let password: Array<UInt8> = Array(passwordPlainText.text!.utf8)
        let salt: Array<UInt8> = Array("nacllcan".utf8)
        do{
            //Get password hash
            let passwordHash = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, variant: .sha256).calculate().toHexString()
            
            //Send username and password to server/database
            sendJsonToServer(username: username.text!, passwordHash: passwordHash)
        }
        catch{
            print("Error: Hashing password.")
        }
    }
    
    //Send a JSON object to the server.
    private func sendJsonToServer(username : String, passwordHash : String)
    {
        // prepare json data
        let json = ["username": username,
                     "password": passwordHash]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
        // create post request
        let url = URL(string: URL_REGISTER_USER)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    
        // insert json data to the request
        request.httpBody = jsonData
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
    
    private func validateUserInfo() -> Bool
    {
        if (username == nil || passwordPlainText == nil || confirmPasswordPlainText == nil) || (username.text == nil || passwordPlainText.text == nil || confirmPasswordPlainText.text == nil){
            return false
        }
        if (username.text?.count == 0 || passwordPlainText.text?.count == 0 || confirmPasswordPlainText.text?.count == 0){
            return false
        }
        if !passwordPlainText.text!.elementsEqual(confirmPasswordPlainText.text!) {
            return false
        }
        
        return true
    }
}

