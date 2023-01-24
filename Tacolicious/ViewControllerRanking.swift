//
//  ViewControllerRanking.swift
//  Tacolicious
//
//  Created by Sophia Thoma on 03.01.23.
//

import UIKit
import CoreData

class ViewControllerRanking: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var placesArray = [String]()
    var valuesArray = [Int16]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        let ratingFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Rating")
        
        ratingFetch.sortDescriptors = [NSSortDescriptor.init(key: "value", ascending: false)]
        
        let ratings = try! managedContext.fetch(ratingFetch) as! [Rating]
        
        for r in ratings {
            self.placesArray.append(r.place ?? "")
            self.valuesArray.append(r.value)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Ranking", comment: "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellidentifier")
        let place = placesArray[indexPath.row]
        cell?.textLabel?.text = "\(place)"
        let value = valuesArray[indexPath.row]
        cell?.detailTextLabel?.text = "\(value)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        let scaleAnimation = CGAffineTransform(scaleX: 0.6, y: 0.6)
        if cell?.detailTextLabel?.text == "10" {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat]) {
                cell?.detailTextLabel?.textColor = UIColor.orange
                cell?.detailTextLabel?.transform = scaleAnimation
            } completion: { (finished) in
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        let scaleAnimation = CGAffineTransform(scaleX: 1.0, y: 1.0)
        if cell?.detailTextLabel?.text == "10" {
            cell?.detailTextLabel?.layer.removeAllAnimations()
            cell?.detailTextLabel?.textColor = UIColor.black
            cell?.detailTextLabel?.transform = scaleAnimation
        }
    }
    
}
