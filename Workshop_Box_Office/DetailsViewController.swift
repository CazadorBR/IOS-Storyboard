//
//  DetailsViewController.swift
//  Workshop_Box_Office
//
//  Created by ben romdhane fedi on 2023-10-02.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
   
    var moviename: String?
    var Core_Data :String?
    var list_films: [String] = []

     override func viewDidLoad() {
        
        
        super.viewDidLoad()
         ImageFilm.image = UIImage(named: moviename!)
         FilmName.text = moviename!
        
 
     }

    
    @IBOutlet weak var FilmName: UILabel!
    @IBOutlet weak var ImageFilm: UIImageView!
    
    //    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< CORE DATA CONFIGURATION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    // >>>> INSERT DATA
    @IBAction func addFavoris(_ sender: UIButton){
        //  CORE DATA
        // invoque appdelegate / persistantContainer / managedContext
        let apdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = apdelegate.persistentContainer
        let managedContext = persistantContainer.viewContext
 
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
            fetchRequest.predicate = NSPredicate(format: "name == %@", moviename!)
            
        do {
                let existingMovies = try managedContext.fetch(fetchRequest)
                if existingMovies.first is NSManagedObject {
                    print("this film is already saved ")
                } else {
                    let movie: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: managedContext)
                    movie.setValue(moviename, forKey: "name")
                    
                    do {
                        try managedContext.save()
                        print("Data was succufully saved")
                    } catch let error as NSError {
                        print("can't save data \(error), \(error.userInfo)")
                    }
                }
            } catch {
                print("A error was occured when fetching films. \(error.localizedDescription)")
            }

        
        self.list_films  = fetchData()
        let sender = list_films
        print (sender)
        performSegue(withIdentifier: "favoris", sender:sender)

    }
    
    /// >>>  Fetch data and put it in a list
    func fetchData()-> [String]{
        var list_f: [String] = []

        let apdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = apdelegate.persistentContainer
        let managedContext = persistantContainer.viewContext
        // ping  on data core
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
                 do {
                    let movies = try managedContext.fetch(fetchRequest)
                     for movie in movies {
                        if let name = movie.value(forKey: "name") as? String {
                            print("Movie name: \(name)")
                            Core_Data = name
                            list_f.append(Core_Data!)
                        }
                     }
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
        return list_f
    }

//    >>>SEND DATA WITH SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
//        let name = sender as! String
//        print(name)
        if segue.identifier == "favoris" {
            let destination = segue.destination as! Favoris
            destination.list = list_films

        }
    }
    
     
    
    
    
    
    
}
