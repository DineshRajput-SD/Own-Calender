//
//  ReminderTableViewCell.swift
//  Vidhik
//
//  Created by NumeroEins on 12/02/24.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var imgColor: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReminderType: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnOption: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
