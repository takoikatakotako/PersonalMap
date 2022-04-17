import SwiftUI

enum MapObjectMultiLocationSelecterSheet: Hashable, Identifiable {
    var id: Self { self }
    
    case locations
    case editLocations(index:Int)
}

struct MapObjectMultiLocationSelecter: View {
    
    @Binding var coordinates: [Coordinate]
    
    @State private var sheet: MapObjectMultiLocationSelecterSheet?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("位置情報を選択")
                .font(Font.system(size: 20).bold())
                .padding(.top, 12)
            
            ForEach(coordinates.indices, id: \.self) { index in
                HStack {
                    VStack(alignment: .leading) {
                        Text("latitude: \(coordinates[index].latitude.description)")
                        Text("latitude: \(coordinates[index].longitude.description)")
                    }
                    Spacer()
                    
                    Button {
                        sheet = .editLocations(index: index)
                    } label: {
                        Text("編集")
                    }
                }
                Divider()
            }
            
            HStack {
                Spacer()
                Button {
                    sheet = .locations
                } label: {
                    Text("位置情報を設定")
                }
            }
        }
        .sheet(item: $sheet, onDismiss: {
            
        }, content: { item in
            switch item {
            case .locations:
                PolylineAndPolygonLocationSelecter(coordinates: $coordinates)
            case .editLocations(let index):
                AddMapObjectEditLocation(coordinates: $coordinates, index: index)
            }
        })
    }
}
