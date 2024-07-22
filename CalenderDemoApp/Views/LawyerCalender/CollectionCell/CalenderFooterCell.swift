//
//  CalenderFooterCell.swift
//  Vidhik
//
//  Created by Dinesh Rajput on 06/03/24.
//

import UIKit

class CalenderFooterCell: UICollectionViewCell {
    
    // MARK: -  Properties
    var editCallback: (() -> ())?
    var deleteCallback: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
// MARK: - IBAction Methods
    @IBAction func editButton(_ sender: UIButton) {
        editCallback?()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        deleteCallback?()
    }
}
