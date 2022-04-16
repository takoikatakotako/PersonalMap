import SwiftUI

struct ConfigView: View {
    @ObservedObject var viewState: ConfigViewState = ConfigViewState()
    
    let APP_USAGE_URL_STRING: String = "https://swiswiswift.com"
    let FAQ_URL_STRING: String = "https://swiswiswift.com"
    let FEED_BACK_URL_STRING: String = "https://swiswiswift.com"
    let CONTACT_URL_STRING: String = "https://swiswiswift.com"
    let SHARE_URL_STRING: String = "https://swiswiswift.com"
    let PRIVACY_POLICY_URL_STRING: String = "https://swiswiswift.com"
    let TOS_URL_STRING: String = "https://swiswiswift.com"
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        MyWebView(urlString: APP_USAGE_URL_STRING)
                            .navigationTitle("アプリの使い方")
                    } label: {
                        Text("アプリの使い方")
                    }
                    
                    NavigationLink {
                        MyWebView(urlString: FAQ_URL_STRING)
                            .navigationTitle("よくある質問・ヘルプセンター")
                    } label: {
                        Text("よくある質問・ヘルプセンター")
                    }
                    
                    NavigationLink {
                        MyWebView(urlString: FEED_BACK_URL_STRING)
                            .navigationTitle("アプリのフィードバックを送る")
                    } label: {
                        Text("アプリのフィードバックを送る")
                    }
                    
                    NavigationLink {
                        MyWebView(urlString: CONTACT_URL_STRING)
                            .navigationTitle("お問い合わせ・不具合のご報告")
                    } label: {
                        Text("お問い合わせ・不具合のご報告")
                    }
                } header: {
                    Text("アプリの使い方・お問い合わせ")
                }
                
                Section {
                    Button {
                        viewState.review()
                    } label: {
                        Text("レビューで応援する")
                            .foregroundColor(Color.black)
                    }
                    
                    Button {
                        viewState.share()
                    } label: {
                        Text("アプリをシェアする")
                            .foregroundColor(Color.black)
                    }
                    
                    NavigationLink {
                        MyWebView(urlString: PRIVACY_POLICY_URL_STRING)
                            .navigationTitle("プライバシーポリシー")
                    } label: {
                        Text("プライバシーポリシー")
                    }
                    
                    NavigationLink {
                        MyWebView(urlString: TOS_URL_STRING)
                            .navigationTitle("利用規約")
                    } label: {
                        Text("利用規約")
                    }
                    
                    HStack {
                        Text("バージョン")
                        Spacer()
                        if let versionAndBuild = viewState.versionAndBuild {
                            Text(versionAndBuild)
                        }
                    }
                } header: {
                    Text("アプリについて")
                }
                
                Button {
                    viewState.showResetAlert()
                } label: {
                    HStack {
                        Spacer()
                        Text("初期設定に戻す")
                            .foregroundColor(Color.red)
                        Spacer()
                    }
                }
            }
            .alert(isPresented: $viewState.showingAlert){
                Alert(
                    title: Text("リセット"),
                    message: Text("データを削除し、初期設定に戻しますがよろしいですか？"),
                    primaryButton: .cancel(Text("キャンセル")),
                    secondaryButton: .destructive(Text("削除"), action: {
                        viewState.reset()
                    })
                )
            }
            .sheet(isPresented: $viewState.showingActivityIndicator, content: {
                ActivityViewController(activityItems: [URL(string: SHARE_URL_STRING)!])
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("設定")
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
