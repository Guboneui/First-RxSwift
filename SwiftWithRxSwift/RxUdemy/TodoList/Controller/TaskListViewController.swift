//
//  TaskListViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/13.
//

import UIKit
import RxSwift
import RxRelay

class TaskListViewController: UIViewController {

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var mainTableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTask: [Task] = []
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        
        
     
    }
    
    @IBAction func priorityValueChanged(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: sender.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    

}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTask[indexPath.row].title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
              let addTVC = navController.viewControllers.first as? AddTaskViewController else {
                  fatalError("Controller not found..")
              }
        addTVC.taskSubjectObservable
            .subscribe(onNext: { [unowned self] task in
                
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                self.filterTasks(by: priority)
            }).disposed(by: disposeBag)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            self.filteredTask = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
                
            }.subscribe(onNext: { [weak self] tasks in
                guard let self = self else {return}
                self.filteredTask = tasks
                self.updateTableView()
                print(tasks)
                
            }).disposed(by: disposeBag)
        }

    }
    
    
}
