import SwiftUI
import MapKit
import UIKit

public protocol TapplableMapViewDelegate: AnyObject {
    func mapViewDidTap(location: CLLocationCoordinate2D)
}

public class TapplableMapView: UIView {
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
    
    func addAnnotation(_ annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
    }
    
    func addOverlayxxx() {
        

        class ImageOverlay : NSObject, MKOverlay {

            let image:UIImage
            let boundingMapRect: MKMapRect
            let coordinate:CLLocationCoordinate2D

            init(image: UIImage, rect: MKMapRect) {
                self.image = image
                self.boundingMapRect = rect
                self.coordinate = CLLocationCoordinate2D(latitude: 35.6804, longitude: 139.7690)
            }
        }

        class ImageOverlayRenderer : MKOverlayRenderer {

            override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {

                guard let overlay = self.overlay as? ImageOverlay else {
                    return
                }

                let rect = self.rect(for: overlay.boundingMapRect)

                UIGraphicsPushContext(context)
                overlay.image.draw(in: rect)
                UIGraphicsPopContext()
            }
        }
        
        // let overlay = MKCircle(center: CLLocationCoordinate2D(latitude: 35.6804, longitude: 139.7690), radius: 10000)
        
        let overlay = ImageOverlay(image: UIImage(named: "icon")!, rect: MKMapRect(x: 0, y: 0, width: 10000, height: 10000))
        mapView.addOverlay(overlay)
    }
}

public struct MapView: UIViewRepresentable {
    @Binding var points: [Point]
    
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
        for point in points {
            let annotation = MKPointAnnotation()
            annotation.coordinate = point.location
            annotation.title = point.layerName
            uiView.addAnnotation(annotation)
        }
        
        uiView.addOverlayxxx()
    }
}
