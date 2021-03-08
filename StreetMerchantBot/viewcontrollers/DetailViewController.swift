//
//  DetailViewController.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/8/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var cartUrlLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var url: String?
    var urlCart: String?
    var brand: String?
    var model: String?
    var maxPrice: String?
    var store: String?
    var timestamp: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    func setupLabels(){
        urlLabel.text = url
        cartUrlLabel.text = urlCart
        brandLabel.text = brand
        modelLabel.text = model
        maxPriceLabel.text = maxPrice
        storeLabel.text = store
        timeStampLabel.text = timestamp
    }

}
