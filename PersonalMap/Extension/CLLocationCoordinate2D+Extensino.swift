import MapKit

extension CLLocationCoordinate2D {
    var coordinate: Coordinate {
        return Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
}
