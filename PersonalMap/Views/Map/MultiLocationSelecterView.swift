import SwiftUI
import MapKit
import UIKit

public protocol MultiLocationSelecterViewDelegate: AnyObject {
    func locationDidSet(locations: [CLLocationCoordinate2D])
}

public class UIMultiLocationSelecterView: UIView {
    public var locationLimit: Int?
    private lazy var mapView = MKMapView()
    private lazy var locations: [CLLocationCoordinate2D] = []
    weak public var delegate: MultiLocationSelecterViewDelegate?
    
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

extension UIMultiLocationSelecterView: MKMapViewDelegate {
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

public struct MultiLocationSelecterView: UIViewRepresentable {
    @Binding var mapType: MKMapType
    
    let locationDidSet: (_ locations: [CLLocationCoordinate2D]) -> Void
    final public class Coordinator: NSObject, MultiLocationSelecterViewDelegate {
        private var mapView: MultiLocationSelecterView
        let locationDidSet: (_ locations: [CLLocationCoordinate2D]) -> Void
        
        init(_ mapView: MultiLocationSelecterView, locationDidSet: @escaping (_ locations: [CLLocationCoordinate2D]) -> Void) {
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
    
    public func makeUIView(context: Context) -> UIMultiLocationSelecterView {
        let locationsSelectView = UIMultiLocationSelecterView()
        locationsSelectView.delegate = context.coordinator
        return locationsSelectView
    }
    
    public func updateUIView(_ uiView: UIMultiLocationSelecterView, context: Context) {
        // Set
        uiView.changeMapType(mapType: mapType)
    }
}
