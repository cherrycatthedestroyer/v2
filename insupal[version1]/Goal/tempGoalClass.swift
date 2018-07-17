//  CMPT 276 Project Group 12 - Smart Apps
//  tempGoalClass.swift
//
//
//  Created by Stanislaw Kalinowski on 2018-07-03.
//  Copyright © 2018 Stanislaw Kalinowski. All rights reserved.
//
// Goal Model class for the goal table view

import Foundation


class Goal {
    
    //Class Variable Declerations
    private var goalDescription:String
    private var specifics:String
    //I know it should be private but I was having trouble okay!
    var Due:String
    private var alertType:Int;
    
    //Initializer
    init?(goalDescription:String, specifics:String, due:String){
        
        //if no goalDescription or no due then return nil
        if( goalDescription.isEmpty){
            return nil
        }
        
        self.goalDescription = goalDescription
        self.specifics = specifics
        self.Due = due
        self.alertType = 0
        
        
    }
    
    //Getters
    func getDescription()->String { return self.goalDescription }
    func getSpecifics()->String {return self.specifics}
    func getDue()->String { return self.Due}
    func getalertType()->Int {return self.alertType}
    
    //Setters
    func setDescription(goal:String){self.goalDescription = goal}
    func setSpecifics(specifics:String){self.specifics = specifics}
    func setDue(dueDate:String){self.Due = dueDate}
    func setAlertType(alertType:Int){self.alertType = alertType}
    
    
}
