//
//  TodoData.swift
//  TodoList
//
//  Created by daelee on 2023/08/02.
//

import Foundation
import UIKit

struct TaskData {
    var text: String = ""
    var isDone: Bool = false
    
    init(text: String, isDone: Bool = false) {
        self.text = text
        self.isDone = isDone
    }
}
