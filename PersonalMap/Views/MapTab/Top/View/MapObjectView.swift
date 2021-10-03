import SwiftUI
import MapKit
import UIKit

public class UIMapObjectView: UIView {
    private lazy var mapView = MKMapView()
    weak public var delegate: UIMapObjectViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mapView.delegate = self
        addSubview(mapView)
    }
    
    public override func layoutSubviews() {
        mapView.frame =  CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    // Point
    func addPoint(point: MapPoint) {
        if point.isHidden {
            return
        }
        let annotation = CustomAnnotation()
        annotation.id = point.id
        annotation.coordinate = point.coordinate.locationCoordinate2D
        annotation.title = point.objectName
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
            annotation.title = polyLine.objectName
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
            annotation.title = polygon.objectName
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

extension UIMapObjectView: MKMapViewDelegate {
    // Delegate Methods
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? CustomAnnotation,
           let mapObjectId = customAnnotation.id {
            // MKPinAnnotationViewを宣言
            let annoView = MKMarkerAnnotationView()
            // MKPinAnnotationViewのannotationにMKAnnotationのAnnotationを追加
            annoView.annotation = annotation
            // ピンの画像を変更
            // annoView.image = UIImage(named: "icon")
            annoView.glyphImage = UIImage(systemName: "square.and.arrow.up")
            // 吹き出しを使用
            annoView.canShowCallout = true
            
            // 吹き出しにinfoボタンを表示
            let infoButton = UIButton()
            infoButton.addAction(
                .init{ [weak self] _ in self?.delegate?.anotationTapped(mapObjectId: mapObjectId) }, for: .touchUpInside)
            infoButton.frame.size = CGSize(width: 32, height: 32)
            infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
            annoView.rightCalloutAccessoryView = infoButton
            
            return annoView
        }
        
        
        return nil
        
    }
    
    
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
    
    //    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
    //        if let annotation = view.annotation as? CustomAnnotation,
    //           let mapObjectId = annotation.id {
    //            delegate?.anotationTapped(mapObjectId: mapObjectId)
    //        }
    //    }
}

public struct MapObjectView: UIViewRepresentable {
    @Binding var mapObjects: [MapObject]
    @Binding var mapType: MKMapType
    
    let anotationTapped: (_ mapObjectId: UUID) -> Void
    final public class Coordinator: NSObject, UIMapObjectViewDelegate {
        private var mapView: MapObjectView
        let anotationTapped: (_ mapObjectId: UUID) -> Void
        
        init(_ mapView: MapObjectView, anotationTapped: @escaping (_ mapObjectId: UUID) -> Void) {
            self.mapView = mapView
            self.anotationTapped = anotationTapped
        }
        
        public func anotationTapped(mapObjectId: UUID) {
            anotationTapped(mapObjectId)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, anotationTapped: anotationTapped)
    }
    
    public func makeUIView(context: Context) -> UIMapObjectView {
        let mapView = UIMapObjectView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: UIMapObjectView, context: Context) {
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
