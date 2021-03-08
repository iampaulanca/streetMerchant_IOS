//
//  ViewController.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/2/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    
    var urls = [["google",
                 "https://www.google.com",
                 "https://www.google.com"],
                ["amazon",
                 "https://www.amazon.com",
                 "https://www.amazon.com"],
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
}

// TableView delegate/datasource functions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Swipe to delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            urls.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutCell") as! CheckOutSuccessTableViewCell
        
        cell.delegate = self
        
        cell.itemImageView.image = UIImage(named: "greencheckmark")
        
        cell.storeButton.setTitle(urls[indexPath.row][0], for: .normal)
        cell.storeButton.sizeToFit()
        
        cell.urlButton.setTitle(urls[indexPath.row][1], for: .normal)
        cell.urlButton.contentHorizontalAlignment = .left
        cell.urlButton.titleLabel?.lineBreakMode = .byTruncatingTail
        
        cell.urlCartButton.setTitle(urls[indexPath.row][2], for: .normal)
        cell.urlCartButton.contentHorizontalAlignment = .left
        cell.urlCartButton.titleLabel?.lineBreakMode = .byTruncatingTail
    
        return cell
    }
    
}

// CheckOutSuccessTableViewDelegate functions
extension ViewController: CheckOutSuccessTableViewDelegate {
    
    // Opens a WebViewController from current vc
    func openWebView(url: URL) {
        let webViewController = WebViewController(url: url)
        self.present(webViewController, animated: true, completion: nil)
    }
    
    // CheckOutSuccessTableViewDelegate functions
    func gotoURL(_ url: String) {
        guard let _url = URL(string: url) else { return }
        openWebView(url: _url)
    }
    func gotoURLCart(_ urlCart: String) {
        guard let _urlCart = URL(string: urlCart) else { return }
        openWebView(url: _urlCart)
    }
}
