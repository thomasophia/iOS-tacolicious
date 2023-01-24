//
//  ViewController.swift
//  Tacolicious
//
//  Created by Sophia Thoma on 03.01.23.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tacoSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        tacoSlider.minimumValue = 0
        tacoSlider.maximumValue = 10
        tacoSlider.value = 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func sliderAction(_ sender: Any) {
        let rotateAnimation = CGAffineTransform(rotationAngle: CGFloat(self.tacoSlider.value))
        UIView.animate(withDuration: 1.0, delay: 0.0, options: []) {
            self.imageView.transform = rotateAnimation
        } completion: { (finished) in
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let alertController = UIAlertController(title: NSLocalizedString("AlertTitle", comment: ""), message: NSLocalizedString("AlertQuestion", comment: ""), preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: NSLocalizedString("AlertActionYes", comment: ""), style: .default) { (action) in
            self.saveRating()
            self.textField.text = ""
            self.tacoSlider.value = 5
        }
        
        let noAction = UIAlertAction(title: NSLocalizedString("AlertActionNo", comment: ""), style: .cancel) { (action) in
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func saveRating() {
        let sliderInteger = Int(round(1000000 * self.tacoSlider.value)/1000000)
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appdelegate.persistentContainer.viewContext
        
        let ratingEntity = NSEntityDescription.entity(forEntityName: "Rating", in: managedContext)!
        let rating = NSManagedObject(entity: ratingEntity, insertInto: managedContext)
        rating.setValue(self.textField.text, forKey: "place")
        rating.setValue(sliderInteger, forKey: "value")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
}

