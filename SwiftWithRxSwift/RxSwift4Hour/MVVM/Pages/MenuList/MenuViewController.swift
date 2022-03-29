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

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    let cellID = "MenuItemTableViewCell"
    let viewModel: MenuListViewModel = MenuListViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        self.viewModel.itemCount
//            .map{ "\($0)" }
//            .subscribe(onNext: {
//                self.itemCountLabel.text = $0
//            }).disposed(by: disposeBag)
        
        viewModel.menuObservable
            .bind(to: self.tableView.rx.items(cellIdentifier: self.cellID, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"

            }.disposed(by: disposeBag)
        
        
        self.viewModel.itemCount
            .map{"\($0)"}
            .observe(on: MainScheduler.instance)
            .bind(to: self.itemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.totalPrice
            .map{ $0.currencyKR() }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.totalPrice.text = $0
            }).disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            // TODO: pass selected menus
        }
    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
    }

    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
        // showAlert("Order Fail", "No Orders")
        //performSegue(withIdentifier: "OrderViewController", sender: nil)
        
        //self.viewModel.totalPrice += 100
    }
    
}
