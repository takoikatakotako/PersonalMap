import SwiftUI

struct AddMapPolygonView: View {    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewState: AddMapPolygonViewState
    
    init(mapLayerId: UUID) {
        _viewState = StateObject(wrappedValue: AddMapPolygonViewState(mapLayerId: mapLayerId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    MapObjectLabelTextField(labelName: $viewState.labelName)
                    
                    MapObjectHiddenSelecter(hidden: $viewState.hidden)
                    
                    MapObjectSymbolSelecter(symbolName: $viewState.symbolName)

                    MapObjectMultiLocationSelecter(coordinates: $viewState.coordinates)
                    
                    MapObjectItems(items: $viewState.items)
                }
            }
            .navigationBarItems(
                trailing:
                    Button(action: {
                        viewState.savePolygon()
                    }, label: {
                        Text("登録")
                            .font(Font.system(size: 16).bold())
                    })
            )
            .alert("", isPresented: $viewState.showingAlert) {
                Button("閉じる", role: .cancel) {}
            } message: {
                Text(viewState.message)
            }
            .onReceive(viewState.$dismiss, perform: { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            })
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("エリアの新規登録")
        }
    }
}
