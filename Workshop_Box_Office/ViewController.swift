//
//  ViewController.swift
//  Workshop_Box_Office
//
//  Created by ben romdhane fedi on 2023-09-25.
//

import UIKit

class ViewController: UIViewController  ,UITableViewDelegate , UITableViewDataSource
    {
   
    let filmName = ["El Camino","Extraction","Project Power","Six Underground","Spenser Confidential","The Irishman"]
    
    
    
  
    // TEXT-VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cellule = tableView.dequeueReusableCell(withIdentifier:"mycell")
         let contentView = cellule?.contentView

        let IMAGE = contentView?.viewWithTag(1)as! UIImageView
        let FILM_NAME = contentView?.viewWithTag(2)as! UILabel
        let Button_save = contentView?.viewWithTag(3)as! UIButton
        
        
        FILM_NAME.textColor = UIColor.black
        FILM_NAME.font = UIFont.systemFont(ofSize: 18)
        Button_save.tintColor = UIColor.white
        
        FILM_NAME.text = filmName[indexPath.row]
        IMAGE.image = UIImage(named: filmName[indexPath.row])
        Button_save.setTitle("", for: .selected)
        return cellule!
     }
 

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         print (filmName[indexPath.row])
         let param = filmName[indexPath.row]
         performSegue(withIdentifier: "first", sender:param)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "first" {
        
            let name = sender as! String
//            print(name)
            let destination = segue.destination as! DetailsViewController
            destination.moviename = name

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.black

        
        // Do any additional setup after loading the view.
    }


}

