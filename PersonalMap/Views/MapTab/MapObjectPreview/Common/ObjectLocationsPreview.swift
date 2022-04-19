import SwiftUI

struct ObjectLocationsPreview: View {
    let coordinates: [Coordinate]
    let routeButtonTapped: (_ coordinate: Coordinate) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("座標")
                .font(Font.system(size: 20).bold())
            
            ForEach(coordinates, id: \.self) { coordinate in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("緯度: \(coordinate.latitude)")
                            .font(Font.system(size: 20))
                        Text("経度: \(coordinate.longitude)")
                            .font(Font.system(size: 20))
                    }
                    
                    Spacer()
                    
                    Button {
                        routeButtonTapped(coordinate)
                    } label: {
                        Image(systemName: "map.circle")
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                }
                
                Divider()
            }
        }
        .padding(.top, 16)
    }
}

struct ObjectLocationsPreview_Previews: PreviewProvider {
    static var previews: some View {
        ObjectLocationsPreview(coordinates: [], routeButtonTapped: {coordinate in })
    }
}
