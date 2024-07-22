//
//  TimeSlotTableViewCell.swift
//  Vidhik
//
//  Created by NumeroEins on 13/02/24.
//

import UIKit

class TimeSlotTableViewCell: UITableViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var slotCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setCollectionView()
    }
    
    func configure() {
        self.collectionHeight.constant = self.slotCollectionView.contentSize.height
            self.slotCollectionView.reloadData()
            self.slotCollectionView.layoutIfNeeded()
        }

    private func setCollectionView() {
        self.slotCollectionView.dataSource = self
        self.slotCollectionView.delegate = self
        self.slotCollectionView.register(UINib(nibName: "TimeSlotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeSlotCollectionViewCell")
    }
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension TimeSlotTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = slotCollectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as! TimeSlotCollectionViewCell
       
        return cell
    }

}
