//
//  TaskData.swift
//  TaskData
//
//  Created by daelee on 2023/08/02.
//

import Foundation
import UIKit

struct TaskData {
    var text: String = ""
    var isDone: Bool = false
    var category: String = ""
    
    init(text: String, isDone: Bool, category: String) {
        self.text = text
        self.isDone = isDone
        self.category = category
    }
}
