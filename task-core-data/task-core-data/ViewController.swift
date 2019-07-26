//
//  ViewController.swift
//  task-core-data
//
//  Created by Mohammed Almaroof on 7/25/19.
//  Copyright © 2019 Mohammed Almaroof. All rights reserved.
//
import CoreData
import UIKit
// TODO: Import CoreData and connect container to this ViewController

class ViewController: UIViewController {
    var container: NSPersistentContainer!
    @IBOutlet var personNameTextField: UITextField!
    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var taskDeadlinePicker: UIDatePicker!
    @IBOutlet var personNameLabel: UILabel!
    @IBOutlet var numberOfTasksLabel: UILabel!
    @IBOutlet var taskDeadlineLabel: UILabel!
    @IBOutlet var taskNameLabel: UILabel!
    
    var listOfTasks:[Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // guard is basically an "if not" statement 
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        // ^^ The persistent container is available.
        
        taskNameLabel.text = ""
        taskDeadlineLabel.text = ""
        personNameLabel.text = ""
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        // TODO: Save the user input by the user
        // read the user name from the text field
        // and check if it is null before actually saving.
        if let userName = personNameTextField.text{
            var user = NSEntityDescription.insertNewObject(forEntityName: "User", into: container.viewContext) as! User
            
            user.name = userName
            
            for task in listOfTasks{
                user.addToAssignedTasks(task)
            }
            try! container.viewContext.save()
        }
    }
    @IBAction func loadButtonPressed(_ sender: Any) {
        // TODO: Load the most recent person saved, and render the information
        // of the user and their most recent task in the labels
        let itemsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let fetchedPersons = try! container.viewContext.fetch(itemsFetchRequest) as! [User]
        print("Fetched items: \(fetchedPersons)")
        if fetchedPersons.count > 0{
            let mostRecentUser = fetchedPersons[fetchedPersons.count - 1]
            personNameLabel.text = mostRecentUser.name
            if let taskList = mostRecentUser.assignedTasks?.allObjects{
                if let testArray = taskList as? [Task]{
                    let mostRecentTask = testArray[testArray.count - 1]
                    taskNameLabel.text = mostRecentTask.name
                    taskDeadlineLabel.text = mostRecentTask.deadline?.description
                }
            }
            
        }
        
        //        for p in fetchedPersons {             print("Next person: \(String(describing: p.name)) Veggie? \(p.vegatarian)")         }         if fetchedPersons.count > 0 {             let latestSave = fetchedPersons[fetchedPersons.count - 1]             lblName.text = latestSave.name             togSwitch.isOn = latestSave.vegatarian         }
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
        personNameTextField.text = ""
        taskNameTextField.text = ""
        numberOfTasksLabel.text = "Number of tasks:"
        listOfTasks = []
    }
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        // TODO: Add a task to the list of tasks array
        // reading from the task text field and the date picker
        // make sure task name is not emoty
        if let taskName = taskNameTextField.text {
            var taskDeadline = taskDeadlinePicker.date
            let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: container.viewContext) as! Task
            task.name = taskName
            task.deadline = taskDeadline
            
            listOfTasks.append(task)
            
            numberOfTasksLabel.text = "Number of tasks: \(listOfTasks.count)"
        }
    }
    
}

