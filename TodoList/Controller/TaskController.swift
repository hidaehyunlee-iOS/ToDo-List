//
//  TaskController.swift
//  TodoList
//
//  Created by daelee on 2023/08/07.
//

import UIKit

class TaskController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var task: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .done, target: self, action: #selector(deleteTask))
    }

    @objc func deleteTask() {
    }
}
