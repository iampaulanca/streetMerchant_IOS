//
//  ConfigViewController.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/8/21.
//

import UIKit

class ConfigViewController: UIViewController {
    
    @IBOutlet weak var configScrollView: UIScrollView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    var configDic: [String: String] = [:]
    var configDicTextField: [String: UITextField] = [:]
    
    @objc func buttonAction(sender: UIButton!) {
        updateConfig()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.getConfig()
    }
    
    func getConfig() {
        let url = URL(string: Constants.shared.hostGetConfig)!
        var request = URLRequest(url: url)
        request.addValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "x-access-token")
        
        URLSession(configuration: .default).dataTask(with: request) { (data,response,error) in
            if error != nil {
                print("error occurred, \(error.debugDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let configDict = try JSONSerialization.jsonObject(with: data, options: [])
                let sorted = (configDict as! [String: String]).sorted(by: { $0.key < $1.key })
                if sorted[0].key == "error" {
                    DispatchQueue.main.async {
                        UserDefaults.standard.removeObject(forKey: "token")
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                } else {
                    for sortedDict in sorted {
                        self.configDic[sortedDict.key] = sortedDict.value
                    }
                    self.setupScrollView()
                }
            } catch {
                print("some error happened")
            }
        }.resume()
    }
    func setupScrollView() {
        DispatchQueue.main.async {
            let labelHeight = 25
            let labelWidth = Int(self.view.frame.size.width)/2
            var y_coordinate = 10
            for (key, value) in self.configDic.sorted(by: {$0.key < $1.key}) {
                
                let label = UILabel(frame: CGRect(x: 10, y: y_coordinate, width: labelWidth, height: labelHeight))
                label.textAlignment = .left
                label.text = "\(key)"
                label.font = UIFont(name: label.font.fontName, size: 10)
                
                if key == "SHOW_ONLY_SERIES" {
                   
                    
                } else {
                    let textField = UITextField(frame: CGRect(x: 12+Int(labelWidth), y: y_coordinate, width: Int(self.view.frame.size.width) - labelWidth - 16, height: labelHeight-1))
                    textField.layer.borderColor = UIColor.darkGray.cgColor
                    textField.layer.borderWidth = 1
                    textField.layer.cornerRadius = 5
                    textField.font = UIFont(name: textField.font!.fontName, size: 13)
                    textField.text = value
                    
                    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
                    textField.leftViewMode = .always

                    textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
                    textField.rightViewMode = .always
                    
                    self.configDicTextField[key] = textField
                    y_coordinate += labelHeight
                    
                    self.configScrollView.addSubview(label)
                    self.configScrollView.addSubview(textField)
                }
                
            }
            
            let button = UIButton(frame: CGRect(x: Int(self.view.frame.size.width)/2, y: y_coordinate+15, width: 50, height: 25))
            button.setTitle("Submit", for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.darkGray, for: .highlighted)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            button.titleLabel?.adjustsFontSizeToFitWidth = true

            self.configScrollView.addSubview(button)
            self.contentViewHeight.constant = CGFloat(y_coordinate+50)
        }
    }
    
    func updateConfig() {
        let url = URL(string: Constants.shared.hostUpdateConfig)!

        do {
            var request = URLRequest(url: url)
            request.addValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "x-access-token")
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try JSONSerialization.data(withJSONObject: self.updateConfigHelper(), options: [])
            
            URLSession(configuration: .default).dataTask(with: request) { (data,response,error) in
                if error != nil {
                    print("error occurred, \(error.debugDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let configDict = try JSONSerialization.jsonObject(with: data, options: [])
                    let sorted = (configDict as! [String: String]).sorted(by: { $0.key < $1.key })
                    if sorted[0].key == "error" {
                        DispatchQueue.main.async {
                            UserDefaults.standard.removeObject(forKey: "token")
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        for sortedDict in sorted {
                            self.configDic[sortedDict.key] = sortedDict.value
                        }
                        self.setupScrollView()
                    }
                } catch {
                    print("Error: Could not serialize data to updateConfig. \(error)")
                }
            }.resume()
        } catch {
            print("Error: Could not make request to update config. \(error)")
        }
    }
    // Gets textField's text
    func updateConfigHelper() -> [String:String]{
        var returnDict: [String:String] = [:]
        for (key,textField) in configDicTextField {
            returnDict[key] = textField.text!
        }
        return returnDict
    }
}
