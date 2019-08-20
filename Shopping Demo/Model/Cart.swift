//
//  TransferBus.swift
//  Shopping Demo
//
//  Created by Zach Owens on 7/2/19.
//  Copyright © 2019 Zach Owens. All rights reserved.
//

import UIKit

protocol CartTransfer {
    func addtocart(product: Product)
    
}

protocol CartDataSource {
    func getProducts() -> [Product]
}

protocol CartDataTotal {
    func getTotal() -> Float
}

class MyCart : CartTransfer , CartDataSource, CartDataTotal {
    
    
    var products = [Product]()
    var total:Float = 0.0

    
    func addtocart(product: Product) {
        

        if products.contains(product) {
            return
        }
        else {
            products.append(product)
            print("---added \(product) to cart---")
            total += product.itemPrice
        }
    }

    func getTotal() -> Float {
        return total
    }
    
    func getProducts() -> [Product] {
        return products
    }

}
