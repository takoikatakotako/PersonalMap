import SwiftUI

protocol MapObjectSymbolSelecterDelegate {
    func symbolNameSelected(symbolName: String)
}

struct MapObjectSymbolSelecter: View {
    @Binding var symbolName: String
    @State private var showingSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("シンボルの選択")
                .font(Font.system(size: 20).bold())
                .padding(.top, 12)
            
            HStack {
                Image(systemName: symbolName)
                    .resizable()
                    .foregroundColor(Color.blue)
                    .frame(width: 52, height: 52)
                    .padding(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Spacer()
                Button {
                    showingSheet = true
                } label: {
                    Text("シンボルを設定")
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            SymbolSelecter(delegate: self)
        }
    }
}

extension MapObjectSymbolSelecter: MapObjectSymbolSelecterDelegate {
    func symbolNameSelected(symbolName: String) {
        self.symbolName = symbolName
    }
}
