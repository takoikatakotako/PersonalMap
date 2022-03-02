import MapKit

struct Route {
    let source: CLLocationCoordinate2D
    let destination: CLLocationCoordinate2D
    
    init(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        self.source = source
        self.destination = destination
    }
    
    init(source: Coordinate, destination: Coordinate) {
        self.source = source.locationCoordinate2D
        self.destination = destination.locationCoordinate2D
    }
}
