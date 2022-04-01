//
//  BaseRxSwiftCodeViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/29.
//

import UIKit


class 나중에생기는데이터<T> {
    private let task: (@escaping (T) -> Void) -> Void
    
    init(task: @escaping (@escaping (T) -> Void) -> Void) {
        self.task = task
    }
    
    func 나중에오면(_ f: @escaping (T) -> Void) {
        task(f)
    }
}


class BaseRxSwiftCodeViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
        
    }
    
    
    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else {return}
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    private func downloadJson(_ url: String) -> 나중에생기는데이터<String?> {
        return 나중에생기는데이터() { f in
            DispatchQueue.global().async {
                let url = URL(string: url)!
                let data = try! Data(contentsOf: url)
                let json = String(data: data, encoding: .utf8)
                DispatchQueue.main.async {
                    f(json)
                }
            }
        }
       
    }
    
    
    
    @IBAction func loadButtonClicked(_ sender: Any) {
        
        self.mainTextView.text = ""
        self.setVisibleWithAnimation(self.activityIndicator, true)
        
        let json: 나중에생기는데이터<String?> = self.downloadJson(TEST_URL)
        json.나중에오면 { json in
            self.mainTextView.text = json
            self.setVisibleWithAnimation(self.activityIndicator, false)
        }
    }
    
    
    
    

}
