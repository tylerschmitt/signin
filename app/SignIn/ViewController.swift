//
//  ViewController.swift
//  SignIn
//
//  Created by Tyler Schmitt on 6/6/18.
//  Copyright © 2018 Tyler Schmitt. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController
{
    //MARK: Constants
    let URL_REGISTER_USER = "https://localhost:8080/register"
    let SALT_LENGTH = 8
    
    var allFieldsValid : Bool?
    {
        didSet
        {
            if (registerButton != nil)
            {
                if (allFieldsValid!)
                {
                    registerButton.isEnabled = true
                }
                else
                {
                    registerButton.isEnabled = false
                }
            }
        }
    }
    
    //MARK: Properties
    @IBOutlet var email: UITextField!{
        didSet{
            allFieldsValid = validateUserInfo()
        }
    }
    
    @IBOutlet var passwordPlainText: UITextField!{
        didSet{
            allFieldsValid = validateUserInfo()
        }
    }
    
    @IBOutlet var name: UITextField!{
        didSet{
            allFieldsValid = validateUserInfo()
        }
    }
    
    @IBOutlet var registerButton: UIButton!
    
    //MARK: Functions
    //Registration action that occurs on the register button click.
    @IBAction private func register(_ sender: UIButton)
    {
        let password: Array<UInt8> = Array(passwordPlainText.text!.utf8)
        let salt: Array<UInt8> = getSalt()
        do{
            //Get password hash
            let passwordHash = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, variant: .sha256).calculate().toHexString()
            
            //Send username and password to server/database
            sendJsonToServer(email: name.text!, passwordHash: passwordHash,
                             salt: salt.toHexString(), name: name.text!)
        }
        catch{
            print("Error: Hashing password.")
        }
    }
    
    //Send a JSON object to the server.
    private func sendJsonToServer(email : String, passwordHash : String, salt : String, name : String)
    {
        // prepare json data
        let json = ["email": email,
                    "password": passwordHash,
                    "name": name,
                    "salt": salt]

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
    
    //Validation function for all user info.
    private func validateUserInfo() -> Bool
    {
        return true
    }
    
    //Validates password.
    private func validatePassword() -> Bool
    {
        var valid = false
        
        return valid
    }
    
    //MARK: Helpers
    private func getSalt() -> Array<UInt8>
    {
        var saltBytes : Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8]
        /*for _ in 0...SALT_LENGTH
        {
            let randomNumber = UInt8(arc4random_uniform(UInt32.max))
            
            saltBytes.append(randomNumber)
        }*/
        
        
        return saltBytes
    }
}






























