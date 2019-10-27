//
//  Date+Extensions.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 27/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(dateFormat: String = "yyyy-MM-dd HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.firstPreferredLocale
        return dateFormatter.string(from: self)
    }
}
