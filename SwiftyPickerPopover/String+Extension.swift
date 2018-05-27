//
//  String+Extension.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2017/07/24.
//  Copyright © 2017年 Yuta Hoshino. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
}
