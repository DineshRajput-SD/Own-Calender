//

//
//  Created by Dinesh Rajput on 06/03/24.
//

import UIKit

class AvailablityCell: UITableViewCell {
    
    var availableCallback: (() -> ())?
    var addAvailableCallback: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBAction Methods
    @IBAction func availableButtonAction(_ sender: UIButton) {
        availableCallback?()
    }
    
    @IBAction func addAvailableButtonAction(_ sender: UIButton) {
        addAvailableCallback?()
    }
}
