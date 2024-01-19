//
//  messageViewController.swift
//  messenger2
//
//  Created by ben romdhane fedi on 2024-01-03.
//

import UIKit
import CoreData
class messageViewController: UIViewController {
    var name :String?
      var messagesent :String?
    
    var Message_Core_Data :String?
    var Name_Core_Data :String?

    var list_message: [String] = []

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var message: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let messageLabel = UILabel()
           messageLabel.text = messagesent
           messageLabel.textColor = .black
           messageLabel.numberOfLines = 0
           messageLabel.textAlignment = .center

           // Assurez-vous que le label s'ajuste à la taille du texte
           messageLabel.sizeToFit()
 
           messageLabel.center = CGPoint(x: message.frame.size.width  / 2,
                                         y: message.frame.size.height / 2)

            message.addSubview(messageLabel)
         image.image = UIImage(named: name!)
        print(fetchData())
     }
    

    @IBAction func saveMessage(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let persistentContainer = appDelegate.persistentContainer
        let managedContext = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name ?? "")

        do {
            let existingUsers = try managedContext.fetch(fetchRequest)
            if let existingUser = existingUsers.first as? NSManagedObject {
                 existingUser.setValue(messagesent, forKey: "message")
                print("This message has been updated for an existing user.")
            } else {
                 let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext)
                newUser.setValue(name, forKey: "name")
                newUser.setValue(messagesent, forKey: "message")
                print("New user and message have been created.")
            }
             try managedContext.save()
            print("Message was successfully saved.")
        } catch let error as NSError {
            print("Can't save message \(error), \(error.userInfo)")
        }
    }

    func fetchData()-> [String]{
        var list_message: [String] = []

        let apdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = apdelegate.persistentContainer
        let managedContext = persistantContainer.viewContext
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
                 do {
                    let movies = try managedContext.fetch(fetchRequest)
                     for movie in movies {
                        if let name = movie.value(forKey: "name") as? String ,
                           let message = movie.value(forKey: "message") as? String  {
//                            print("user name: \(name)")
//                            print("user name: \(message)")

                            Message_Core_Data = name
                            Message_Core_Data = message
                            let senderData = (Message_Core_Data, Message_Core_Data)

                            list_message.append(Message_Core_Data!)
                         }
                     }
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
        return list_message
    }

}
