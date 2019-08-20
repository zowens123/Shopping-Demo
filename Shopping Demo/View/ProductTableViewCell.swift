//
//  ProductTableViewCell.swift
//  Shopping Demo
//
//  Created by Zach Owens on 6/28/19.
//  Copyright © 2019 Zach Owens. All rights reserved.
//

import UIKit

protocol ShoppingDelegate {
    func addtocart(product: ProductTableViewCell)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var photoLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!

    var delegate: ShoppingDelegate?
    var transfer: CartTransfer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToCart(_ sender: Any) {
        self.delegate?.addtocart(product: self)
    }
    
}
