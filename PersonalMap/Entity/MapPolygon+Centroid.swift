import CoreLocation

extension MapPolygon {
    /// Average of the polygon's coordinates. Not the true area-weighted centroid;
    /// matches the existing label-placement behavior used by MapObjectView.
    var centroid: CLLocationCoordinate2D {
        let coords = locationCoordinate2Ds
        guard !coords.isEmpty else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        var lat = 0.0
        var lng = 0.0
        for c in coords {
            lat += c.latitude
            lng += c.longitude
        }
        let count = Double(coords.count)
        return CLLocationCoordinate2D(latitude: lat / count, longitude: lng / count)
    }
}
