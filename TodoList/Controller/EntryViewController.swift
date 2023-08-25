//
//  EntryViewController.swift
//  TodoList
//
//  Created by daelee on 2023/08/07.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var field: UITextField!
    
    var didAddHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        field.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(entryItemToTasks))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryItemToTasks()
        return true
    }
    
    @objc func entryItemToTasks() {
        let text = field.text!
        let item: TaskData = TaskData(text: text)
        
        print("Add Tasks title: \(item.text)")
        
        // TodoListViewController에 생성한 tasks 전역변수에 append
        tasks.append(item)
        
        // Done 버튼 클릭 시 새로운 TodoList 객체 생성
        // 생성한 객체에 입력한 정보 저장
        didAddHandler?()
        navigationController?.popViewController(animated: true)
    }
}
