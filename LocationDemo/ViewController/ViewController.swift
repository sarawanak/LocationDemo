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

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- Properties
    var viewModel: MapViewModel! {
        didSet {
            updateUiOnEvent()
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
        let detailVC = PoiListViewController(nibName: "PoiListViewController", bundle: nil)
//        detailVC.viewModel = PoiListViewModel(poiWrapper: viewModel!.poiWrapper)
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
    
//    fileprivate func fetchPois(for request: URLRequest) {
//        NetworkInterface.shared.process(request: request) { (parse: Parsable) in
//            do {
//                let data = try parse()
//                let poiWrapper = try JSONDecoder().decode(PoiWrapper.self, from: data)
//                self.viewModel = MapViewModel(poiWrapper: poiWrapper)
//            } catch let ee {
//                print(ee)
//            }
//        }
//    }

//    func getPoi(for request: URLRequest) {
//        let poiProducer = NetworkInterface.shared.process(request: request)
//
//        poiProducer.producer.start { (event) in
//            switch event {
//            case let .value(data):
//                guard let poiWrapper = try? JSONDecoder().decode(PoiWrapper.self, from: data) else {
//                    return
//                }
//                self.viewModel = MapViewModel(poiWrapper: poiWrapper)
//            case let .failed(error):
//                ()
//            case .interrupted:
//                ()
//            case .completed:
//                ()
//            }
//        }
//    }

    func updateUiOnEvent() {
        viewModel.annotationsArray.producer
            .observe(on: UIScheduler())
            .startWithValues { values in
            values
                .forEach { [unowned self](annotation) in
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
//    fileprivate func createRequestAndFetchPoi(_ tlCoordinate: CLLocationCoordinate2D, _ brCoordinate: CLLocationCoordinate2D) {
//        if let vm = viewModel {
//            mapView.removeAnnotations(vm.annotationsArray.value)
//        }
//
//        do {
//            let request = try PoiRequest.create(
//                tlCoordinate: tlCoordinate.coordinate,
//                brCoordinate: brCoordinate.coordinate)
//            getPoi(for: request)
//        } catch let error {
//            print(error)
//        }
//    }

    private func setDefaultLocation() {
        mapView.setRegion(defaultVisibleRegion, animated: true)
    }
    
    private func getCoordinatePairForVisibleRegion(mapView: MKMapView) -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
        let tl = view.frame.origin
        let br = CGPoint(x: view.frame.maxX, y: view.frame.maxY)
        let topLeftCoord = mapView.convert(tl, toCoordinateFrom: view)
        let bottomRightCoord = mapView.convert(br, toCoordinateFrom: view)

        return (topLeftCoord, bottomRightCoord)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let tl = view.frame.origin
        let br = CGPoint(x: view.frame.maxX, y: view.frame.maxY)
        
        let topLeftCoord = mapView.convert(tl, toCoordinateFrom: view)
        let bottomRightCoord = mapView.convert(br, toCoordinateFrom: view)
        
        //createRequestAndFetchPoi(topLeftCoord, bottomRightCoord)
        mapView.removeAnnotations(viewModel.annotationsArray.value)
        viewModel?.currentCoordinate.value = VisibleRegion(topLeft: topLeftCoord, bottomRight: bottomRightCoord)
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

extension CLLocationCoordinate2D {
    var coordinate: Coordinate {
        return Coordinate(latitude: latitude, longitude: longitude)
    }
}
