//
//  Step2MainViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/29.
//

import UIKit
import RxSwift

let MEMBER_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

struct MemberList: Decodable {
    let id: Int
    let name: String
    let avatar: String
    let job: String
    let age: Int
}

class Step2MainViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var data: [MemberList] = []
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.register(UINib(nibName: "Step2MainTableViewCell", bundle: nil), forCellReuseIdentifier: "Step2MainTableViewCell")
        
        self.loadMembers()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] members in
                guard let self = self else { return }
                self.data = members
                self.mainTableView.reloadData()
            }).disposed(by: disposeBag)
        
        
    }
    
    private func loadMembers() -> Observable<[MemberList]> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: MEMBER_URL)!) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                guard let data = data,
                      let members = try? JSONDecoder().decode([MemberList].self, from: data) else {
                    emitter.onCompleted()
                    return
                }
                emitter.onNext(members)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

extension Step2MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Step2MainTableViewCell", for: indexPath) as! Step2MainTableViewCell
        let item = self.data[indexPath.row]
        cell.setData(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        //performSegue(withIdentifier: "Step2DetailViewController", sender: AnyObject)
    }
    
    
}
