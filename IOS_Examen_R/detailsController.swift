//
//  detailsController.swift
//  IOS_Examen_R
//
//  Created by ben romdhane fedi on 2024-01-15.
//

import UIKit
import CoreData
class detailsController: UIViewController {
    var PlaceName: String?
    var list_players: [String] = []

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var priu_unitaire: UITextField!
    @IBOutlet weak var Des_img: UIImageView!
    @IBOutlet weak var Stepper_nbr: UIStepper!
    @IBOutlet weak var nbr_tickets: UILabel!
    
    @IBAction func IncrementQ(_ sender: UIStepper) {
        let stepperValue = Int(sender.value)
        nbr_tickets.text = "\(stepperValue)"
    }
    
    @IBAction func Heure_depart(_ sender: Date) {
        
 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Des_img.image = UIImage(named: PlaceName!)

     }
    
     
    @IBAction func Add_reservation(_ sender: Any) {
        let apdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = apdelegate.persistentContainer
        let managedContext = persistantContainer.viewContext
 
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reservation")
            fetchRequest.predicate = NSPredicate(format: "name == %@", PlaceName!)
            
        do {
            

                    let existingPlayers = try managedContext.fetch(fetchRequest)
                    if existingPlayers.first is NSManagedObject {
                        print("this PLayer is already saved ")
                        alert(title: "Failed", message: "this reservation was already saved")
                    } else {
                        let player: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Reservation", into: managedContext)
                          let PRIX_U = Int(priu_unitaire.text!)
                        let NBR = Int(nbr_tickets.text!)
                        let PRIX_TOTAL =  PRIX_U! * NBR!
                        print(PRIX_TOTAL)
                         player.setValue(PlaceName, forKey: "name")
                        player.setValue(PRIX_TOTAL, forKey: "price")

                        do {
                            
                           
                                try managedContext.save()
                                print("reservation was succufully saved")
                            let alert = UIAlertController(title: "Success", message: "Reservation was successfully saved \(email.text!).", preferredStyle: .alert)
                                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                           action in
//                                            self.performSegue(withIdentifier: "favorites", sender: self.list_players)
                                       }))
                                self.present(alert, animated: true)
                            

                        } catch let error as NSError {
                            print("can't save data \(error), \(error.userInfo)")
                                    
                                     let alert = UIAlertController(title: "Error", message: "Unable to save player: \(error.localizedDescription)", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                    self.present(alert, animated: true)
                            
                        }
                    }

            } catch {
                print("A error was occured when fetching Player. \(error.localizedDescription)")
            }

        
        
    }
   

    
    
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
