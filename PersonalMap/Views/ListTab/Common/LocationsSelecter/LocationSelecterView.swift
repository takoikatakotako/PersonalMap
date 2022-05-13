import SwiftUI
import MapKit

public protocol LocationsSelecterViewDelegate: AnyObject {
    func locationDidSet(location: CLLocationCoordinate2D)
}

public class UILocationsSelecterView: UIView {
    public var locationLimit: Int?
    private lazy var mapView = MKMapView()
    weak public var delegate: LocationsSelecterViewDelegate?

    private let verticalLine = CAShapeLayer()
    private let horizontalLine = CAShapeLayer()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        mapView.delegate = self
        addSubview(mapView)
        
        // 位置情報が取得できる場合は設定する
        if let location = LocationManager.shared.lastKnownLocation {
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }

        verticalLine.fillColor = nil
        verticalLine.opacity = 1.0
        verticalLine.strokeColor = UIColor.black.cgColor
        layer.addSublayer(verticalLine)

        horizontalLine.fillColor = nil
        horizontalLine.opacity = 1.0
        horizontalLine.strokeColor = UIColor.black.cgColor
        layer.addSublayer(horizontalLine)
    }

    public override func layoutSubviews() {
        mapView.frame =  CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)

        let verticalLinePath = UIBezierPath()
        verticalLinePath.move(to: CGPoint(x: (bounds.width / 2) - 50, y: bounds.height / 2))
        verticalLinePath.addLine(to: CGPoint(x: (bounds.width / 2) + 50, y: bounds.height / 2))
        verticalLine.path = verticalLinePath.cgPath

        let horizontalLinePath = UIBezierPath()
        horizontalLinePath.move(to: CGPoint(x: bounds.width / 2, y: (bounds.height / 2) - 50))
        horizontalLinePath.addLine(to: CGPoint(x: bounds.width / 2, y: (bounds.height / 2) + 50))
        horizontalLine.path = horizontalLinePath.cgPath
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
    
    // Anotation
    func addAnotation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "lat: \(location.latitude), lon: \(location.longitude)"
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
}

extension UILocationsSelecterView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocationCoordinate2D(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
        delegate?.locationDidSet(location: location)
    }
}

public struct LocationSelecterView: UIViewRepresentable {
    let locations: [CLLocationCoordinate2D]
    @Binding var mapObjects: [MapObject]

    let locationDidSet: (_ location: CLLocationCoordinate2D) -> Void
    final public class Coordinator: NSObject, LocationsSelecterViewDelegate {
        private var mapView: LocationSelecterView
        let locationDidSet: (_ location: CLLocationCoordinate2D) -> Void

        init(_ mapView: LocationSelecterView, locationDidSet: @escaping (_ location: CLLocationCoordinate2D) -> Void) {
            self.mapView = mapView
            self.locationDidSet = locationDidSet
        }

        public func locationDidSet(location: CLLocationCoordinate2D) {
            locationDidSet(location)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self, locationDidSet: locationDidSet)
    }

    public func makeUIView(context: Context) -> UILocationsSelecterView {
        let locationsSelectView = UILocationsSelecterView()
        locationsSelectView.delegate = context.coordinator
        return locationsSelectView
    }

    public func updateUIView(_ uiView: UILocationsSelecterView, context: Context) {
        // clear
        uiView.removeAllAnnotations()
        uiView.removeAllOverlays()
        
        // add
        for location in locations {
            uiView.addAnotation(location: location)
        }
        
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
