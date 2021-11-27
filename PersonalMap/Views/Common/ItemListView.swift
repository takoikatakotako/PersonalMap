import SwiftUI

struct ItemListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingSheet = false
    @Binding var items: [Item]
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    if item.itemType == .text {
                        TextItemRow(item: item)
                    } else if item.itemType == .url {
                        URLItemRow(item: item)
                    } else if item.itemType == .image {
                        ImageItemRow(item: item)
                    }
                }
                .onDelete(perform: delete)
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("項目一覧")
            .navigationBarItems(
                leading:
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("とじる")
                            .font(Font.system(size: 16).bold())
                    },
                trailing:
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            EditButton()
                            
                            Button {
                                showingSheet = true
                            } label: {
                                Text("追加")
                                    .font(Font.system(size: 16).bold())
                            }
                        }
                    })
            )
        }
        .sheet(isPresented: $showingSheet) {
            
        } content: {
            AddItemView(items: $items)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
