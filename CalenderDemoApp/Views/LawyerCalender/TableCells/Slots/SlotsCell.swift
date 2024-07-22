
//  Created by Dinesh Rajput on 06/03/24.
//

import UIKit

class SlotsCell: UITableViewCell {
    
    // MARK: - IBOutlets Properties
    @IBOutlet weak var slotCollectionView: UICollectionView!
    @IBOutlet weak var availableDateLabel: UILabel!
    
    var dateSlots: DateSlot?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slotCollectionView.dataSource = self
        slotCollectionView.delegate = self
        self.slotCollectionView.register(UINib(nibName: "TimeSlotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeSlotCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        print("Edit Button")
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        print("Delete Button")
    }
}

// MARK: - CollectionView Data Source Methods

extension SlotsCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dateSlots?.slots.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numerSlot = dateSlots?.slots.count else {
            return 0
        }
        return numerSlot
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as! TimeSlotCollectionViewCell
        
        cell.slotView.backgroundColor = .blue
        cell.lblTimeSlot.text = "6PM - 7PM"
        return cell
    }
    
    func set(dateSlot: DateSlot) {
        self.dateSlots = dateSlot
    }
}

// MARK: - UICollectionView Delegate Methods
extension SlotsCell: UICollectionViewDelegate {
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SlotsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 3) - 20
        return CGSize(width: scaleFactor, height: 50.0)
    }
}

//MARK: - Created AvailableTime Slot Model

struct AvailableTimeSlotModel {
    var availableDate: String?
    var availableTimeSlot: [AvailableTimeSlot]?
}

struct AvailableTimeSlot {
    var time: String?
    
}
