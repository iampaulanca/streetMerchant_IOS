//
//  LoginViewController.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/10/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: RoundTextField!
    @IBOutlet weak var passwordTextField: RoundTextField!
    @IBOutlet weak var submitButton: RoundButton!
    @IBAction func submitButtonAction(_ sender: Any) {
        login { (token) in
            guard let token = token else { return }
            
            if token.token != nil {
                UserDefaults.standard.setValue(token.token, forKey: "token")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueToVC", sender: self)
                }
            } else {
                print(token.error ?? "Error has occured")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    func login(completion: @escaping (Token?)->()) {
        let usernamePassword = "\(userNameTextField.text ?? ""):\(passwordTextField.text ?? "")".data(using: String.Encoding.utf8)!.base64EncodedString()
        let url = URL(string: "http://127.0.0.1:5000/login")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Basic \(String(describing: usernamePassword))", forHTTPHeaderField: "Authorization")

        URLSession(configuration: .default).dataTask(with: request) { (data,response,error) in
            
            if error != nil {
                print("error occurred, \(error.debugDescription)")
                return
            }

            guard let data = data else { return }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }

            do {
                let token = try JSONDecoder().decode(Token.self, from: data)
                completion(token)
            } catch {
                print("Unable to decode token")
                return
            }
        }.resume()
    }
    
}
