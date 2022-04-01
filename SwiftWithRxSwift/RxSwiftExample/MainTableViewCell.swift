//
//  MainTableViewCell.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2021/12/28.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class MainTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var age: UILabel!
    
    func setData(_ data: Member) {
        loadImage(from: data.avatar)
            .observe(on: MainScheduler.instance)
            .bind(to: avatar.rx.image)
            .disposed(by: disposeBag)
        avatar.image = nil
        name.text = data.name
        job.text = data.job
        age.text = "\(data.age)"
    }
    
    var disposeBag = DisposeBag()
    
    private func loadImage(from url: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            
     
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }
                print("data: \(data)")
                print("image: \(image)")
                
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
