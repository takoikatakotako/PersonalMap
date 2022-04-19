import SwiftUI

struct ObjectNamePreview: View {
    let objectName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("オブジェクト名")
                .font(Font.system(size: 20).bold())
            
            Text(objectName)
                .font(Font.system(size: 20))
        }
        .padding(.top, 16)
    }
}

struct ObjectNamePreview_Previews: PreviewProvider {
    static var previews: some View {
        ObjectNamePreview(objectName: "ラインオブジェクト")
    }
}
