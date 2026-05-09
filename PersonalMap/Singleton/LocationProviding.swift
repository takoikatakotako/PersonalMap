import CoreLocation

protocol LocationProviding {
    var lastKnownLocation: CLLocationCoordinate2D? { get }
}

extension LocationManager: LocationProviding {}
