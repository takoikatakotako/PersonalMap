import UIKit
import MapKit

public protocol UIMapObjectViewDelegate: AnyObject {
    func anotationTapped(mapObjectId: UUID)
    func longPressEnded(location: CLLocationCoordinate2D)
    func routeNotFound()
}
