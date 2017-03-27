//
//  DispatchQueure+.swift
//  SwiftyPickerPopover
//
//  Created by Y.T. Hoshino on 2017/03/27.
//  Copyright © 2017年 Yuta Hoshino. All rights reserved.
//

import Foundation
extension DispatchQueue {
    func cancelableAsyncAfter(deadline: DispatchTime, execute: @escaping () -> Void) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: execute)
        asyncAfter(deadline: deadline, execute: item)
        return item
    }
}
