import SwiftUI

struct ObjectLocationPreview: View {
    let latitude: Double
    let longitude: Double
    let routeButtonTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("座標")
                .font(Font.system(size: 20).bold())
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("緯度: \(latitude)")
                        .font(Font.system(size: 20))
                    Text("経度: \(longitude)")
                        .font(Font.system(size: 20))
                }
                
                Spacer()
                
                Button {
                    routeButtonTapped()
                } label: {
                    Image(systemName: "map.circle")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
            }
        }
        .padding(.top, 16)
    }
}


struct ObjectLocationPreview_Previews: PreviewProvider {
    static var previews: some View {
        ObjectLocationPreview(latitude: 100, longitude: 100, routeButtonTapped: {
            
        })
    }
}
