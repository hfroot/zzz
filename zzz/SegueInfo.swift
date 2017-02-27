//
//  Copyright Helen Root © 2017 MHML. All rights reserved.
//
//  SegueInfo.swift
//  Alarm-ios-swift
//
//  Created by natsu1211 on 2017/02/04.
//  Copyright © 2017年 LongGames. All rights reserved.
//

import Foundation

struct SegueInfo {
    var curCellIndex: Int
    var isEditMode: Bool
    var label: String
    var mediaLabel: String
    var mediaID: String
    var repeatWeekdays: [Int]
    var scheduleEnabled: Bool
    var scheduleDate: Date
}
