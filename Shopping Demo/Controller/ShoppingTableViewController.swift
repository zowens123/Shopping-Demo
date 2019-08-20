//
//  ShoppingTableViewController.swift
//  Shopping Demo
//
//  Created by Zach Owens on 6/27/19.
//  Copyright © 2019 Zach Owens. All rights reserved.
//

import UIKit
import os.log
import Leanplum

class ShoppingTableViewController: UITableViewController {
    
    var delegate: ShoppingDelegate?
    var cart: MyCart?
    var products = [Product]()
    
    let itemPhoto1 = UIImage(named: "49ers")
    let itemPhoto2 = UIImage(named: "golfclubs")
    let itemPhoto3 = UIImage(named: "shoe")
    let itemPhoto4 = UIImage(named: "tennis")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        products = [Product(itemName: "Team Shirt", itemPrice: 19.99, itemPhoto: itemPhoto1),Product(itemName: "Golf Clubs", itemPrice: 149.99, itemPhoto: itemPhoto2!),Product(itemName: "Basketballs", itemPrice: 89.99, itemPhoto: itemPhoto3!),Product(itemName: "Tennis Racket", itemPrice: 49.99, itemPhoto: itemPhoto4!)]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let refuseId = "ProductTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: refuseId, for: indexPath) as! ProductTableViewCell
        
        let item = products[indexPath.row]

        cell.delegate = self
        cell.nameLabel.text = item.itemName
        cell.photoLabel.image = item.itemPhoto
        cell.priceLabel.text = "$\(String(describing: item.itemPrice))"
        
        cell.addToCart((Any).self)

        return cell
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // Preparing data before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showCart" {
            
            if let destinationController = segue.destination as? CartTableViewController {
                    destinationController.cartTransfer = cart
            }
        }
    }
 
}

extension ShoppingTableViewController: ShoppingDelegate {
    
    func addtocart(product: ProductTableViewCell) {
        guard let indexPath = tableView.indexPath(for: product) else {return}
        let cartItem = products[indexPath.row]
        Leanplum.track("addToCart")
        cart?.addtocart(product: cartItem)
        //cart?.total 
    }

        
}

