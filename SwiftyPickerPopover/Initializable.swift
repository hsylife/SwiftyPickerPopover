//
//  Initializable.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2017/08/04.
//  Copyright © 2017年 Yuta Hoshino. All rights reserved.
//

import Foundation

public protocol Initializable {
    init()
}

extension String: Initializable {}
extension Int: Initializable {}
extension Array: Initializable {}
