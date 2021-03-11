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
    
    @objc func buttonAction(sender: UIButton!) {
        for (key, value) in self.configDic {
            print(key, value)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.getConfig()
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
                
                y_coordinate += labelHeight
                
                self.configScrollView.addSubview(label)
                self.configScrollView.addSubview(textField)
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
    
    func getConfig() {
        let url = URL(string: "http://localhost:5000/getConfig")!
        let request = URLRequest(url: url)
        
        URLSession(configuration: .default).dataTask(with: request) { (data,response,error) in
            if error != nil {
                print("error occurred, \(error.debugDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let configDict = try JSONSerialization.jsonObject(with: data, options: [])
                let sorted = (configDict as! [String: String]).sorted(by: { $0.key < $1.key })
                for sortedDict in sorted {
                    self.configDic[sortedDict.key] = sortedDict.value
                }
                self.setupScrollView()
            } catch {
                print("some error happened")
            }
        }.resume()
    }
    
}
