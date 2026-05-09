import Foundation

protocol FileRepositoryProtocol {
    func getMapLayers() throws -> [MapLayer]
    func getMapObject(mapObjectId: UUID) throws -> MapObject
}

extension FileRepository: FileRepositoryProtocol {}
