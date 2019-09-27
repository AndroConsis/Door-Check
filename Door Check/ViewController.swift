//
//  ViewController.swift
//  Door Check
//
//  Created by Prateek Rathore on 24/09/19.
//  Copyright © 2019 Prateek Rathore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var doorSwitch: UISwitch!
    @IBOutlet weak var switchState: UILabel!
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var doorImage: UIImageView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDate()
        getStoredValues()
    }
    
    struct defaultsKeys {
        static let keyOne = "doorLockedStatus"
        static let timeStamp = "doorLockedTimeStamp"
    }
    
    func setDate() {
        let currentDate = Date()
        todayDate.text = currentDate.toString(dateFormat: "E, d MMM")
    }
    
    func getStoredValues() {
        if defaults.string(forKey: defaultsKeys.keyOne) != nil {
            let time = defaults.object(forKey: defaultsKeys.timeStamp) as! Date
            let calendar = Calendar.current
            if calendar.isDateInToday(time) {
                lockDoor(date: time)
                doorSwitch.setOn(true, animated:true)
                doorSwitch.isEnabled = false;
            } else {
                unlockDoor()
                doorSwitch.setOn(false, animated:true)
            }
        } else {
            unlockDoor()
            doorSwitch.setOn(false, animated:true)
        }
    }
    
    func getStatusText(text:String, time: Date) -> String {
        var doorLockedText = text
        doorLockedText.append(" @ ")
        let readableTime = time.toString(dateFormat: "MMM d, h:mm a")
        doorLockedText.append(readableTime)
        return doorLockedText
    }
    
    func lockDoor(date: Date) {
        defaults.set("Door is locked", forKey: defaultsKeys.keyOne)
        defaults.set(Date(), forKey: defaultsKeys.timeStamp)
        
        let doorLockedText = getStatusText(text: "Door locked", time: date)
        switchState.text = doorLockedText
        
        doorImage.image = UIImage(named: "door-close")
        doorSwitch.isEnabled = false;
    }
    
    func unlockDoor() {
        defaults.removeObject(forKey: defaultsKeys.keyOne)
        defaults.removeObject(forKey: defaultsKeys.timeStamp)
        doorImage.image = UIImage(named: "door-open")
        switchState.text = "Lock the door"
    }
    
    func displayActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "Confirm Action", preferredStyle: .actionSheet)
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: {(UIAlertAction) in
            self.lockDoor(date: Date())
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(UIAlertAction) in
            self.doorSwitch.setOn(false, animated: true);
        })
        optionMenu.addAction(doneAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

    @IBAction func switchStateChange(_ sender: Any) {
        let state = doorSwitch.isOn
        
        if state {
            displayActionSheet()
        } else {
            unlockDoor()
        }
    }
    
}

extension Date {
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
