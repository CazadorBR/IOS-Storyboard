//
//  Favoris.swift
//  Workshop_Box_Office
//
//  Created by ben romdhane fedi on 2023-10-07.
//

import UIKit
import CoreData

class Favoris: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource  {
    var data: String?
    var core_Data:String?
    var list: [String] = []

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< COLLECTION VIEW CONFIGURATION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellule = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
        let contentView = cellule.contentView
        
        let image_Film = contentView.viewWithTag(1)as! UIImageView
        let name_Film = contentView.viewWithTag(2)as! UILabel
 
         image_Film.image = UIImage(named: list[indexPath.row])
         name_Film.text = list[indexPath.row ]
    
         return cellule
    }
//    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< CORE DATA CONFIGURATION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    @IBAction func FetchData(_ sender: Any) {
        let apdelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = apdelegate.persistentContainer
        let managedContext = persistantContainer.viewContext
        // PING  THE ENTITY IN data core
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            do {
               let movies = try managedContext.fetch(fetchRequest)
                for movie in movies {
                   if let name = movie.value(forKey: "name") as? String {
                       core_Data = name
                       print("Movie name: \(name)")
                       print("core data variable"+core_Data!)

                   }

                }
           } catch let error as NSError {
               print("Could not fetch. \(error), \(error.userInfo)")
           }
     }
    
    
    
    @IBAction func clear(_ sender: Any) {
        if(DeleteAllData()){
            print("Core data cleared SUCCEFULLY !!!And nothing to fetch")
                  
    }
    }
    // Clear CACHE CORE DATA
        func DeleteAllData()-> Bool{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Movie"))
            do {
                try managedContext.execute(DelAllReqVar)
            }
            catch {
                print(error)
            }
            return true
        }
    
    //    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VIEW LOADED >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(list)
//            print("Data sended  :"+data!)
//        print(data!.count)
        // Do any additional setup after loading the view.
    }
    


}
