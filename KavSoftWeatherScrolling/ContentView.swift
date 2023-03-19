import SwiftUI

struct ContentView: View {
    var body: some View {
        
        // Since Window is decrypted in iOS 15, Getting SafeArea using GeometryReader
        GeometryReader { proxy in

            let topEdge = proxy.safeAreaInsets.top
            Home(topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
