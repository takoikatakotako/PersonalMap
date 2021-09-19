import Foundation

struct FileRepository {
    let layerDirectoryName = "layer"
    
    func initialize() throws {
        let layerDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(layerDirectoryName)
        if !FileManager.default.fileExists(atPath: layerDirectoryUrl.path) {
            try FileManager.default.createDirectory(atPath: layerDirectoryUrl.path, withIntermediateDirectories: false, attributes: nil)
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
    
    private func getDocumentsDirectoryUrl() throws -> URL {
        guard let documentDirectoryUrl = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first else {
            throw InternalFileError.documentDirectoryNotFound
        }
        return documentDirectoryUrl
    }
}
