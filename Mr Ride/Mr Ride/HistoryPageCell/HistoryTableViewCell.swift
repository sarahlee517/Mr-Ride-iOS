//
//  HistoryTableViewCell.swift
//  Mr Ride
//
//  Created by Sarah on 5/27/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!

    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
//MARK: - Setup UI
extension HistoryTableViewCell{
    func setupCell() {
        cellView.backgroundColor = UIColor.mrPineGreen85Color()
        self.backgroundColor = UIColor.clearColor()
//        self.tintColor = UIColor.clearColor()
        totalTimeLabel.textColor = UIColor.mrWhiteColor()
        distanceLabel.textColor = UIColor.mrWhiteColor()
        dateLabel.textColor = UIColor.mrWhiteColor()
        layoutMargins = UIEdgeInsetsZero
    }
    
}
