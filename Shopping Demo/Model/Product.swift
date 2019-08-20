//
//  Product.swift
//  Shopping Demo
//
//  Created by Zach Owens on 6/28/19.
//  Copyright © 2019 Zach Owens. All rights reserved.
//

import UIKit
import os.log

struct Product: Equatable {
    
    //Properties
    var itemName: String
    var itemPrice: Float
    var itemPhoto: UIImage?

    //mark: equatable
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.itemName == rhs.itemName && lhs.itemPhoto == rhs.itemPhoto && lhs.itemPrice == rhs.itemPrice
    }
}


