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
    @IBOutlet weak var applyFilterButton: UIButton!
    
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
            //self.photoImageView.image = photo
            
            DispatchQueue.main.async {
                self.updateUI(with: photo)
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }
    
    
    @IBAction func applyFilterButtonAction(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image else {return}
        FiltersService().applyFilter(to: sourceImage) { filteredImage in
            DispatchQueue.main.async {
                self.photoImageView.image = filteredImage
            }
        }
    }
    
}
