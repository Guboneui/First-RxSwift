//
//  NewsTableViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/14.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import Alamofire

class NewsTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        populateNews()

    }
    
    private func populateNews() {
        
//
//        let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=51ac15cf484c4caa9a51b27a97602024"
//        AF.request(url, method: .get, headers: nil)
//            .validate()
//            .responseDecodable(of: ArticlesList.self) { response in
//                switch response.result {
//                case .success(let response):
//                    print(response)
//                case .failure(let error):
//                    print(error)
//                }
//
//            }
        
        //let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=51ac15cf484c4caa9a51b27a97602024")!
        //let resource = Resource<ArticlesList>(url: url)
        
//        URLRequest.load(resource: ArticlesList.all)
//            .subscribe(onNext: {[weak self] result in
//                if let result = result {
//                    self?.articles = result.articles
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//                }
//            }).disposed(by: disposeBag)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.titleLabel.text = self.articles[indexPath.row].title
        cell.descriptionLabel.text = self.articles[indexPath.row].description
        return cell
    }
}
