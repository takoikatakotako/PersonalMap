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
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        addSubview(mapView)
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressEnded))
        mapView.addGestureRecognizer(longTapGesture)
    }

    @objc func longPressEnded(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let tapPoint = sender.location(in: self)
            let location = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            delegate?.longPressEnded(location: location)
        }
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
        annotation.imageName = point.imageName
        annotation.coordinate = point.coordinate.locationCoordinate2D
        annotation.title = point.objectName
        mapView.addAnnotation(annotation)
    }
    
    // PolyLine
    func addPolyLine(polyLine: MapPolyline) {
        if polyLine.isHidden {
            return
        }
        let locations = polyLine.locationCoordinate2Ds
        let mkPolyLine = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(mkPolyLine)
        
        // Anotation
        if let location = locations.first {
            let annotation = CustomAnnotation()
            annotation.id = polyLine.id
            annotation.imageName = polyLine.imageName
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
        
        // 重心を求める
        var latitudeAverage: Double = 0
        var longitudeAverage: Double = 0
        for location in locations {
            latitudeAverage += location.latitude
            longitudeAverage += location.longitude
        }
        latitudeAverage /= Double(locations.count)
        longitudeAverage /= Double(locations.count)
        
        let polygonCenter = CLLocationCoordinate2D(latitude: latitudeAverage, longitude: longitudeAverage)
        let annotation = CustomAnnotation()
        annotation.id = polygon.id
        annotation.imageName = polygon.imageName
        annotation.coordinate = polygonCenter
        annotation.title = polygon.objectName
        mapView.addAnnotation(annotation)
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
    
    
    func drawRoute(route: Route) {
        let sourceLocation = route.source
        let destinationLocation = route.destination
        
        // calc direction
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.transportType = .walking
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destinationMapItem
        let direction = MKDirections(request: directionsRequest)
        direction.calculate { [weak self] response, error in
            guard let response = response, let route = response.routes.first else {
                self?.delegate?.routeNotFound()
                return
            }
            
            self?.mapView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
}

extension UIMapObjectView: MKMapViewDelegate {
    // Delegate Methods
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? CustomAnnotation,
           let mapObjectId = customAnnotation.id,
           let imageName = customAnnotation.imageName {
            // MKPinAnnotationViewを宣言
            let annoView = MKMarkerAnnotationView()
            // MKPinAnnotationViewのannotationにMKAnnotationのAnnotationを追加
            annoView.annotation = annotation
            // ピンの画像を変更
            annoView.glyphImage = UIImage(systemName: imageName)
            
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
    @Binding var route: Route?
    
    let anotationTapped: (_ mapObjectId: UUID) -> Void
    let longPressEnded: (_ location: CLLocationCoordinate2D) -> Void
    let routeNotFound2: () -> Void
    
    final public class Coordinator: NSObject, UIMapObjectViewDelegate {
        private var mapView: MapObjectView
        let anotationTapped: (_ mapObjectId: UUID) -> Void
        let longPressEnded: (_ location: CLLocationCoordinate2D) -> Void
        let routeNotFound3: () -> Void
        
        init(
            _ mapView: MapObjectView,
            anotationTapped: @escaping (_ mapObjectId: UUID) -> Void,
            longPressEnded: @escaping (_ location: CLLocationCoordinate2D) -> Void,
            xxxxx: @escaping () -> Void
        ) {
            self.mapView = mapView
            self.anotationTapped = anotationTapped
            self.longPressEnded = longPressEnded
            self.routeNotFound3 = xxxxx
        }
        
        public func anotationTapped(mapObjectId: UUID) {
            anotationTapped(mapObjectId)
        }
        
        public func longPressEnded(location: CLLocationCoordinate2D) {
            longPressEnded(location)
        }
        
        public func routeNotFound() {
            routeNotFound3()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, anotationTapped: anotationTapped, longPressEnded: longPressEnded, xxxxx: routeNotFound2)
    }
    
    public func makeUIView(context: Context) -> UIMapObjectView {
        let mapView = UIMapObjectView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: UIMapObjectView, context: Context) {
        
        print("Update")
        
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
        
        if let route = route {
            uiView.drawRoute(route: route)
        }
    }
}
