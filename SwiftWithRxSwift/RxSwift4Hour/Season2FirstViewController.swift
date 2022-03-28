//
//  Season2FirstViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/28.
//

import UIKit
import RxSwift
import SwiftyJSON

let TEST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class Season2FirstViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var editView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
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
    
   
    func downloadJson(_ url: String, _ completion: @escaping (String?) -> Void) {
        DispatchQueue.global().async {
            let url = URL(string: url)!
            let data = try! Data(contentsOf: url)
            let json = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(json)
            }
        }
    }
    
    
    @IBAction func onLoad(_ sender: Any) {
        editView.text = ""
        setVisibleWithAnimation(self.activityIndicator, true)
        
        self.downloadJson(TEST_URL) { json in
            self.editView.text = json
            self.setVisibleWithAnimation(self.activityIndicator, false)
        }
    }
}

