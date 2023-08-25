//
//  EntryViewController.swift
//  TodoList
//
//  Created by daelee on 2023/08/07.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet var field: UITextField!
    var selectedCategory = "내일배움캠프"
    // var didAddHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configPopUpButton()
    }
    
    private func configureViews() {
        field.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(entryItemToTasks))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryItemToTasks()
        return true
    }
    
    private func configPopUpButton() {
        let categoryButtonClosure = { (action: UIAction) in
            self.selectedCategory = action.title // 선택된 카테고리 저장
            print("Selected menu: \(action.title)")
        }
        
        categoryButton.menu = UIMenu(title: "카테고리", children: [
            UIAction(title: "내일배움캠프", handler: categoryButtonClosure),
            UIAction(title: "개인 프로젝트", handler: categoryButtonClosure),
            UIAction(title: "일상", handler: categoryButtonClosure),
            UIAction(title: "여행", handler: categoryButtonClosure),
        ])
        
        categoryButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func entryItemToTasks() {
        let text = field.text!
        let newTask: TaskData = TaskData(text: text, isDone: false, category: selectedCategory)
        
        print("Add Tasks title: \(newTask.text), categoty: \(newTask.category)")
        
        // TodoListViewController에 생성한 tasks 전역변수에 append
        tasks.append(newTask)
        
        // didAddHandler?()
        navigationController?.popViewController(animated: true)
    }
}
