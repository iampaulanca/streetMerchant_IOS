//
//  ViewController.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/2/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    
    @IBAction func killButtonAction(_ sender: Any) {
        
        let url = URL(string: Constants.shared.hostKillScript)!
        var request = URLRequest(url: url)
        request.addValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "x-access-token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
    
    
    @IBAction func searchModelButtonAction(_ sender: Any) {
        
        
    }
    var urls = [["google",
                 "https://www.google.com",
                 "https://www.google.com"],
                ["amazon",
                 "https://www.amazon.com",
                 "https://www.amazon.com"],
                ["bestbuy",
                 "www.somethingsuperlong.com",
                 "www.bestbuy.com"]]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToDetailVC") {
            
            let detailVC = segue.destination as! DetailViewController
            detailVC.brand = "brand"
            detailVC.urlCart = "cart"
            detailVC.url = "url"
            detailVC.model = "model"
            detailVC.maxPrice = "maxPirce"
            detailVC.timestamp = Date().description
            detailVC.store = "store"
        }
    }
}

// TableView delegate/datasource functions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.performSegue(withIdentifier: "segueToDetailVC", sender: cell)
//        self.performSegue(withIdentifier: "segueToDetailVC", sender: cell)
    }
    
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
        cell.urlButton.sizeToFit()
        
        cell.urlCartButton.setTitle(urls[indexPath.row][2], for: .normal)
        cell.urlCartButton.contentHorizontalAlignment = .left
        cell.urlCartButton.titleLabel?.lineBreakMode = .byTruncatingTail
        cell.urlCartButton.sizeToFit()
    
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
