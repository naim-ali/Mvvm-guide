//
//  DateExtensions.swift
//  Mvvm
//
//  Created by Sagepath on 2/26/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation

extension Date
{
    func toString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
