//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

class MenuViewController: UIViewController {
//    // MARK: - Life Cycle
//    let cellID = "MenuItemTableViewCell"
//    let viewModel: MenuListViewModel = MenuListViewModel()
//    var disposeBag: DisposeBag = DisposeBag()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        self.viewModel.itemCount
////            .map{ "\($0)" }
////            .subscribe(onNext: {
////                self.itemCountLabel.text = $0
////            }).disposed(by: disposeBag)
//
//        viewModel.menuObservable
//            .bind(to: self.tableView.rx.items(cellIdentifier: self.cellID, cellType: MenuItemTableViewCell.self)) { index, item, cell in
//                cell.title.text = item.name
//                cell.price.text = "\(item.price)"
//                cell.count.text = "\(item.count)"
//
//                // TableViewCell에 대한 액션 또한 해당 스트림에서 동작한다.
//                cell.onChange = { [weak self] increase in
//                    self?.viewModel.changeCount(item: item, increase: increase)
//                }
//
//            }.disposed(by: disposeBag)
//
//
//        self.viewModel.itemCount
//            .map{"\($0)"}
//            .asDriver(onErrorJustReturn: "")
//            .drive(itemCountLabel.rx.text)
//            //.observe(on: MainScheduler.instance)
//            //.bind(to: self.itemCountLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        self.viewModel.totalPrice
//            .map{ $0.currencyKR() }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: {
//                self.totalPrice.text = $0
//            }).disposed(by: disposeBag)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let identifier = segue.identifier ?? ""
//        if identifier == "OrderViewController",
//            let orderVC = segue.destination as? OrderViewController {
//            // TODO: pass selected menus
//        }
//    }
//
//    func showAlert(_ title: String, _ message: String) {
//        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alertVC, animated: true, completion: nil)
//    }
//
//    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    let viewModel: MenuViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: MenuViewModelType = MenuListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = MenuListViewModel()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        setupBinding()
    }
    

    func setupBinding() {
        // 당겨서 새로고침 부분 -> UIRefreshControl()
        
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map{ _ in () }
        let reload = tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map{ _ in () } ?? Observable.just(())
        
        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchMenus)
            .disposed(by: disposeBag)
        
        
        // 처음 보일때 및 clear 버튼을 눌렀을 때
        let viewDidAppear = rx.viewWillAppear.map { _ in () }
        let whenClearTap = self.clearButton.rx.tap.map { _ in () }
        
        clearButton.rx.tap.asObservable().bind(onNext: {
            print("aaa")
        }).disposed(by: disposeBag)
        
        Observable.merge([viewDidAppear, whenClearTap])
            .bind(to: viewModel.clearSelections)
            .disposed(by: disposeBag)
        
        
        viewModel.activated
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] finished in
                if finished {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            })
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.allMenus
            .bind(to: tableView.rx.items(cellIdentifier: "MenuItemTableViewCell", cellType: MenuItemTableViewCell.self)) { _, item, cell in
                
                cell.onData.onNext(item)
                cell.onChanged
                    .map{
                        (item, $0)
                        
                    }
            
                    .bind(to: self.viewModel.increaseMenuCount)
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        viewModel.totalSelectedCountText
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalPriceText
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)

        
    }
}
