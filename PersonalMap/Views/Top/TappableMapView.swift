import SwiftUI
import MapKit
import UIKit

public protocol TapplableMapViewDelegate: AnyObject {
    func mapViewDidTap(location: CLLocationCoordinate2D)
}

public class TapplableMapView: UIView, MKMapViewDelegate {
    private lazy var mapView = MKMapView()
    weak public var delegate: TapplableMapViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(onTap(sender:)))
        
        mapView.addGestureRecognizer(tapGestureRecognizer)
        mapView.delegate = self
        addSubview(mapView)
    }
    
    public override func layoutSubviews() {
        mapView.frame =  CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    @objc func onTap(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: mapView)
        let location = mapView.convert(tapPoint, toCoordinateFrom: mapView)
        delegate?.mapViewDidTap(location: location)
    }
    
    // Anotation
    func addAnnotation(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }
    
    func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    // PolyLine
    func addPolyLine(locations: [CLLocationCoordinate2D]) {
        let polyLine = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyLine)
    }
    
    func removeAllPolyLines() {
        for overlay in mapView.overlays {
            mapView.removeOverlay(overlay)
        }
    }
    
    func changeMapType(mapType: MKMapType) {
        mapView.mapType = mapType
    }
    
    // Delegate Methods
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            polylineRenderer.strokeColor = .blue
            polylineRenderer.lineWidth = 2.0
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
}

public struct MapView: UIViewRepresentable {
    @Binding var mapObjects: [MapObject]
    @Binding var mapType: MKMapType
    
    let mapViewDidTap: (_ location: CLLocationCoordinate2D) -> Void
    final public class Coordinator: NSObject, TapplableMapViewDelegate {
        private var mapView: MapView
        let mapViewDidTap: (_ location: CLLocationCoordinate2D) -> Void
        
        init(_ mapView: MapView, mapViewDidTap: @escaping (_ location: CLLocationCoordinate2D) -> Void) {
            self.mapView = mapView
            self.mapViewDidTap = mapViewDidTap
        }
        
        public func mapViewDidTap(location: CLLocationCoordinate2D) {
            mapViewDidTap(location)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, mapViewDidTap: mapViewDidTap)
    }
    
    public func makeUIView(context: Context) -> TapplableMapView {
        let mapView = TapplableMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: TapplableMapView, context: Context) {
        // Clear
        uiView.removeAllAnnotations()
        uiView.removeAllPolyLines()
        
        // Set
        uiView.changeMapType(mapType: mapType)
        
        for mapObject in mapObjects {
            switch mapObject {
            case let .point(point):
                if point.isHidden {
                    continue
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = point.location
                annotation.title = point.layerName
                uiView.addAnnotation(annotation)
            case let .line(line):
                uiView.addPolyLine(locations: line.locations)
                break
            }
        }
    }
}
