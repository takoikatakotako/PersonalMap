import SwiftUI

struct AddMapPointView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewState: AddMapPointViewState
    
    init(mapLayerId: UUID) {
        _viewState = StateObject(wrappedValue: AddMapPointViewState(mapLayerId: mapLayerId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    MapObjectLabelTextField(labelName: $viewState.labelName)
                    
                    MapObjectHiddenSelecter(hidden: $viewState.hidden)
                    
                    MapObjectSymbolSelecter(symbolName: $viewState.symbolName)
                    
                    MapObjectSingleLocationSelecter(latitude: $viewState.latitude, longitude: $viewState.longitude)
                    
                    MapObjectItems(items: $viewState.items)
                }
            }
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
            .navigationTitle("ポイントの新規登録")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        viewState.savePoint()
                    }, label: {
                        Text("登録")
                            .font(Font.system(size: 16).bold())
                    })
            )
        }
    }
}

#Preview {
    AddMapPointView(mapLayerId: UUID())
}
