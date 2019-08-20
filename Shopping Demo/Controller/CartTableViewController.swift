//
//  CartTableViewController.swift
//  Shopping Demo
//
//  Created by Zach Owens on 7/3/19.
//  Copyright © 2019 Zach Owens. All rights reserved.
//

import UIKit
import Leanplum

class CartTableViewController: UITableViewController {

    var cartTransfer: MyCart?
    var total: Float = 0
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        

        let button = purchaseButton
        button?.setTitle("Purchase", for: .normal)
        
        //updatePrice(product: )
        priceLabel.text = "Total $\(String(format: "%.2f", cartTransfer!.total))"
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (cartTransfer?.products.count ?? 0)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell" , for: indexPath) as! CartTableViewCell

        if let cartItem = cartTransfer?.products[indexPath.row] {
            
            cell.itemName.text = cartItem.itemName
            cell.itemPhoto.image = cartItem.itemPhoto
            cell.itemPrice.text = "$\(String(describing: cartItem.itemPrice))"
            
        }
        
        return cell
    }
 
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let cartItem = cartTransfer?.products[indexPath.row]
            cartTransfer?.total -= cartItem!.itemPrice
            cartTransfer?.products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            priceLabel.text = "Total $\(String(format: "%.2f", cartTransfer!.total))"
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        //depending on style of presentation, the view controller will be dismissed in two ways
        let isPresentingController = presentingViewController is UINavigationController
        
        if isPresentingController {
            dismiss(animated: true, completion: nil)
        }
        else {
            print("back button not working")
        }
    }
    
    @IBAction func purchaseBtnPressed(_ sender: Any) {
        
        Leanplum.track("Purchase", withParameters: ["total": cartTransfer?.total as! Float])
        cartTransfer?.products.removeAll()
        cartTransfer?.total = 0.00
        priceLabel.text = "Total $\(String(format: "%.2f", cartTransfer!.total))"
        tableView.reloadData()

    }
        
}
