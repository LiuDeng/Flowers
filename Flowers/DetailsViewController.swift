//
//  DetailsViewController.swift
//  Flowers
//
//  Created by Jozsef Romhanyi on 2015. 11. 08..
//  Copyright © 2015. Jozsef Romhanyi. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate  {
    let enRow = 0
    let deRow = 1
    let huRow = 2
    let ruRow = 3
    var cancelButton = UIButton()
    var doneButton = UIButton()
    var aktLanguageRow = 0
    var oldHelpLines = 0
    var aktLanguageKey: String?
    var toDo = ""
    let textCellIdentifier = "languageTextCell"
    
    var nameInputField: UITextField?
    var lineCountPicker: UIPickerView?
    var lineCounts = ["0","1","2","3","4"]
    var textCell = [
        "\(GV.language.getText(.TCEnglish))",
        "\(GV.language.getText(.TCGerman))",
        "\(GV.language.getText(.TCHungarian))",
        "\(GV.language.getText(.TCRussian))",
    ]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GV.language.addCallback(changeLanguage)
        aktLanguageKey = GV.language.getAktLanguageKey()
        setAktlanguageRow()
        
        
        switch toDo {
        case nameText: makeNameView()
        case volumeText: makeVolumeView()
        case helpLinesText: makeHelpLinesView()
        case languageText: makeLangageView()
        default: break
        }
        cancelButton.setTitle(GV.language.getText(.TCCancel), forState:.Normal)
        let titleColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        cancelButton.setTitleColor(titleColor, forState: UIControlState.Normal)
        
        doneButton.setTitle(GV.language.getText(.TCDone), forState: .Normal)
        doneButton.setTitleColor(titleColor, forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "cancelPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.addTarget(self, action: "donePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(cancelButton)
        self.view.addSubview(doneButton)
        
        setupLayout()
    }
    
    func makeNameView() {
        tableView.layer.hidden = false
        nameInputField = UITextField()
        if GV.aktName == "dummy" {
            nameInputField!.text = ""
        } else {
            nameInputField!.text = GV.aktName
        }
        nameInputField!.layer.borderColor = UIColor.blackColor().CGColor
        nameInputField!.layer.borderWidth = 1
        self.view.addSubview(nameInputField!)
        nameInputField!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: nameInputField!, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: nameInputField!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 400))
        
        self.view.addConstraint(NSLayoutConstraint(item: nameInputField!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 300))
        
        self.view.addConstraint(NSLayoutConstraint(item: nameInputField!, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50))
        
        
        self.view.addConstraint(NSLayoutConstraint(item: tableView!, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .Top, relatedBy: .Equal, toItem: nameInputField!, attribute: .Bottom, multiplier: 1.0, constant: 100))
        
        self.view.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 400))
        
        self.view.addConstraint(NSLayoutConstraint(item: tableView!, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 400))
        

    }
    func makeVolumeView() {
        let _ = 0
    }
    func makeHelpLinesView() {
        tableView.layer.hidden = true
        oldHelpLines = GV.showHelpLines
        lineCountPicker = UIPickerView()
        self.view.addSubview(lineCountPicker!)
        lineCountPicker!.delegate = self
        lineCountPicker!.dataSource = self
        lineCountPicker!.selectRow(Int(GV.spriteGameData.showHelpLines), inComponent: 0, animated: false)
        
        lineCountPicker!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: lineCountPicker!, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: lineCountPicker!, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1.0, constant: -100))
        
        self.view.addConstraint(NSLayoutConstraint(item: lineCountPicker!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100))
        
        self.view.addConstraint(NSLayoutConstraint(item: lineCountPicker!, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
    }
    
    func makeLangageView() {
        //languageTableView = UITableView()
        tableView.layer.hidden = false
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textCell.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = textCell[row]
        if row == aktLanguageRow {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case enRow:  GV.language.setLanguage(LanguageEN)
        case deRow:  GV.language.setLanguage(LanguageDE)
        case huRow:  GV.language.setLanguage(LanguageHU)
        case ruRow:  GV.language.setLanguage(LanguageRU)
        default: _ = 0
        }
        textCell.removeAll()
        textCell = [
            "\(GV.language.getText(.TCEnglish))",
            "\(GV.language.getText(.TCGerman))",
            "\(GV.language.getText(.TCHungarian))",
            "\(GV.language.getText(.TCRussian))",
        ]
        setAktlanguageRow()
        tableView.reloadData()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lineCounts.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lineCounts[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        GV.showHelpLines = Int(lineCounts[row])!
    }
    
    func setAktlanguageRow() {
        switch GV.language.getAktLanguageKey() {
        case LanguageEN: aktLanguageRow = enRow
        case LanguageDE: aktLanguageRow = deRow
        case LanguageHU: aktLanguageRow = huRow
        case LanguageRU: aktLanguageRow = ruRow
        default: aktLanguageRow = enRow
        }
    }
    
    func cancelPressed(sender: UIButton) {
        switch toDo {
        case nameText: _ = 0
        case volumeText: _ = 0
        case helpLinesText: GV.showHelpLines = oldHelpLines
        case languageText:  GV.language.setLanguage(aktLanguageKey!)
        default: break
        }
        self.performSegueWithIdentifier(backToSettings, sender: self)
    }
    
    func donePressed(sender: UIButton) {
        switch toDo {
        case nameText: _ = 0
        case volumeText: _ = 0
        case helpLinesText: GV.spriteGameData.showHelpLines = Int64(GV.showHelpLines)
        case languageText:  GV.spriteGameData.aktLanguageKey = GV.language.getAktLanguageKey()
        default: break
        }
        
        
        
        GV.dataStore.createSpriteGameRecord(GV.spriteGameData)
        
        self.performSegueWithIdentifier(backToSettings, sender: self)
    }
    
    func changeLanguage()->Bool {
        cancelButton.setTitle(GV.language.getText(.TCCancel), forState:.Normal)
        doneButton.setTitle(GV.language.getText(.TCDone), forState: .Normal)
        return true
    }
    
    
    func setupLayout() {
        var constraintsArray = Array<NSLayoutConstraint>()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        //languageTableView
        constraintsArray.append(NSLayoutConstraint(item: cancelButton, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 40))
        
        constraintsArray.append(NSLayoutConstraint(item: cancelButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 50))
        
        constraintsArray.append(NSLayoutConstraint(item: cancelButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100))
        
        constraintsArray.append(NSLayoutConstraint(item: cancelButton, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50))
        
        
        
        
        //        // doneButton
        constraintsArray.append(NSLayoutConstraint(item: doneButton, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -40.0))
        
        constraintsArray.append(NSLayoutConstraint(item: doneButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 50.0))
        
        constraintsArray.append(NSLayoutConstraint(item: doneButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100))
        
        constraintsArray.append(NSLayoutConstraint(item: doneButton, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50))
        
        
        self.view.addConstraints(constraintsArray)
    }
    
    
}
