//
//  SettingsViewController.swift
//  Tipp
//
//  Created by victor aguirre on 2/13/16.
//  Copyright © 2016 victor aguirre. All rights reserved.
//

import UIKit

protocol DataEnteredDelegate{
    func userDidEnterInformation(porcentage: [Double], theme: Bool)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var newFirstPorcentageTextField: UITextField!
    @IBOutlet weak var newSecondPorcentageTextField: UITextField!
    @IBOutlet weak var newThirdPorcentageTextField: UITextField!
    
    @IBOutlet weak var darkThemeUISwitch: UISwitch!
    
    
    var delegate:DataEnteredDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Uppss!", message: "please input a tip porcentage", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveAndSend(sender: AnyObject) {
        if delegate != nil{
            let first = Double(newFirstPorcentageTextField!.text!)
            let second = Double(newSecondPorcentageTextField!.text!)
            let third = Double(newThirdPorcentageTextField!.text!)
            
            if first == nil || second == nil || third == nil{
                showAlert()
            }else{
                let information: [Double] = [first!,second!,third!]
                saveChanges(first!, second: second!, third: third!, theme: darkThemeUISwitch.on)
                delegate!.userDidEnterInformation(information, theme: darkThemeUISwitch.on)
                self.navigationController?.popViewControllerAnimated(true)
                //delegate!.userDidEnterInformation(information,theme: darkThemeUISwitch.on)
                //self.navigationController?.popViewControllerAnimated(true)
            }
            
        }
        
    }
    
    func saveChanges(first:Double, second:Double, third:Double, theme: Bool){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(first, forKey: "defaultFirstPorcentage")
        defaults.setDouble(second, forKey: "defaultSecondPorcentage")
        defaults.setDouble(third, forKey: "defaultThirdPorcentage")
        defaults.setBool(theme, forKey: "theme")
        defaults.synchronize()
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
