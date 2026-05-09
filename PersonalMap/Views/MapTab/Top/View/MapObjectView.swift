import SwiftUI
import MapKit
import UIKit

public class UIMapObjectView: UIView {
    private lazy var mapView = MKMapView()
    weak public var delegate: UIMapObjectViewDelegate?
    private var currentTileType: MapTileType = .none
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mapView.delegate = self
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

        let annotation = CustomAnnotation()
        annotation.id = polygon.id
        annotation.imageName = polygon.imageName
        annotation.coordinate = polygon.centroid
        annotation.title = polygon.objectName
        mapView.addAnnotation(annotation)
    }
    
    // Remove All Annotation
    func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    // Remove data overlays (polylines, polygons, route) but keep tile overlays
    func removeDataOverlays() {
        for overlay in mapView.overlays where !(overlay is MKTileOverlay) {
            mapView.removeOverlay(overlay)
        }
    }

    // Remove only tile overlays
    func removeTileOverlays() {
        for overlay in mapView.overlays where overlay is MKTileOverlay {
            mapView.removeOverlay(overlay)
        }
    }
    
    func changeMapType(mapType: MKMapType) {
        mapView.mapType = mapType
    }

    func returnToCurrentLocation() {
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }
    
    // MapTile: only update when type actually changes
    func setMapTileIfNeeded(mapTile: MapTileType) {
        guard currentTileType != mapTile else { return }
        currentTileType = mapTile
        removeTileOverlays()
        guard let config = mapTile.config else { return }
        let overlay = ScalableTileOverlay(
            urlTemplate: config.urlTemplate,
            maxNativeZ: config.maxNativeZ
        )
        overlay.minimumZ = config.minimumZ
        overlay.maximumZ = config.maximumZ
        mapView.addOverlay(overlay)
    }
    
    func drawRoute(route: Route) {
        let sourceLocation = route.source
        let destinationLocation = route.destination
        
        // calc direction
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)

        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
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
                .init{ [weak self] _ in self?.delegate?.annotationTapped(mapObjectId: mapObjectId) }, for: .touchUpInside)
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
        
        if let tile = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer.init(overlay: tile)
        }
        
        return MKOverlayRenderer()
    }
    
}

public struct MapObjectView: UIViewRepresentable {
    @Binding var mapObjects: [MapObject]
    @Binding var mapType: MKMapType
    @Binding var mapTileType: MapTileType
    @Binding var route: Route?
    @Binding var shouldReturnToLocation: Bool

    let annotationTapped: (_ mapObjectId: UUID) -> Void
    let longPressEnded: (_ location: CLLocationCoordinate2D) -> Void
    let routeNotFound: () -> Void
    
    final public class Coordinator: NSObject, UIMapObjectViewDelegate {
        private var mapView: MapObjectView
        let annotationTapped: (_ mapObjectId: UUID) -> Void
        let longPressEnded: (_ location: CLLocationCoordinate2D) -> Void
        let onRouteNotFound: () -> Void

        init(
            _ mapView: MapObjectView,
            annotationTapped: @escaping (_ mapObjectId: UUID) -> Void,
            longPressEnded: @escaping (_ location: CLLocationCoordinate2D) -> Void,
            onRouteNotFound: @escaping () -> Void
        ) {
            self.mapView = mapView
            self.annotationTapped = annotationTapped
            self.longPressEnded = longPressEnded
            self.onRouteNotFound = onRouteNotFound
        }

        public func annotationTapped(mapObjectId: UUID) {
            self.annotationTapped(mapObjectId)
        }

        public func longPressEnded(location: CLLocationCoordinate2D) {
            self.longPressEnded(location)
        }

        public func routeNotFound() {
            self.onRouteNotFound()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self, annotationTapped: annotationTapped, longPressEnded: longPressEnded, onRouteNotFound: routeNotFound)
    }
    
    public func makeUIView(context: Context) -> UIMapObjectView {
        let mapView = UIMapObjectView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: UIMapObjectView, context: Context) {
        // Clear annotations and data overlays (tile overlays are managed separately)
        uiView.removeAllAnnotations()
        uiView.removeDataOverlays()

        // Set map type
        uiView.changeMapType(mapType: mapType)

        // Update tile overlay only when type changes (tracked inside UIMapObjectView)
        uiView.setMapTileIfNeeded(mapTile: mapTileType)
        
        for mapObject in mapObjects {
            if mapObject.isHidden {
                continue
            }
            
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

        if shouldReturnToLocation {
            uiView.returnToCurrentLocation()
            DispatchQueue.main.async { shouldReturnToLocation = false }
        }
    }
}
