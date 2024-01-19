//
//  ViewController.swift
//  PlanB
//
// Created by fedi ben romdhane  on 14/1/2024.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    var sandwichs = ["Jambon Gruyere", "Emince Poulet Fondant", "Emince Boeuf Fondant", "Kebab Poulet", "Poulet Grille", "Rapido Jambon Fromage", "Rapido Thon", "Thon"]
    var prices = [6.2, 9.5, 7.8, 6.8, 6.8, 3.8, 3.8, 6.8]
 
    
     override func viewDidLoad() {
        super.viewDidLoad()

    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sandwichs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell")
        let cv = cell?.contentView
        let productImg = cv?.viewWithTag(1) as! UIImageView
        let productName = cv?.viewWithTag(2) as! UILabel
        let productPrice = cv?.viewWithTag(3) as! UILabel
        
        productImg.image = UIImage(named: sandwichs[indexPath.row])
        productName.text = sandwichs[indexPath.row]
        let currentValue = Double(productPrice.text ?? "") ?? 0.0
        let updatedValue = currentValue + prices[indexPath.row]
        productPrice.text = String(updatedValue) + " dt"
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "firstSegui", sender: indexPath)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstSegui" {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! DetailViewController
            destination.ProductPrice = Double(Array(prices)[indexPath.row])
            destination.ProductTitile = sandwichs [indexPath.row]
        }
        
        
        
    }
    
    @IBAction func ShopCart(_ sender: Any) {
        performSegue(withIdentifier: "secondSegui", sender: sender)

        
    }
}
