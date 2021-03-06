import SwiftUI

struct AddItemImageContent: View {
    @Binding var image: UIImage?
    @Binding var showingSheet: AddItemViewSheet?
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 120, height: 120)
            } else {
                Text("No Image")
                    .foregroundColor(Color.white)
                    .font(Font.system(size:20).bold())
                    .frame(width: 120, height: 120)
                    .background(Color(UIColor.lightGray))
            }
            
            Spacer()
            Button {
                showingSheet = .image
            } label: {
                Text("画像を設定")
            }
        }
    }
}

//struct AddItemImageContent_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemImageContent()
//    }
//}
