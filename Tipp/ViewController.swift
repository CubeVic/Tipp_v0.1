//
//  ViewController.swift
//  Tipp
//
//  Created by victor aguirre on 2/13/16.
//  Copyright © 2016 victor aguirre. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  DataEnteredDelegate{
    
    //Fields
    @IBOutlet weak var billField: UITextField!
    //Labels
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    //Segment Control
    @IBOutlet weak var tipPorcentagesSegmentControl: UISegmentedControl!
    //@IBOutlet var firstView: UIView!
    
    //Load persistence
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var mainViewUIView: UIView!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    @IBOutlet weak var splitUIView: UIView!
    @IBOutlet weak var onePersonTotalLabel: UILabel!
    @IBOutlet weak var onePersonLabel: UILabel!
    @IBOutlet weak var twoPeopleTotalLabel: UILabel!
    @IBOutlet weak var twoPeopleLabel: UILabel!
    @IBOutlet weak var threePeopleTotalLabel: UILabel!
    @IBOutlet weak var threePeopleLabel: UILabel!
    @IBOutlet weak var fourPeopleTotalLabel: UILabel!
    @IBOutlet weak var fourPeopleLabel: UILabel!
    
    
    var tipPorcentages = [0.18,0.2,0.22]
    var previousDate: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitUIView.alpha = 0
        tipValueLabel.text = "$0.00"
        totalValueLabel.text = "$0.00"
        
        // make bill field first responder
        self.billField.becomeFirstResponder()
        
        //get the current date
        var newDate:[Int] = getDate()
        //recover the last date where the bill was calculated
        var previousDate: [Int] = [defaults.integerForKey("hour"),defaults.integerForKey("minute")]
        
        //check if the las bill was < 10 minutes
        if newDate[0] == previousDate[0]{
            if newDate[1] - previousDate[1]  < 10 {
                billField.text = String(defaults.valueForKey("bill")!)
                UIView.animateWithDuration(0.4, animations: {
                    self.splitUIView.alpha = 1
                })
                
        displayTotal()
            }
        }
    }
    
    
    
    //Change the Segment control values
    func populateSegmentControl(first:Double,second:Double,third:Double){
        tipPorcentagesSegmentControl.setTitle(String(format: "%.0f",first) + "%", forSegmentAtIndex: 0)
        tipPorcentagesSegmentControl.setTitle(String(format: "%.0f",second) + "%", forSegmentAtIndex: 1)
        tipPorcentagesSegmentControl.setTitle(String(format: "%.0f",third) + "%", forSegmentAtIndex: 2)
        tipPorcentages[0] = first/100
        tipPorcentages[1] = second/100
        tipPorcentages[2] = third/100
    }
    
    func calculateTip() -> Double{
        let tipPorcentage = tipPorcentages[tipPorcentagesSegmentControl.selectedSegmentIndex]
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPorcentage
        return tip
    }
    
    func calculateTotal()->Double{
        return calculateTip() + NSString(string: billField.text!).doubleValue
    }
    
    func calculateSplitedTotal(numberPeople: Double) ->Double{
        let totalsplited = calculateTotal()/numberPeople
        return totalsplited
    }
    
    //funtion to display the total and format it
    func displayTotal(){
        tipValueLabel.text = String(calculateTip())
        totalValueLabel.text = String(calculateTotal())
        tipValueLabel.text = String(format: "$%.2f", calculateTip())
        totalValueLabel.text = String(format: "$%.2f", calculateTotal())
        
        onePersonTotalLabel.text = String(format: "$%.2f", calculateSplitedTotal(1))
        twoPeopleTotalLabel.text = String(format: "$%.2f", calculateSplitedTotal(2))
        threePeopleTotalLabel.text = String(format: "$%.2f", calculateSplitedTotal(3))
        fourPeopleTotalLabel.text = String(format: "$%.2f", calculateSplitedTotal(4))
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        
        UIView.animateWithDuration(0.4, animations: {
            self.splitUIView.alpha = 1
        })
        previousDate = getDate()
        defaults.setInteger(previousDate[0], forKey: "hour")
        defaults.setInteger(previousDate[1], forKey: "minute")
        defaults.setDouble(Double(billField.text!)!, forKey: "bill")
        displayTotal()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "changePorcentages"{
            let secondVC:SettingsViewController = segue.destinationViewController as! SettingsViewController
            secondVC.delegate = self
        }
    }
    
    func getDate() -> [Int] {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second, .Nanosecond], fromDate: date)
        let hour = components.hour % 12
        let minute = components.minute
        let second = components.second
        let nanosecond = components.nanosecond
        return [Int(hour),Int(minute),Int(second),Int(nanosecond)]
    }

    
    func changedDarkTheme(){
        mainViewUIView.backgroundColor = UIColor.blackColor()
        billLabel.textColor = UIColor.whiteColor()
        billField.backgroundColor = UIColor.blackColor()
        billField.textColor = UIColor.whiteColor()
        tipLabel.textColor = UIColor.whiteColor()
        tipValueLabel.textColor = UIColor.whiteColor()
        totalLabel.textColor = UIColor.whiteColor()
        totalValueLabel.textColor = UIColor.whiteColor()
        
        splitUIView.backgroundColor = UIColor.blackColor()
        onePersonLabel.textColor = UIColor.whiteColor()
        onePersonTotalLabel.textColor = UIColor.whiteColor()
        twoPeopleLabel.textColor = UIColor.whiteColor()
        twoPeopleTotalLabel.textColor = UIColor.whiteColor()
        threePeopleLabel.textColor = UIColor.whiteColor()
        threePeopleTotalLabel.textColor = UIColor.whiteColor()
        fourPeopleLabel.textColor = UIColor.whiteColor()
        fourPeopleTotalLabel.textColor = UIColor.whiteColor()
    }
    
    func changedLightTheme(){
        mainViewUIView.backgroundColor = UIColor.whiteColor()
        billLabel.textColor = UIColor.blackColor()
        billField.backgroundColor = UIColor.whiteColor()
        billField.textColor = UIColor.blackColor()
        tipLabel.textColor = UIColor.blackColor()
        tipValueLabel.textColor = UIColor.blackColor()
        totalLabel.textColor = UIColor.blackColor()
        totalValueLabel.textColor = UIColor.blackColor()
        
        splitUIView.backgroundColor = UIColor.whiteColor()
        onePersonLabel.textColor = UIColor.blackColor()
        onePersonTotalLabel.textColor = UIColor.blackColor()
        twoPeopleLabel.textColor = UIColor.blackColor()
        twoPeopleTotalLabel.textColor = UIColor.blackColor()
        threePeopleLabel.textColor = UIColor.blackColor()
        threePeopleTotalLabel.textColor = UIColor.blackColor()
        fourPeopleLabel.textColor = UIColor.blackColor()
        fourPeopleTotalLabel.textColor = UIColor.blackColor()
    }
    
    func userDidEnterInformation(porcentages: [Double], theme: Bool) {
        populateSegmentControl(porcentages[0], second: porcentages[1], third: porcentages[2])
        if theme{
            changedDarkTheme()
        }else{
            changedLightTheme()
        }
        displayTotal()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //print("view will appear")
        if defaults.doubleForKey("defaultFirstPorcentage") == 0 {
            tipPorcentagesSegmentControl.setTitle(String(format: "%0.f", tipPorcentages[0] * 100) + "%", forSegmentAtIndex: 0)
            tipPorcentagesSegmentControl.setTitle(String(format: "%0.f", tipPorcentages[1] * 100) + "%", forSegmentAtIndex: 1)
            tipPorcentagesSegmentControl.setTitle(String(format: "%0.f", tipPorcentages[2] * 100) + "%", forSegmentAtIndex: 2)
        } else{
            populateSegmentControl(defaults.doubleForKey("defaultFirstPorcentage"), second: defaults.doubleForKey("defaultSecondPorcentage"), third: defaults.doubleForKey("defaultThirdPorcentage"))
            if defaults.boolForKey("theme"){
                changedDarkTheme()
            }else{
                changedLightTheme()
            }
        }
        
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        print("view did appear")
//        
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("view will disappear")
//    }
//    
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//        print("view did disappear")
//    }

}