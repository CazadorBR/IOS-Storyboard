//
//  ViewController.swift
//  IOS_Examen_R
//
//  Created by ben romdhane fedi on 2024-01-15.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var data = ["Maldives","Dubai","Egypt","Paris","LasVegas"]
    var airport = ["MLE","DBX","CAI","ORY","LAS"]
    var price = [780,450,350,280,710]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
        let cv = cell?.contentView
        let dest_tImg = cv?.viewWithTag(1) as! UIImageView
        let dest_name = cv?.viewWithTag(2) as! UILabel
        let dest_Price = cv?.viewWithTag(3) as! UILabel
        
        dest_tImg.image = UIImage(named: data[indexPath.row])
        dest_name.text = data[indexPath.row]
        dest_Price.text = String(price[indexPath.row])

         
         return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let param = data[indexPath.row]
         performSegue(withIdentifier: "details", sender:param)
        
    }
   

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
        
            let name = sender as! String
             let destination = segue.destination as! detailsController
            destination.PlaceName = name

        }

    }


}

