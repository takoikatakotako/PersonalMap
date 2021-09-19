import Foundation

struct FileRepository {
    let layerDirectoryName = "layer"
    let pointDirectoryName = "point"

    func initialize() throws {
        let layerDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(layerDirectoryName)
        if !FileManager.default.fileExists(atPath: layerDirectoryUrl.path) {
            try FileManager.default.createDirectory(atPath: layerDirectoryUrl.path, withIntermediateDirectories: false, attributes: nil)
        }
        
        let pointDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(pointDirectoryName)
        if !FileManager.default.fileExists(atPath: pointDirectoryUrl.path) {
            try FileManager.default.createDirectory(atPath: pointDirectoryUrl.path, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    func saveMapLayer(mapLayer: MapLayer) throws {
        let fileName = mapLayer.id.description + ".json"
        let data = try JSONEncoder().encode(mapLayer)
        let fileUrl = try getDocumentsDirectoryUrl().appendingPathComponent(layerDirectoryName, isDirectory: true).appendingPathComponent(fileName)
        try data.write(to: fileUrl, options: .atomic)
    }
    
    func getMapLayer(fileName: String) throws -> MapLayer {
        let fileUrl = try getDocumentsDirectoryUrl().appendingPathComponent(layerDirectoryName, isDirectory: true).appendingPathComponent(fileName)
        let data = try Data(contentsOf: fileUrl)
        let mapLayer = try JSONDecoder().decode(MapLayer.self, from: data)
        return mapLayer
    }
    
    func getMapLayer(mapLayerId: UUID) throws -> MapLayer {
        let fileName = mapLayerId.description + ".json"
        return try getMapLayer(fileName: fileName)
    }
    
    func getMapLyers() throws -> [MapLayer] {
        let layerDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(layerDirectoryName, isDirectory: true)
        let directoryContents = try FileManager.default.contentsOfDirectory(at: layerDirectoryUrl, includingPropertiesForKeys: nil)

        let fileNames = directoryContents.map{ $0.lastPathComponent }
        var mapLayers: [MapLayer] = []
        for fileName in fileNames {
            let mapLayer = try! getMapLayer(fileName: fileName)
            mapLayers.append(mapLayer)
        }
        return mapLayers
    }
    
    // MapPointObject
    func saveMapPointObject(mapPointObject: MapPointObject) throws {
        let fileName = mapPointObject.id.description + ".json"
        let data = try JSONEncoder().encode(mapPointObject)
        let fileUrl = try getDocumentsDirectoryUrl().appendingPathComponent(pointDirectoryName, isDirectory: true).appendingPathComponent(fileName)
        try data.write(to: fileUrl, options: .atomic)
    }
    
    func getMapPointObject(fileName: String) throws -> MapPointObject {
        let fileUrl = try getDocumentsDirectoryUrl().appendingPathComponent(pointDirectoryName, isDirectory: true).appendingPathComponent(fileName)
        let data = try Data(contentsOf: fileUrl)
        let mapPointObject = try JSONDecoder().decode(MapPointObject.self, from: data)
        return mapPointObject
    }
    
    func getMapPointObjects(mapPointObjectIds: [UUID]) throws -> [MapPointObject] {
        var mapPointObjects: [MapPointObject] = []
        for mapPointObjectId in mapPointObjectIds {
            let fileName = "\(mapPointObjectId).json"
            let mapPointObject = try! getMapPointObject(fileName: fileName)
            mapPointObjects.append(mapPointObject)
        }
        return mapPointObjects
    }
    
    private func getDocumentsDirectoryUrl() throws -> URL {
        guard let documentDirectoryUrl = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first else {
            throw InternalFileError.documentDirectoryNotFound
        }
        return documentDirectoryUrl
    }
}
