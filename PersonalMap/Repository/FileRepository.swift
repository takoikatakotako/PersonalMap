import Foundation

struct FileRepository {
    let layerDirectoryName = "layer"
    let layersFileName = "layers.json"
    let objectDirectoryName = "object"

    func initialize() throws {
        let layerDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(layerDirectoryName)
        if !FileManager.default.fileExists(atPath: layerDirectoryUrl.path) {
            try FileManager.default.createDirectory(atPath: layerDirectoryUrl.path, withIntermediateDirectories: false, attributes: nil)
        }
        
        let layersFileUrl = layerDirectoryUrl.appendingPathComponent(layersFileName)
        if !FileManager.default.fileExists(atPath: layersFileUrl.path) {
            let mapLayersIds: [UUID] = []
            let mapLayersData = try JSONEncoder().encode(mapLayersIds)
            try mapLayersData.write(to: layersFileUrl, options: .atomic)
        }
        
        let pointDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(objectDirectoryName)
        if !FileManager.default.fileExists(atPath: pointDirectoryUrl.path) {
            try FileManager.default.createDirectory(atPath: pointDirectoryUrl.path, withIntermediateDirectories: false, attributes: nil)
        }
    }
    
    func saveMapLayer(mapLayer: MapLayer) throws {
        // MapLayer を保存する
        let fileName = mapLayer.id.description + ".json"
        let data = try JSONEncoder().encode(mapLayer)
        let fileUrl = try getDocumentsDirectoryUrl().appendingPathComponent(layerDirectoryName, isDirectory: true).appendingPathComponent(fileName)
        try data.write(to: fileUrl, options: .atomic)
        
        // layers.json を更新する
        let layersFileUrl = try getLayersFileUrl()
        let mapLayersIdsData = try Data(contentsOf: layersFileUrl)
        var mapLayersIds = try JSONDecoder().decode([UUID].self, from: mapLayersIdsData)
        mapLayersIds.append(mapLayer.id)
        try saveMapLayerIds(mapLayerIds: mapLayersIds)
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
        var mapLayers: [MapLayer] = []
        // MapLayerのID達を取得
        let mapLayersIds = try getMapLayerIds()
        for mapLayersId in mapLayersIds {
            let mapLayer = try! getMapLayer(mapLayerId: mapLayersId)
            mapLayers.append(mapLayer)
        }
        return mapLayers
    }
    
    // MapObject
//    func getMapObject(mapObjectId: UUID) throws -> MapObject {
//        let fileName = mapObjectId.description + ".json"
//        let objectFileUrl = try getObjectDirectoryUrl().appendingPathComponent(fileName)
//        let data = try Data(contentsOf: objectFileUrl)
//        let mapObject = try JSONEncoder().decode(MapObject.self, from: data)
//        return mapObject
//    }
        
    // MapPointObject
    func saveMapObject(mapObject: MapObject) throws {
        let fileName = mapObject.id.description + ".json"
        let data = try JSONEncoder().encode(try mapObject.getValue())
        let fileUrl = try getDocumentsDirectoryUrl().appendingPathComponent(objectDirectoryName, isDirectory: true).appendingPathComponent(fileName)
        try data.write(to: fileUrl, options: .atomic)
    }
    
    func getMapPointObject(fileName: String) throws -> MapObject {
        let fileUrl = try getDocumentsDirectoryUrl().appendingPathComponent(objectDirectoryName, isDirectory: true).appendingPathComponent(fileName)
        let data = try Data(contentsOf: fileUrl)
        
        
        return MapObject.point(MapPoint(isHidden: false, layerName: "XXX", coordinate: Coordinate(latitude: 34, longitude: 34), infos: []))
    }
    
    func getMapPointObjects(mapPointObjectIds: [UUID]) throws -> [MapObject] {
        var mapObjects: [MapObject] = []
        for mapPointObjectId in mapPointObjectIds {
            let fileName = "\(mapPointObjectId).json"
            let mapPointObject = try! getMapPointObject(fileName: fileName)
            mapObjects.append(mapPointObject)
        }
        return mapObjects
    }
    
    // Documents の URL
    private func getDocumentsDirectoryUrl() throws -> URL {
        guard let documentDirectoryUrl = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first else {
            throw InternalFileError.documentDirectoryNotFound
        }
        return documentDirectoryUrl
    }
    
    // Documents/layer/layers.json の URL
    private func getLayersFileUrl() throws -> URL {
        let layerDirectoryUrl = try getDocumentsDirectoryUrl()
            .appendingPathComponent(layerDirectoryName, isDirectory: true)
            .appendingPathComponent(layersFileName)
        return layerDirectoryUrl
    }
    
    // Documents/object の URL
    private func getObjectDirectoryUrl() throws -> URL {
        let objectDirectoryUrl = try getDocumentsDirectoryUrl()
            .appendingPathComponent(objectDirectoryName, isDirectory: true)
        return objectDirectoryUrl
    }
    
    private func getMapLayerIds() throws -> [UUID] {
        // layers.json を読み込む
        let layersFileUrl = try getLayersFileUrl()
        let data = try Data(contentsOf: layersFileUrl)
        let mapLayersIds = try JSONDecoder().decode([UUID].self, from: data)
        return mapLayersIds
    }
    
    private func saveMapLayerIds(mapLayerIds: [UUID]) throws {
        // 重複して保存することを防ぐために Set にする
        let mapLayersData = try JSONEncoder().encode(Set(mapLayerIds))
        let layersFileUrl = try getLayersFileUrl()
        try mapLayersData.write(to: layersFileUrl, options: .atomic)
    }
}
