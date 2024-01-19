//
//  ViewController.swift
//  Messenger
//
//  Created by ben romdhane fedi on 2024-01-03.
//

import UIKit
import CoreData
class ViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{
    var messages = ["Thank you", "Whats's Up", "As you like bro", "Meeting?" ,"Jordan Henderson", "Mohamed Salah"
                   ]
    var filmName = ["Andreas Romero","Chelsea Watt","Huw Oakley","Logan Calhoun","Marcos Redmond","Stanley Obrien"]
    var Message_Core_Data :String?
    var Name_Core_Data :String?
    @IBOutlet weak var segmentchanged: UISegmentedControl!
    var Fav_names : [String] = []
    var Fav_messages : [String] = []
    var Tuple: [(String, String)] = []

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableViewFavorites: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  filmName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellule = tableView.dequeueReusableCell(withIdentifier:"mycell")
        let contentView = cellule?.contentView

       let IMAGE = contentView?.viewWithTag(1)as! UIImageView
       let Name = contentView?.viewWithTag(2)as! UILabel
        let Message = contentView?.viewWithTag(3)as! UILabel

       
    
 
        Name.text = filmName[indexPath.row]
        IMAGE.image = UIImage(named: filmName[indexPath.row])
        Message.text = messages[indexPath.row]
        return cellule!
    }
    
  
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = filmName[indexPath.row]
        let message = messages[indexPath.row]
        let senderData = (name, message)

         performSegue(withIdentifier: "sendmessage", sender:senderData)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendmessage", let senderData = sender as? (String, String) {
                if let destinationVC = segue.destination as? messageViewController {
                    destinationVC.name = senderData.0
                    destinationVC.messagesent = senderData.1
                }
            }

    }
    
    
    
    
    @IBAction func ChangeSegment(_ sender: UISegmentedControl) {
        switch segmentchanged.selectedSegmentIndex{
        case 0 :
            print("hello")
            filmName = ["Andreas Romero", "Chelsea Watt", "Huw Oakley", "Logan Calhoun", "Marcos Redmond", "Stanley Obrien"]
                   messages = ["Thank you", "Whats's Up", "As you like bro", "Meeting?", "Jordan Henderson", "Mohamed Salah"]
            tableview.reloadData()
            tableview.reloadData()

        case 1 :
            filmName = []
            messages = []
            Tuple = fetchData()
            for tuple in Tuple {
                let(name,message) = tuple
                filmName.append(name)
                messages.append(message)
                
             }
            
            
            tableview.reloadData()

        default:
            break
        }
    }
    
    func fetchData()-> [(String,String)]{
        var list_message: [(String, String)] = []

        let apdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = apdelegate.persistentContainer
        let managedContext = persistantContainer.viewContext
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
                 do {
                    let movies = try managedContext.fetch(fetchRequest)
                     for movie in movies {
                        if let name = movie.value(forKey: "name") as? String ,
                           let message = movie.value(forKey: "message") as? String  {
 

                            Name_Core_Data = name
                            Message_Core_Data = message
                            list_message.append((Name_Core_Data!,Message_Core_Data!))
                            print(list_message)
                          }
                     }
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
        return list_message
    }

    
    func deleteMovie(at indexPath: IndexPath) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "name = %@", filmName[indexPath.row]) // Assurez-vous que "name" est une clé valide dans votre entité

        do {
            let test = try managedContext.fetch(fetchRequest)

            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)

            do {
                try managedContext.save()
                return true
            } catch {
                print(error)
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Supprimez l'élément de Core Data
            if deleteMovie(at: indexPath) {
                // Mettez à jour vos données ici (supprimez l'élément de vos données)
                filmName.remove(at: indexPath.row)
 
                // Supprimez la ligne de votre tableView
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                print("Erreur lors de la suppression de l'élément de Core Data")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(fetchData())
        
    }


}

