//
//  MVVMNewsTableViewCell.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/16.
//

import UIKit
import Alamofire

class MVVMNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
