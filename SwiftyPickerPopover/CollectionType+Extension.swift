//
//  CollectionType+Extension.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2018/05/18.
//  Copyright © 2018年 Yuta Hoshino. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
