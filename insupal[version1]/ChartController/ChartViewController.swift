//  CMPT 276 Project Group 12 - Smart Apps
//  ChartViewController.swift
//
//
//  Created by MJ Jeon on 2018-07-04.
//  Copyright © 2018 cherrycat. All rights reserved.
//
// Updates the chart by retrieving the info from the Firebase database

import UIKit
import Charts
import Firebase
import FirebaseAuth


class ChartViewController: UIViewController,ChartViewDelegate{

    @IBOutlet weak var chtChart: LineChartView!
    
    var insulin_data : [Double] = [] // insulin holder
    var bg_data : [Double] = [] // glucose holder
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        read()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // retrive from firebase
    func read()
    {
        var ref: DatabaseReference!
        
        // Getting the current userID logged in
        let userID = Auth.auth().currentUser?.uid
        
        ref = Database.database().reference().child(userID!)
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for log in snapshot.children.allObjects as![DataSnapshot]{
            let logObject = log.value as? [String: AnyObject]
            let logBloodGlucose = logObject?["bloodGlucose"]
            let logInsulin = logObject?["insulin"]
            
            
            self.bg_data.append(logBloodGlucose as! Double)
            self.insulin_data.append(logInsulin as! Double)
            print(self.bg_data)
            print(self.insulin_data)
            }
        }) { (err: Error) in
            
            print("\(err.localizedDescription)")
            
        }
        
    }
    
    // Generate graph button
    @IBAction func testbutt(_ sender: UIButton) {
        updateGraph()
    }
    
    // updating the graph viewer with the new data entries
    func updateGraph(){
        var lineChartEntry = [ChartDataEntry]() //array to be displayed - insulin
        var lineChartEntry1 = [ChartDataEntry]() // blood glucose
        
        for i in 0..<insulin_data.count {
            let insulin_value = ChartDataEntry(x: Double(i), y: insulin_data[i]) // set x and y
            lineChartEntry.append(insulin_value) // here to add data set
        }
        
        for i in 0..<bg_data.count {
            let bg_value = ChartDataEntry(x: Double(i), y: bg_data[i]) // set x and y
            lineChartEntry1.append(bg_value) // here to add data set
        }
        
        let insulin = LineChartDataSet(values: lineChartEntry, label: "Insulin") // convert lineChartEntry to a LineChartDataSet for insulin data sets
        
        let bloodGlucose = LineChartDataSet(values: lineChartEntry1, label: "Blood Glucose") // convert lineChartEntry to a LineChartDataSet for insulin data sets
        
        insulin.setColor(UIColor.blue) // set to blue
        insulin.setCircleColor(UIColor.blue)
        
        bloodGlucose.setColor(UIColor.cyan) // set to cyan
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(insulin)
        dataSets.append(bloodGlucose)
        
        let data : LineChartData = LineChartData(dataSets: dataSets)
        
        self.chtChart.data = data
                
        chtChart.chartDescription?.text = "Glucose & Insulin level" // graph description
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


