import SwiftUI
import MapKit
import UIKit

public protocol LocationsSelectViewDelegate: AnyObject {
    func locationDidSet(locations: [CLLocationCoordinate2D])
}

public class UILocationsSelectView: UIView {
    private lazy var mapView = MKMapView()
    private lazy var locations: [CLLocationCoordinate2D] = []
    weak public var delegate: LocationsSelectViewDelegate?
    
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
        
        let circle = MKCircle(center: location, radius: 10000)
        mapView.addOverlay(circle)
        
        locations.append(location)
        delegate?.locationDidSet(locations: locations)
    }
    
    func changeMapType(mapType: MKMapType) {
        mapView.mapType = mapType
    }
}

extension UILocationsSelectView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.strokeColor = .black
            circleRenderer.fillColor = .black
            circleRenderer.lineWidth = 2.0
            return circleRenderer
        }
        return MKOverlayRenderer()
    }
}

public struct LocationsSelectView: UIViewRepresentable {
    @Binding var mapType: MKMapType
    
    let locationDidSet: (_ locations: [CLLocationCoordinate2D]) -> Void
    final public class Coordinator: NSObject, LocationsSelectViewDelegate {
        private var mapView: LocationsSelectView
        let locationDidSet: (_ locations: [CLLocationCoordinate2D]) -> Void
        
        init(_ mapView: LocationsSelectView, locationDidSet: @escaping (_ locations: [CLLocationCoordinate2D]) -> Void) {
            self.mapView = mapView
            self.locationDidSet = locationDidSet
        }
        
        public func locationDidSet(locations: [CLLocationCoordinate2D]) {
            locationDidSet(locations)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, locationDidSet: locationDidSet)
    }
    
    public func makeUIView(context: Context) -> UILocationsSelectView {
        let mapView = UILocationsSelectView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: UILocationsSelectView, context: Context) {
        // Set
        uiView.changeMapType(mapType: mapType)
    }
}
