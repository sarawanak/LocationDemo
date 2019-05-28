//
//  ViewController.swift
//  LocationDemo
//
//  Created by Saravanakumar Selladurai on 03/03/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import UIKit
import MapKit
import ReactiveSwift
import Result

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- Properties
    var viewModel: MapViewModel! {
        didSet {
            addObservers()
        }
    }
    
    var defaultVisibleRegion: MKCoordinateRegion {
        let locationCoord = CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891)
        let coordSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        return MKCoordinateRegion(center: locationCoord, span: coordSpan)
    }
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MapViewModel()
        setupView()
    }

    @IBAction func detailsTapped(_ sender: Any) {
        guard let wrapper = viewModel.poiWrapper else { return }
        
        let detailVC = PoiListViewController(nibName: "PoiListViewController", bundle: nil)
        detailVC.viewModel = PoiListViewModel(poiWrapper: wrapper)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK:- Private methods
    func setupView() {
        //Configure MapView
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.delegate = self
        setDefaultLocation()
        
        //Configure Navbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }

    func addObservers() {
        viewModel
            .annotationsArray.producer
            .observe(on: UIScheduler())
            .startWithValues { values in
                values.forEach { [unowned self](annotation) in
                    self.mapView.addAnnotation(annotation)
                }
            }
    }

    private func setDefaultLocation() {
        mapView.setRegion(defaultVisibleRegion, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(viewModel.annotationsArray.value)
        viewModel?.currentCoordinate.value = VisibleRegion(
            topLeft: mapView.northWestCoordinate,
            bottomRight: mapView.southEastCoordinate
        )
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            annView.animatesWhenAdded = true
            annView.titleVisibility = .adaptive
           
            return annView
        }
        
        return nil
    }

    
}
