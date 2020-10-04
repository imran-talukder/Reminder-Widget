//
//  DataModel.swift
//  Reminder
//
//  Created by Appnap WS01 on 4/10/20.
//

import Foundation

struct DataModel: Codable, Identifiable {
    var id: [Int]
    var task: [String] = []
    var date: [Date] = []
}
