import SwiftUI

struct SymbolSelecter: View {
    @Environment(\.presentationMode) var presentationMode
    
    let delegate: MapObjectSymbolSelecterDelegate?
    
    private let columns: Int = 5
    
    private let systemNames: [[String]] = [
        ["star.circle", "parkingsign.circle", "checkmark.circle", "hand.point.up.left", "photo.circle"],
        ["fork.knife.circle", "takeoutbag.and.cup.and.straw", "car.circle","building.2.crop.circle", "location.north.line"],
        ["circle.square", "mappin", "bolt.circle", "bolt.horizontal.circle", "wifi.circle"],
        ["bolt.horizontal.circle", "wifi.circle", "hand.raised.circle", "exclamationmark.triangle", "point.3.connected.trianglepath.dotted"],
        ["arrowtriangle.left.and.line.vertical.and.arrowtriangle.right", "0.circle","1.circle", "2.circle", "3.circle", "4.circle",],
        [ "5.circle", "6.circle", "7.circle", "8.circle", "9.circle"],
        [ "10.circle"],
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<6) { i in
                    HStack {
                        ForEach(0..<5) { j in
                            Button {
                                delegate?.symbolNameSelected(symbolName: systemNames[i][j])
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: systemNames[i][j])
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                }
                HStack(spacing: 12) {
                    Button {
                        delegate?.symbolNameSelected(symbolName: systemNames[6][0])
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: systemNames[6][0])
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("シンボルの選択")
        }
    }
}

//struct SymbolSelecter_Previews: PreviewProvider {
//    static var previews: some View {
//        SymbolSelecter()
//    }
//}
