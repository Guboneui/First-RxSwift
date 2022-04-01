//
//  Step2MainTableViewCell.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/03/29.
//

import UIKit
import RxSwift
import RxCocoa

class Step2MainTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var age: UILabel!
    
    func setData(_ data: MemberList) {
        self.loadImage(from: data.avatar)
            .observe(on: MainScheduler.instance)
            .bind(to: avatar.rx.image)
            .disposed(by: disposeBag)
        //avatar.image = nil
        name.text = data.name
        job.text = data.job
        age.text = "\(data.age)"
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private func loadImage(from url: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                guard let data = data,
                      let image = UIImage(data: data) else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }
                
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
            
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
