import Foundation
@testable import PersonalMap

final class MockFileRepository: FileRepositoryProtocol {
    var layers: [MapLayer] = []
    var objectsById: [UUID: MapObject] = [:]
    var getMapLayersError: Error?
    var getMapObjectError: Error?

    private(set) var getMapLayersCallCount = 0
    private(set) var getMapObjectIds: [UUID] = []

    func getMapLayers() throws -> [MapLayer] {
        getMapLayersCallCount += 1
        if let error = getMapLayersError { throw error }
        return layers
    }

    func getMapObject(mapObjectId: UUID) throws -> MapObject {
        getMapObjectIds.append(mapObjectId)
        if let error = getMapObjectError { throw error }
        guard let obj = objectsById[mapObjectId] else {
            throw NSError(domain: "MockFileRepository", code: 404)
        }
        return obj
    }
}
