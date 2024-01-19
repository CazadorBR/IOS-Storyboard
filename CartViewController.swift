import UIKit
import CoreData

class CartViewController: UIViewController, UICollectionViewDataSource {

    // Properties
    var products = [(name: String, price: Double, quantity: Int)]()

    // Outlets
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
        calculateAndDisplayTotal()
    }

    // MARK: - Actions

    @IBAction func stepper(_ sender: UIStepper) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let newQuantity = Int(sender.value)
        updateQuantity(index: indexPath, newQuantity: newQuantity)
    }

    // MARK: - UICollectionViewDataSource Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mItem", for: indexPath)
        let cv = cell.contentView

        if let imageView = cv.viewWithTag(1) as? UIImageView,
           let label = cv.viewWithTag(2) as? UILabel,
           let price = cv.viewWithTag(3) as? UILabel,
           let stepper = cv.viewWithTag(4) as? UIStepper {

            let product = products[indexPath.row]

            imageView.image = UIImage(named: product.name)
            label.text = product.name
            price.text = "Price: \(product.price) * \(product.quantity)"
            stepper.value = Double(product.quantity)
            stepper.tag = indexPath.row // Set the tag to the row index for identifying the stepper
        }

        return cell
    }


    // MARK: - Core Data Methods

    func fetchProducts() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")

        do {
            let result = try managedContext.fetch(request)

            // Clear existing data before appending new data
            products.removeAll()

            for case let item as NSManagedObject in result {
                if let name = item.value(forKey: "nom") as? String,
                   let price = item.value(forKey: "price") as? Double,
                   let quantity = item.value(forKey: "quantity") as? Int {
                    products.append((name: name, price: price, quantity: quantity))
                }
            }

            mCollectionView.reloadData()
            calculateAndDisplayTotal()

        } catch {
            print("Error fetching products: \(error)")
        }
    }

    func updateQuantity(index: IndexPath, newQuantity: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let predicate = NSPredicate(format: "nom = %@", products[index.row].name)
        request.predicate = predicate

        do {
            let result = try managedContext.fetch(request)
            if let obj = result.first as? NSManagedObject {
                // Update the quantity without duplicating the item
                if newQuantity == 0 {
                    managedContext.delete(obj)
                } else {
                    obj.setValue(newQuantity, forKey: "quantity")
                }

                do {
                    try managedContext.save()
                    fetchProducts() // Reload data after updating quantity or deleting item
                } catch {
                    print("Error saving managed context: \(error)")
                }
            }
        } catch {
            print("Error updating quantity: \(error)")
        }
    }

    // MARK: - Cart Total Calculation

    func calculateAndDisplayTotal() {
        let total = products.reduce(0) { $0 + $1.price * Double($1.quantity) }
        totalLabel.text = "Total: \(total)"
    }

    // MARK: - UICollectionViewDelegate Methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteItems(index: indexPath)
    }

    func deleteItems(index: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let predicate = NSPredicate(format: "nom = %@", products[index.row].name)
        request.predicate = predicate

        do {
            let result = try managedContext.fetch(request)
            if let obj = result.first as? NSManagedObject {
                managedContext.delete(obj)
                try managedContext.save() // Save after deletion
                fetchProducts()
            }
        } catch {
            print("Delete error: \(error)")
        }
    }
}
