//
//  ViewController.swift
//  Done
//
//  Created by Sridhar Sriram on 12/23/16.
//  Copyright © 2016 Sridhar Sriram. All rights reserved.
//

import UIKit
import CoreData

class GoogleViewController: UITableViewController {
    
    var listItems3 = [NSManagedObject]()
    var longPressGestureForTableView : UILongPressGestureRecognizer!
    var snapShot: UIView?
    var sourceIndexPath: NSIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: Selector("addItem"))
        
        let aTabArray: [UITabBarItem] = (self.tabBarController?.tabBar.items)!
        
        for item in aTabArray {
            item.image = item.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
        }
//        self.longPressGestureForTableView = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressedOnTableView(_:)))
//        self.queueListTableView.addGestureRecognizer(self.longPressGestureForTableView)
       
    }
   
//        
//    func longPressedOnTableView(gesture: UILongPressGestureRecognizer){
//        switch gesture.state
//        {
//        case .began   : self.beganLongPressingOnTableView(gesture)
//        case .changed : self.changedLongPressingOnTableView(gesture)
//        case .ended   : self.endedLongPressingOnTableView(gesture)
//        case .possible : () // Do Nothing
//        case .failed : () // Do Nothing
//        case .cancelled : () // Do Nothing
//        }
//        
//        let location = gesture.locationInView(self.queueListTableView) // Location
//        
//        guard let indexPath = self.tableView.indexPathForRowAtPoint(location) else { return } // IndexPath
//        
//        guard let cell = self.tableView.cellForRowAtIndexPath(indexPath) else { return }
//        
//        // Assinging the current indexPath to sourceIndexpath
//        
//        self.sourceIndexPath = indexPath
//        
//    }
    
    func addItem(){
        let alertController = UIAlertController(title: "What does CLP need?", message: "Get ahead", preferredStyle: UIAlertControllerStyle.alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: ({
            (_) in
            
            if let field = alertController.textFields![0] as? UITextField{
                
                self.saveItem(itemToSave: field.text!)
                self.tableView.reloadData()
                
            }
            
            
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addTextField(configurationHandler: ({
            (textField) in
            
            textField.placeholder = "Type in something"
        }))
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveItem(itemToSave: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        let entity = NSEntityDescription.entity(forEntityName: "EntityGoogle", in: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(itemToSave, forKey: "itemGoogle")
        
        do{
            try managedContext.save()
            
            listItems3.append(item)
        }
            
        catch{
            print("Error")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = UIApplication.shared.delegate as! AppDelegate
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityGoogle")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            listItems3 = result as! [NSManagedObject]
        }
        catch{
            print("Error")
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        _ = UIApplication.shared.delegate as! AppDelegate
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            managedContext.delete(listItems3[indexPath.row])
            listItems3.remove(at: indexPath.row)
            
            
        }
        self.tableView.reloadData()
    }
    
    func swipeLeft(recognizer : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "MySegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems3.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        
        //cell.contentView.addSubview(UIButton)
        
        let item = listItems3[indexPath.row]
        
        cell.textLabel?.text = item.value(forKey: "itemGoogle") as? String
        
        cell.textLabel?.textColor = UIColor.white;
        
        return cell
    }
}

