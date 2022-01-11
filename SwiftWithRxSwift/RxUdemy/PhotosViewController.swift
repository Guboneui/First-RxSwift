//
//  PhotosViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/11.
//

import UIKit
import RxSwift

class PhotosViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                  fatalError("sugue error")
              }
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            guard let self = self else {return}
            self.photoImageView.image = photo
        }).disposed(by: disposeBag)
    }

}
