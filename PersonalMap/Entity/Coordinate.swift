import MapKit

struct Coordinate: Codable, Hashable {
    let latitude: Double
    var longitude: Double
    
    var locationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
