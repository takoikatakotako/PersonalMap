import UIKit
import MapKit

public protocol UIMapObjectViewDelegate: AnyObject {
    func anotationTapped(mapObjectId: UUID)
    func xxxxxx(location: CLLocationCoordinate2D)
}
