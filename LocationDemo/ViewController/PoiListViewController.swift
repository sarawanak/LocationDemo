//
//  PoiListViewController.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 13/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class PoiListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: PoiListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 90
        tableView.register(
            UINib(nibName: "PoiViewCell", bundle: nil),
            forCellReuseIdentifier: PoiViewCell.description()
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        tableView.reloadData()
    }
}

extension PoiListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.poiData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PoiViewCell.description()
            ) as? PoiViewCell else { return UITableViewCell() }
        
        cell.viewModel.value = viewModel.poiData[indexPath.row]
//        cell.configure()

        return cell
    }
}

extension PoiListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
