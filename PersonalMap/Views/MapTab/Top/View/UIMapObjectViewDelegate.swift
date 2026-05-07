import UIKit
import MapKit

public protocol UIMapObjectViewDelegate: AnyObject {
    func annotationTapped(mapObjectId: UUID)
    func longPressEnded(location: CLLocationCoordinate2D)
    func routeNotFound()
}
