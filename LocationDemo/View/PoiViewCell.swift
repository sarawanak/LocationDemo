//
//  PoiViewCell.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 13/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import UIKit

class PoiViewCell: UITableViewCell {

    @IBOutlet weak var fleetTypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var viewModel: PoiCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        fleetTypeLabel.text = viewModel.fleetType
        locationLabel.text = viewModel.location
    }
}
