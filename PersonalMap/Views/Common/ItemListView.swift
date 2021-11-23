import SwiftUI

protocol ItemListViewDelegate {
    func updateItems(items: [Item])
}

struct ItemListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingSheet = false
    let items: [Item]
    let delegate: ItemListViewDelegate?
    var body: some View {
        
        NavigationView {
            List(items) { item in
                Text(item.key)
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("項目一覧")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Button {
                                showingSheet = true
                            } label: {
                                Text("追加")
                                    .font(Font.system(size: 16).bold())
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("完了")
                                    .font(Font.system(size: 16).bold())
                            }
                        }
                    })
            )
        }
        .sheet(isPresented: $showingSheet) {
            
        } content: {
            InfoInputView()
        }
    }
}

struct InputListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(items: [], delegate: nil)
    }
}