//
//  MVVMNewsViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/16.
//

import UIKit
import RxSwift
import RxCocoa

class MVVMNewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    let disposeBag = DisposeBag()
    private var articleListViewModel: ArticleListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        populateNews()
    }
    
    
    
    private func setTableView() {
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        self.newsTableView.estimatedRowHeight = 50
        self.newsTableView.rowHeight = UITableView.automaticDimension
        self.newsTableView.register(UINib(nibName: "MVVMNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "MVVMNewsTableViewCell")
    }
    
    private func populateNews() {
        let resource = MVVMResource<MVVMNewsArticleResponse>(url: URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2022-01-16&sortBy=popularity&apiKey=51ac15cf484c4caa9a51b27a97602024")!)
        URLRequest.mvvmLoad(resource: resource)
            .subscribe(onNext: { articleResponse in
                let articles = articleResponse.articles
                self.articleListViewModel = ArticleListViewModel(articles)
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
    


}

extension MVVMNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListViewModel == nil ? 0 : self.articleListViewModel.articlesVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVVMNewsTableViewCell", for: indexPath) as! MVVMNewsTableViewCell
        let articleVM = self.articleListViewModel.articleAt(indexPath.row)
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        return cell
    }
    
    
}
