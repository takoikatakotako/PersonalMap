import Testing
import Foundation
@testable import PersonalMap

@Suite("MapPolygon.centroid")
struct MapPolygonCentroidTests {
    private func makePolygon(_ coords: [(Double, Double)]) -> MapPolygon {
        MapPolygon(
            id: UUID(),
            imageName: "circle",
            isHidden: false,
            objectName: "test",
            coordinates: coords.map { Coordinate(latitude: $0.0, longitude: $0.1) },
            items: []
        )
    }

    @Test
    func squareCentroidIsCenter() {
        let polygon = makePolygon([(0, 0), (0, 10), (10, 10), (10, 0)])
        let c = polygon.centroid
        #expect(c.latitude == 5.0)
        #expect(c.longitude == 5.0)
    }

    @Test
    func triangleCentroidIsAverage() {
        let polygon = makePolygon([(0, 0), (3, 0), (0, 3)])
        let c = polygon.centroid
        #expect(c.latitude == 1.0)
        #expect(c.longitude == 1.0)
    }

    @Test
    func emptyPolygonReturnsZero() {
        let polygon = makePolygon([])
        let c = polygon.centroid
        #expect(c.latitude == 0.0)
        #expect(c.longitude == 0.0)
    }
}
