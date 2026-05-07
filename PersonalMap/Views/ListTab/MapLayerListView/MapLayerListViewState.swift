import SwiftUI

class MapLayerListViewState: ObservableObject {
    @Published var mapLayers: [MapLayer] = []
    @Published var showingSheet = false
    @Published var errorMessage: String?

    private let fileRepository = FileRepository()

    func plusTapped() {
        showingSheet = true
    }

    func sheetDismiss() {
        do { try getMapLayers() } catch { errorMessage = "データの読み込みに失敗しました" }
    }

    func rowMove(fromOffsets: IndexSet, toOffset: Int) {
        mapLayers.move(fromOffsets: fromOffsets, toOffset: toOffset)
        do { try fileRepository.moveMapLayer(fromOffsets: fromOffsets, toOffset: toOffset) }
        catch { errorMessage = "並び替えに失敗しました" }
    }

    func rowRemove(offsets: IndexSet) {
        let deleteLayerIds: [UUID] = offsets.map { mapLayers[$0].id }
        do {
            for deleteLayerId in deleteLayerIds {
                try fileRepository.deleteMapLayer(mapLayerId: deleteLayerId)
            }
            mapLayers.remove(atOffsets: offsets)
        } catch {
            errorMessage = "削除に失敗しました"
        }
    }

    func onAppear() {
        do { try getMapLayers() } catch { errorMessage = "データの読み込みに失敗しました" }
    }

    private func getMapLayers() throws {
        mapLayers = try fileRepository.getMapLayers()
    }
}
