//
//  PoiViewCell.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 13/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class PoiViewCell: UITableViewCell {

    @IBOutlet weak var fleetTypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var viewModel = MutableProperty<PoiCellViewModel?>(nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()

        fleetTypeLabel.reactive.text <~ viewModel.map { $0?.fleetType}
        locationLabel.reactive.text <~ viewModel.map { $0?.location}

//        viewModel.producer
//            .observe(on: UIScheduler())
//            .startWithValues {
//                guard let val = $0 else { return }
//            self.fleetTypeLabel.text = val.fleetType
//            self.locationLabel.text = val.location
//        }
    }
}
