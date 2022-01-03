//
//  DirayCell.swift
//  Diary
//
//  Created by Terry on 2022/01/03.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet var titleLb: UILabel!
    @IBOutlet var dateLb: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //CollectionView Cell 테두리 설정
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
