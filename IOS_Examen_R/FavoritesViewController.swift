//
//  FavoritesViewController.swift
//  IOS_Examen_R
//
//  Created by ben romdhane fedi on 2024-01-15.
//

import UIKit
import CoreData
class FavoritesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var products = [(name: String, price: Int)]()

    
    // OUTLET________________
    
//    @IBAction func deleteReservation(_ sender: UIButton, didSelectItemAt indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Success", message: "Do you really want to delete this Reservation ", preferredStyle: .alert)
//                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
//                       action in
//                       self.deleteItems(index: indexPath)
//
//                   }))
//            self.present(alert, animated: true)
//    }
    
    
    @IBOutlet weak var mCollectionViewoutlet: UICollectionView!
    
    
    
    
    //ACtion__________________
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycellule", for: indexPath)
        let cv = cell.contentView

        if let imageView = cv.viewWithTag(1) as? UIImageView,
           let price = cv.viewWithTag(2) as? UILabel,
           let destination = cv.viewWithTag(3) as? UILabel{
            let product = products[indexPath.row]
            let priceCore = product.price

            imageView.image = UIImage(named: product.name)
            print(product.price)
            price.text = String(priceCore)
            destination.text = String(product.name)
         }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "delete", message: "Do you really want to delete this Reservation ", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Supprimer", style: .destructive, handler: {
                       action in
                       self.deleteItems(index: indexPath)

                   }))
            self.present(alert, animated: true)
    }

    func deleteItems(index: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reservation")
        let predicate = NSPredicate(format: "name = %@", products[index.row].name)
        request.predicate = predicate

        do {
            let result = try managedContext.fetch(request)
            if let obj = result.first as? NSManagedObject {
                managedContext.delete(obj)
                try managedContext.save() 
                fetchProducts()
            }
        } catch {
            print("Delete error: \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            fetchProducts()
            print(products)

        // Do any additional setup after loading the view.
    }
    
// CORE DATA CONFIGURATION
    func fetchProducts() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reservation")

        do {
            let result = try managedContext.fetch(request)

             products.removeAll()

            for case let item as NSManagedObject in result {
                if let name = item.value(forKey: "name") as? String,
                   let price = item.value(forKey: "price") as? Int
                    {
                    products.append((name: name, price: price))
                }
            }

            mCollectionViewoutlet.reloadData()
 
        } catch {
            print("Error fetching products: \(error)")
        }
    }
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
