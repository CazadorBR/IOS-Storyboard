//
//  DetailViewController.swift
//  PlanB
//
// Created by fedi ben romdhane  on 14/1/2024.
//
import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    // Existing properties
    var ProductTitile: String?
    var ProductPrice: Double?
    var finalQuantite: Int = 0
    
    // Outlets
    @IBOutlet weak var ProductImageUI: UIImageView!
    @IBOutlet weak var ProductPriceUI: UILabel!
    @IBOutlet weak var quantiteStepper: UIStepper!
    @IBOutlet weak var labelQuant: UILabel!
    
    // Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProductImageUI.image = UIImage(named: ProductTitile!)
        ProductPriceUI.text = String(ProductPrice!)
        
        // Load the existing quantity if the product already exists in the cart
        if let existingQuantity = loadQuantity() {
            finalQuantite = existingQuantity
            quantiteStepper.value = Double(existingQuantity)
            labelQuant.text = String(existingQuantity)
        }
    }
    
    // Core Data Methods
    
    func addCart() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)
        let object = NSManagedObject(entity: entityDescription!, insertInto: managedContext)
        
        object.setValue(ProductTitile, forKey: "nom")
        object.setValue(ProductPrice, forKey: "price")
        object.setValue(finalQuantite, forKey: "quantity") // Set the quantity as an Int
        
        do {
            try managedContext.save()
            self.alert(title: "Success", message: "Product added")
        } catch {
            print("Error adding object: \(error)")
        }
    }
    
    func loadQuantity() -> Int? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Product")
        let predicate = NSPredicate(format: "nom = %@", ProductTitile!)
        request.predicate = predicate
        
        do {
            let result = try managedContext.fetch(request)
            if let product = result.first, let quantity = product.value(forKey: "quantity") as? Int {
                return quantity
            }
        } catch {
            print("Error fetching product quantity: \(error)")
        }
        
        return nil
    }
    
    // Actions
    
    @IBAction func click(_ sender: Any) {
        finalQuantite = Int(quantiteStepper.value)
        labelQuant.text = String(finalQuantite)
    }
    
    @IBAction func Addtoshop(_ sender: Any) {
        if !ifExist() {
            addCart()
        } else {
            self.alert(title: "Warning", message: "Product already exists")
        }
    }
    
    // Other methods
    
    func ifExist() -> Bool {
        var mBolean = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Product")
        let predicate = NSPredicate(format: "nom = %@", ProductTitile!)
        request.predicate = predicate
        
        do {
            let result = try managedContext.fetch(request)
            if (result.count > 0)  {
                mBolean = true
            }
        } catch {
            print("Error adding object")
        }
        return mBolean
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
