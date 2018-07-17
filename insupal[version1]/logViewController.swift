//  CMPT 276 Project Group 12 - Smart Apps
//  logViewController.swift
//
//
//  Created by Nicole Wong on 2018-07-02.
//  Copyright © 2018 cherrycat. All rights reserved.
//
// Updates the Firebase database with the user's inputs

import UIKit
import Firebase
import FirebaseAuth

class logViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // Firebase
    var refLog: DatabaseReference!
    
    // DatePicker
    private var datePicker: UIDatePicker?
    
    // Insulin Type picker options
    var types = ["Rapid-acting", "Short-acting", "Intermediate-acting", "Long-acting"]
    
    // event picker options
    var events = ["Before Meal", "After Meal", "Waking Up", "Just BP"]
    
    //
    var picker = UIPickerView()
    var currentTextFieldTag: Int = 10
    

    // Outlets
    @IBOutlet weak var bloodGlucoseTextField: UITextField!
    @IBOutlet weak var insulinTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var insulinTypeTextField: UITextField!
    @IBOutlet weak var systolicTextField: UITextField!
    @IBOutlet weak var diastolicTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    
    // Status message
    @IBOutlet weak var testMessage: UILabel!
    
    
    // Action - Executed when button is tapped
    @IBAction func buttonAddLog(_ sender: UIButton) {
        addLog()
    }
    @IBAction func buttonAutoDateTime(_ sender: UIButton) {
        autoDateTime()
    }
    
    //////////////////////// Functions of the insulin type view picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextFieldTag == 10 {
            return types.count
        } else {
            return events.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextFieldTag == 10 {
            return types[row]
        } else {
            return events[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextFieldTag == 10 {
            insulinTypeTextField.text = types[row]
        } else {
            eventTextField.text = events[row]
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 10 {
            currentTextFieldTag = 10
        } else {
            currentTextFieldTag = 20
        }
        
        picker.reloadAllComponents()
        return true
    }
    
    
    ////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the datapicker for the dateTextField
        datePicker = UIDatePicker()
        
        datePicker?.addTarget(self, action: #selector(logViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField.inputView = datePicker

        // to load firebase into the application
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Getting the current userID logged in
        let userID = Auth.auth().currentUser?.uid
        
        // variable to reference the current user's database
        refLog = Database.database().reference().child(userID!);
        
        // tap gesture ending the textbox editing
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        // picker view
        picker.delegate = self
        picker.dataSource = self
        
        insulinTypeTextField.tag = 10
        eventTextField.tag = 20
        
        insulinTypeTextField.delegate = self
        eventTextField.delegate = self
        
        insulinTypeTextField.inputView = picker
        eventTextField.inputView = picker
    }
    
    // view tap recognized
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // method to change the date in the datePicker
    @objc func dateChanged(datePicker: UIDatePicker) {
        // to change the date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        
        // remove the datapicker selector when done
        view.endEditing(true)
    }
    
    // Function to add user inputs into database
    func addLog() {
        let key = refLog.childByAutoId().key
        
        // converting user inputs from strings to double
        let doubleBloodGlucose = Double(bloodGlucoseTextField.text!)
        let doubleInsulin = Double(insulinTextField.text!)
        let stringDate = String(dateTextField.text!)
        let insulinType = String(insulinTypeTextField.text!)
        let systolicBP = Double(systolicTextField.text!)
        let diastolicBP = Double(diastolicTextField.text!)
        let eventType = String(eventTextField.text!)
    
        // taking the user inputs and creating an array for it to be entered into the database
        let data : [String:Any] = [
            "id": key,
            "date": stringDate,
            "bloodGlucose": doubleBloodGlucose as Any,
            "insulin": doubleInsulin as Any,
            "insulinType": insulinType,
            "systolicBP": systolicBP as Any,
            "diastolicBP": diastolicBP as Any,
            "eventType": eventType
        ]
        
        // adding value into database
        refLog.child(key).setValue(data)
        
        // Successful Message
        testMessage.text = "Successfully added"
    }
    
    // function that automatically fills date and time
    func autoDateTime(){
        let date = Date()
        let calender = Calendar.current
        let hour = calender.component(.hour, from: date)
        let minute = calender.component(.minute, from: date)
        let month = calender.component(.month, from: date)
        let day = calender.component(.day, from: date)
        let year = calender.component(.year, from: date)
        if minute < 10 {
            let timeGot = ("\(month)/\(day)/\(year) " + "\(hour):"+"0"+"\(minute)")
            dateTextField.text = timeGot
        }
        else{
            let timeGot = ("\(month)/\(day)/\(year) " + "\(hour):\(minute)")
            dateTextField.text = timeGot
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
