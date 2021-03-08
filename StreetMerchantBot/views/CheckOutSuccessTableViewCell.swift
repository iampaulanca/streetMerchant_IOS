//
//  CheckOutSuccessTableViewCell.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/4/21.
//

protocol CheckOutSuccessTableViewDelegate: class {
    func gotoURL(_ url: String)
    func gotoURLCart(_ urlCart: String)
}

import UIKit

class CheckOutSuccessTableViewCell: UITableViewCell {
    
    weak var delegate: CheckOutSuccessTableViewDelegate?

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var storeButton: UIButton!
    
    @IBOutlet weak var urlButton: UIButton!
    
    @IBOutlet weak var urlCartButton: UIButton!
    
    @IBAction func urlButtonAction(_ sender: Any) {
        delegate?.gotoURL(urlButton.titleLabel?.text ?? "Error")
    }
    
    @IBAction func urlCartButtonAction(_ sender: Any) {
        delegate?.gotoURLCart(urlCartButton.titleLabel?.text ?? "Error")
    }
    
}
