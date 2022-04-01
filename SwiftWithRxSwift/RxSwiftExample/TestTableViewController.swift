//
//  TestTableViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2021/12/28.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

let LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

struct Member: Decodable {
    let id: Int
    let name: String
    let avatar: String
    let job: String
    let age: Int
}

class TestTableViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    var data: [Member] = [] {
        didSet {
            print(data.count)
        }
    }
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
     
        loadMembers()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] members in
                guard let self = self else {return}
                self.data = members
                self.mainTableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    func loadMembers() -> Observable<[Member]> {
        return Observable.create { emitter in
            AF.request(LIST_URL, method: .get, headers: nil).validate()
                .responseDecodable(of: [Member].self) { response in
                    switch response.result {
                    case .success(let data):
                        print("Success")
                        emitter.onNext(data)
                    case .failure(let error):
                        print("Failure")
                        emitter.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}

extension TestTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        let item = self.data[indexPath.row]
        cell.setData(item)
        return cell
    }
    
    
}
