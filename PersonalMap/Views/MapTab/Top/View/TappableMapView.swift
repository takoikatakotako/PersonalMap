import SwiftUI
import MapKit
import UIKit

public protocol TapplableMapViewDelegate: AnyObject {
    func mapViewDidTap(location: CLLocationCoordinate2D)
}

class CustomAnnotation: MKPointAnnotation {
    var id: UUID? = nil
}

public class UITapplableMapView: UIView {
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
    
    // Point
    func addPoint(point: MapPoint) {
        if point.isHidden {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = point.coordinate.locationCoordinate2D
        annotation.title = point.layerName
        mapView.addAnnotation(annotation)
    }
    
    // PolyLine
    func addPolyLine(polyLine: MapPolyLine) {
        if polyLine.isHidden {
            return
        }
        let locations = polyLine.locationCoordinate2Ds
        let mkPolyLine = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(mkPolyLine)
        
        // Anotations
        for location in locations {
            let annotation = CustomAnnotation()
            annotation.id = polyLine.id
            annotation.coordinate = location
            annotation.title = polyLine.layerName
            mapView.addAnnotation(annotation)
        }
    }
    
    // Polygon
    func addPolygon(polygon: MapPolygon) {
        if polygon.isHidden {
            return
        }
        let locations = polygon.locationCoordinate2Ds
        let mkPolygon = MKPolygon(coordinates: locations, count: locations.count)
        mapView.addOverlay(mkPolygon)
        
        // Anotations
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = polygon.layerName
            mapView.addAnnotation(annotation)
        }
    }
    
    // Remove All Annotation
    func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    // Remove All Overlay
    func removeAllOverlays() {
        for overlay in mapView.overlays {
            mapView.removeOverlay(overlay)
        }
    }
    
    func changeMapType(mapType: MKMapType) {
        mapView.mapType = mapType
    }
}

extension UITapplableMapView: MKMapViewDelegate {
    // Delegate Methods
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.strokeColor = .yellow
            circleRenderer.fillColor = .yellow
            circleRenderer.lineWidth = 2.0
            return circleRenderer
        }
        
        if let polyline = overlay as? MKPolyline {
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            polylineRenderer.strokeColor = .blue
            polylineRenderer.lineWidth = 2.0
            return polylineRenderer
        }
        
        if let polygone = overlay as? MKPolygon {
            let polylineRenderer = MKPolygonRenderer(polygon: polygone)
            polylineRenderer.strokeColor = .orange
            polylineRenderer.lineWidth = 2.0
            polylineRenderer.fillColor = .orange
            polylineRenderer.alpha = 0.2
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if let customAnnotation = view.annotation as? CustomAnnotation,
           let customAnnotationId = customAnnotation.id {
            print(customAnnotationId)
        }
    }
}

public struct TapplableMapView: UIViewRepresentable {
    @Binding var mapObjects: [MapObject]
    @Binding var mapType: MKMapType
    
    let mapViewDidTap: (_ location: CLLocationCoordinate2D) -> Void
    final public class Coordinator: NSObject, TapplableMapViewDelegate {
        private var mapView: TapplableMapView
        let mapViewDidTap: (_ location: CLLocationCoordinate2D) -> Void
        
        init(_ mapView: TapplableMapView, mapViewDidTap: @escaping (_ location: CLLocationCoordinate2D) -> Void) {
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
    
    public func makeUIView(context: Context) -> UITapplableMapView {
        let mapView = UITapplableMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: UITapplableMapView, context: Context) {
        // Clear
        uiView.removeAllAnnotations()
        uiView.removeAllOverlays()

        // Set
        uiView.changeMapType(mapType: mapType)
        
        for mapObject in mapObjects {
            switch mapObject {
            case let .point(point):
                uiView.addPoint(point: point)
            case let .polyLine(polyLine):
                uiView.addPolyLine(polyLine: polyLine)
            case let .polygon(polygon):
                uiView.addPolygon(polygon: polygon)
            }
        }
    }
}
