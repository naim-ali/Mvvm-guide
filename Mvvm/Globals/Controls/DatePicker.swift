//
//  DatePicker.swift
//  Mvvm
//
//  Created by Sagepath on 3/7/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Bond
import Foundation

class DatePicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var dateValue: Observable<Date?>
    
    override init(frame: CGRect) {
        self.dateValue = Observable<Date?>(nil)
        
        super.init(frame: frame)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dateValue = Observable<Date?>(nil)
        
        super.init(coder: aDecoder)
        super.dataSource = self
        super.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return 5000
        } else if (component == 1) {
            return 5000
        } else if (component == 2) {
            return 130
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            // days
            return "\(Int(row) % 31 + 1)"
        }
        else if component == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            let myDate: Date? = dateFormatter.date(from: "\(Int(row) % 12 + 1)")
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            return formatter.string(from: myDate!)
        }
        else if component == 2 && row == 0 {
            return "-----"
        }
        else {
            // let's use NSDateFormatter to get the current year:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY"
            let currentYear = Int(dateFormatter.string(from: Date()))!
            return "\(currentYear - (row - 1))"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaultDateFormatter = DateFormatter()
        defaultDateFormatter.dateFormat = "MM/dd/yyyy"
        let defaultDate = defaultDateFormatter.date(from: "01/01/0001")!
        
        let calendar = Calendar.current
        var dateComponents: DateComponents? = calendar.dateComponents([.year, .month, .day], from: dateValue.value ?? defaultDate)
        
        if component == 0 {
            dateComponents?.day = (Int(row) % 31 + 1)
        }
        else if component == 1 {
            dateComponents?.month = (Int(row) % 12 + 1)
        }
        else if component == 2 && row == 0 {
            dateComponents?.year = 0001
        }
        else {
            // let's use NSDateFormatter to get the current year:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY"
            let currentYear = Int(dateFormatter.string(from: Date()))!
            dateComponents?.year = (currentYear - (row - 1))
        }
        
        //save date relative from date
        dateValue.value = calendar.date(from: dateComponents!)
    }
}
