import SwiftUI
import MapKit

enum AddObjectStatus {
    case ready
    case point
    case line
    case area
}

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            MapView(points: $viewModel.points, mapType: $viewModel.mapType) { (location) in
                if viewModel.addObjectStatus == .ready {
                    return
                } else if viewModel.addObjectStatus == .point {
                    viewModel.addPoint(location: location)
                } else if viewModel.addObjectStatus == .line {
                    viewModel.addLine(location: location)
                }
            }
            .ignoresSafeArea()
            
            if viewModel.addObjectStatus == .ready {
                VStack {
                    HStack {
                        Button(action: {
                            viewModel.showPointList()
                        }) {
                            Image(systemName: "square.stack.3d.up")
                                .padding(8)
                                .background(Color.orange)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.blue, lineWidth: 2))
                        }
                        
                        Button(action: {
                            viewModel.changeMapTypeButtonTapped()
                        }) {
                            Image(systemName: "paperplane")
                                .padding(8)
                                .background(Color.orange)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.blue, lineWidth: 2))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.actionSheet = .newObject
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.white)
                            .frame(width: 30, height: 30)
                            .padding(12)
                            .background(Color.gray)
                            .cornerRadius(30)
                    })
                    .padding(8)
                }
                
            } else if viewModel.addObjectStatus == .point {
                VStack {
                    Spacer()
                    
                    Button(action: {
                        viewModel.addObjectStatus = .ready
                    }, label: {
                        Text("閉じる")
                            .font(Font.system(size: 24))
                    })
                    .padding(8)
                }
            } else if viewModel.addObjectStatus == .line {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            viewModel.addObjectStatus = .ready
                        }, label: {
                            Text("閉じる")
                                .font(Font.system(size: 24))
                        })
                        .padding(8)
                        
                        Button(action: {
                            viewModel.addObjectStatus = .ready
                        }, label: {
                            Text("決定")
                                .font(Font.system(size: 24))
                        })
                        .padding(8)
                    }
                }
            }
        }
        .sheet(
            item: $viewModel.sheet,
            onDismiss: {
                viewModel.addObjectStatus = .ready
            },
            content: { item in
                switch item {
                case let .addPoint(_, location):
                    AddPointModalView(location: location, delegate: self)
                case .pointList:
                    PointListView(points: $viewModel.points)
                }
            })
        .actionSheet(item: $viewModel.actionSheet) { item in
            switch item {
            
            case .newObject:
                return ActionSheet(
                    title: Text("追加"),
                    message: Text("追加するオブジェクトの種類を選択してください"),
                    buttons:
                        [
                            .default(Text("ポイント"), action: {
                                viewModel.addObjectStatus(status: .point)
                            }),
                            .default(Text("ライン"), action: {
                                viewModel.addObjectStatus(status: .line)
                            }),
                            .default(Text("エリア"), action: {
                                viewModel.addObjectStatus(status: .area)
                            }),
                            .cancel()
                        ]
                )
            case .changeMapType:
                return ActionSheet(
                    title: Text("マップタイプ変更"),
                    message: Text("マップタイプを選択してください"),
                    buttons:
                        [
                            .default(Text("standard"), action: {
                                viewModel.changeMapType(mapType: .standard)
                            }),
                            .default(Text("hybrid"), action: {
                                viewModel.changeMapType(mapType: .hybrid)
                            }),
                            .default(Text("hybridFlyover"), action: {
                                viewModel.changeMapType(mapType: .hybridFlyover)
                            }),
                            .default(Text("satellite"), action: {
                                viewModel.changeMapType(mapType: .satellite)
                            }),
                            .cancel()
                        ]
                )
            }
        }
    }
}

extension ContentView: AddPointModalViewDelegate {
    func addPoint(point: Point) {
        viewModel.points.append(point)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
