//
//  ModelSeriesViewController.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/16/21.
//

import UIKit

class ModelSeriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSeries()
    }
    
    func getSeries() {
        let url = URL(string: Constants.shared.hostGetModelSeries)!
        var request = URLRequest(url: url)
        request.addValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "x-access-token")
        
        URLSession(configuration: .default).dataTask(with: request) { (data,response,error) in
            
            if error != nil {
                print("error occurred, \(error.debugDescription)")
                return
            }
            
            guard let data = data else { return }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            
        }.resume()
    }

}
