//
//  Locale+Extensions.swift
//  FindPerson
//
//  Created by Pavel Tertyshnyy on 27/10/2019.
//  Copyright © 2019 Pavel Tertyshnyy. All rights reserved.
//

import Foundation

extension Locale {
    
    static var firstPreferredLocale: Locale {
        let languageId = Locale.preferredLanguages.first ?? ""
        return Locale(identifier: languageId)
    }
}
