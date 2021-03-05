//
//  ViewController.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/2/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let urls = [["google",
                 "www.somethingsuperlongurlhreaereahreha.com",
                 "www.google.com"],
                ["amazon",
                 "www.amazon.com",
                 "www.amazon.com"],
                ["bestbuy",
                 "www.bestbuy.com",
                 "www.bestbuy.com"]]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        self.view.backgroundColor = .blue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutCell") as! CheckOutSuccessTableViewCell
        
        cell.itemImageView.image = UIImage(named: "gpu_image.jpg")
        
        cell.storeButton.setTitle(urls[indexPath.row][0], for: .normal)
        cell.storeButton.sizeToFit()
        
        cell.urlButton.setTitle(urls[indexPath.row][1], for: .normal)
        cell.urlButton.contentHorizontalAlignment = .left
        cell.urlButton.titleLabel?.lineBreakMode = .byTruncatingTail
        
        
        cell.urlCartButton.setTitle(urls[indexPath.row][2], for: .normal)
        cell.urlCartButton.sizeToFit()
        
        print(cell.self)
        return cell
        
//        let cell = UITableViewCell()
//        cell.textLabel?.text = "hello"
//        return cell
    }

}

