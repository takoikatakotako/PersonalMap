import CoreLocation
@testable import PersonalMap

final class MockLocationProvider: LocationProviding {
    var lastKnownLocation: CLLocationCoordinate2D?

    init(lastKnownLocation: CLLocationCoordinate2D? = nil) {
        self.lastKnownLocation = lastKnownLocation
    }
}
