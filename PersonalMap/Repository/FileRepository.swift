import Foundation
import UIKit
import PDFKit

struct FileRepository {
    let layerDirectoryName = "layer"
    let layersFileName = "layers.json"
    let objectDirectoryName = "object"
    let imageDirectoryName = "image"
    let pdfDirectoryName = "pdf"

    init() {
        try! initialize()
    }

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
        
        let objectDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(objectDirectoryName)
        if !FileManager.default.fileExists(atPath: objectDirectoryUrl.path) {
            try FileManager.default.createDirectory(atPath: objectDirectoryUrl.path, withIntermediateDirectories: false, attributes: nil)
        }
        
        let imageDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(imageDirectoryName)
        if !FileManager.default.fileExists(atPath: imageDirectoryUrl.path) {
            try FileManager.default.createDirectory(atPath: imageDirectoryUrl.path, withIntermediateDirectories: false, attributes: nil)
        }
        
        let pdfDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(pdfDirectoryName)
        if !FileManager.default.fileExists(atPath: pdfDirectoryUrl.path) {
            try FileManager.default.createDirectory(atPath: pdfDirectoryUrl.path, withIntermediateDirectories: false, attributes: nil)
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
        
        let data: Data
        switch mapObject {
        case let .point(point):
            data = try JSONEncoder().encode(point)
        case let .polyLine(polyLine):
            data = try JSONEncoder().encode(polyLine)
        case let .polygon(polygon):
            data = try JSONEncoder().encode(polygon)
        }
        
        let fileUrl = try getObjectDirectoryUrl().appendingPathComponent(fileName)
        try data.write(to: fileUrl, options: .atomic)
    }
    
    func saveImageData(data: Data, fileName: String) throws {
        let fileUrl = try getImageDirectoryUrl().appendingPathComponent(fileName)
        try data.write(to: fileUrl, options: .atomic)
    }
    
    func savePDFDocument(document: PDFDocument, fileName: String) throws {
        let fileUrl = try getPDFDirectoryUrl().appendingPathComponent(fileName)
        document.write(to: fileUrl)
    }
        
    func getMapObject(mapObjectId: UUID) throws -> MapObject {
        let fileName = mapObjectId.description + ".json"
        let fileUrl = try getObjectDirectoryUrl().appendingPathComponent(fileName)
        let data = try Data(contentsOf: fileUrl)
        
        let mapObject = try JSONDecoder().decode(MapObject.self, from: data)
        return mapObject
    }
    
    func getMapObjects(mapObjectIds: [UUID]) throws -> [MapObject] {
        var mapObjects: [MapObject] = []
        for mapObjectId in mapObjectIds {
            let mapObject = try getMapObject(mapObjectId: mapObjectId)
            mapObjects.append(mapObject)
        }
        return mapObjects
    }
    
    func getImageData(fileName: String) -> UIImage? {
        do {
            let fileUrl = try getImageDirectoryUrl().appendingPathComponent(fileName)
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    func getPDFDocument(fileName: String) -> PDFDocument? {
        do {
            let fileUrl = try getPDFDirectoryUrl().appendingPathComponent(fileName)
            let pdfDocument = PDFDocument(url: fileUrl)
            return pdfDocument
        } catch {
            return nil
        }
    }
    
    func deleteMapObject(mapObjectId: UUID) throws {
        let fileUrl = try getObjectDirectoryUrl().appendingPathComponent("\(mapObjectId).json")
        try FileManager.default.removeItem(at: fileUrl)
    }
    
    func moveMapLayer(fromOffsets: IndexSet, toOffset: Int) throws {
        var mapLayersIds = try getMapLayerIds()
        mapLayersIds.move(fromOffsets: fromOffsets, toOffset: toOffset)
        try saveMapLayerIds(mapLayerIds: mapLayersIds)
    }
    
    func deleteMapLayer(mapLayerId: UUID) throws {
        let fileUrl = try getLayerDirectoryUrl().appendingPathComponent("\(mapLayerId).json")
        try FileManager.default.removeItem(at: fileUrl)
        
        var mapLayersIds = try getMapLayerIds()
        if let index = mapLayersIds.firstIndex(of: mapLayerId) {
            mapLayersIds.remove(at: index)
            try saveMapLayerIds(mapLayerIds: mapLayersIds)
        }
    }
    
    func reset() throws {
        let layerDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(layerDirectoryName)
        try FileManager.default.removeItem(at: layerDirectoryUrl)

        let objectDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(objectDirectoryName)
        try FileManager.default.removeItem(at: objectDirectoryUrl)

        let imageDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(imageDirectoryName)
        try FileManager.default.removeItem(at: imageDirectoryUrl)

        let pdfDirectoryUrl = try getDocumentsDirectoryUrl().appendingPathComponent(pdfDirectoryName)
        try FileManager.default.removeItem(at: pdfDirectoryUrl)
        
        try initialize()
    }
    
    /// Private Methods
    
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
    
    // Documents/layer の URL
    private func getLayerDirectoryUrl() throws -> URL {
        let layerDirectoryUrl = try getDocumentsDirectoryUrl()
            .appendingPathComponent(layerDirectoryName, isDirectory: true)
        return layerDirectoryUrl
    }
    
    // Documents/object の URL
    private func getObjectDirectoryUrl() throws -> URL {
        let objectDirectoryUrl = try getDocumentsDirectoryUrl()
            .appendingPathComponent(objectDirectoryName, isDirectory: true)
        return objectDirectoryUrl
    }
    
    // Documents/image の URL
    private func getImageDirectoryUrl() throws -> URL {
        let imageDirectoryUrl = try getDocumentsDirectoryUrl()
            .appendingPathComponent(imageDirectoryName, isDirectory: true)
        return imageDirectoryUrl
    }
    
    // Documents/pdf の URL
    private func getPDFDirectoryUrl() throws -> URL {
        let pdfDirectoryUrl = try getDocumentsDirectoryUrl()
            .appendingPathComponent(pdfDirectoryName, isDirectory: true)
        return pdfDirectoryUrl
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
