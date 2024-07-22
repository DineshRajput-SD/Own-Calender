//

//  Created by Dinesh Rajput on 06/03/24.
//

import UIKit

class MeetingWithClientCell: UITableViewCell {
    
    // MARK: - IBoutlets Properties
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var meetingWithClientTitleLabel: UILabel!
    @IBOutlet weak var reminderTitleLabel: UILabel!
    @IBOutlet weak var meetingTimeLabel: UILabel!
    
    // MARK: - Properties
    var threeDotCallback: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBAction Method
    @IBAction func threeDotButtonAction(_ sender: UIButton) {
        threeDotCallback?()
    }
}
