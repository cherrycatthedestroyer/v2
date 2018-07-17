//  CMPT 276 Project Group 12 - Smart Apps
//  GoalViewController.swift
//
//
//  Created by Stanislaw Kalinowski on 2018-07-03.
//  Copyright © 2018 Stanislaw Kalinowski. All rights reserved.
//

import UIKit
import os.log


class GoalViewController: UIViewController, UITableViewDataSource,  UITableViewDelegate{
    
    @IBOutlet var goalTableView: UITableView!
    
    //Holds goals for the pages(Persistent Data to be implemented!)
    var goals = [Goal]()

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GoalTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GoalTableViewCell else {
                fatalError("The dequeued cell is not an instance of GoalTableViewCell")
        }
        
        //Fetch goals
        let holdGoal = goals[indexPath.row]
        
        //Sets the two labels in the cell
        cell.goalLabel.text = holdGoal.getDescription()
        cell.dueLabel.text = holdGoal.getDue()
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //load sample goals!
//        loadGoals()
        self.goalTableView.rowHeight=72
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        //Switch cases for different button navigation(Return button case to be implemented, for now just defualt)
        switch(segue.identifier ?? "") {
        //Set-up for add Button
        case"AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        //Set-up for Selecting a cell in the table
        case"ShowDetail":
            guard let goalDetailViewController = segue.destination as? GoalEditViewController
            else { fatalError("Unexpected destination")}
            
            guard let selectedGoalCell = sender as? GoalTableViewCell
                else{fatalError("Unexpected Error")}
            
            guard let indexPath = goalTableView.indexPath(for: selectedGoalCell)
                else{fatalError("Unexpected Error")}
            
            let selectedGoal = goals[indexPath.row]
               goalDetailViewController.theGoal = selectedGoal
        
            
        default:
            let i = 1
        }
        
    }
    

    //Mark: Actions
    @IBAction func unwindToGoalList(sender: UIStoryboardSegue) {
        //if alrady a goal
        if let sourceViewController = sender.source as? GoalEditViewController, let theGoal = sourceViewController.theGoal {
            
            if let selectedIndexPath = goalTableView.indexPathForSelectedRow {
                goals[selectedIndexPath.row] = theGoal
                goalTableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            }
            else{
            // Add a new goal
            let newIndexPath = IndexPath(row: goals.count, section: 0)
            
            goals.append(theGoal)
            goalTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }
    }
    
    
    
    
}
