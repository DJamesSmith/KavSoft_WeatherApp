import SwiftUI
import SpriteKit

struct Home: View {
    
    @State var offset: CGFloat = 0
    var topEdge: CGFloat
    
    // To avoid early starting landing animation, we're going to delay the startValue
    @State var showRain = false
    
    var body: some View {
        
        ZStack {
            
            // GeometryReader for height & width
            GeometryReader { proxy in
                Image("sky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            // Blur material
            .overlay(.ultraThinMaterial)
            
            // MARK: RainFall View
            // Maybe it's a bug (while scrollingn it gets restarted). To avoid, use GeometryReader.
            GeometryReader { _ in
                SpriteView(scene: RainFall(), options: [.allowsTransparency])
            }
            .ignoresSafeArea()
            .opacity(showRain ? 1 : 0)
            
            
            // MARK: Main View
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    // Weather Data
                    VStack(alignment: .center, spacing: 5) {
                        
                        Text("San Jose")
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        // Text("\(offset)°")
                        Text("98°")
                            .font(.system(size: 45))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                        
                        Text("Cloudy")
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                        
                        Text("H: 103° L: 105°")
                            .foregroundStyle(.primary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                        
                    }
                    .offset(y: -offset)
                    // For BottomDrag Effect
                    .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0)
                    .offset(y: getTitleOffset())
                    
                    // MARK: Custom Data View
                    VStack(spacing: 8) {
                        // Custom Stack
                        CustomStackView {
                            
                            Label {
                                
                                Text("Hourly Forecast")
                                
                            } icon: {
                                Image(systemName: "clock")
                            }
                            
                        } contentView: {
                            
                            // Content
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 15) {
                                    
                                    ForecastView(time: "3 PM", celsius: 97, image: "sun.dust")
                                    
                                    ForecastView(time: "4 PM", celsius: 99, image: "sun.min")
                                    
                                    ForecastView(time: "5 PM", celsius: 101, image: "sun.min")
                                    
                                    ForecastView(time: "6 PM", celsius: 99, image: "cloud.sun.rain")
                                    
                                    ForecastView(time: "7 PM", celsius: 97, image: "cloud.sun")
                                    
                                    ForecastView(time: "8 PM", celsius: 92, image: "cloud.sun.rain")
                                    
                                    ForecastView(time: "9 PM", celsius: 96, image: "cloud.sun.bolt")
                                    
                                    ForecastView(time: "12 PM", celsius: 94, image: "sun.haze")
                                    
                                    ForecastView(time: "1 PM", celsius: 95, image: "sun.min")
                                    
                                    ForecastView(time: "2 PM", celsius: 96, image: "sun.dust")
                                }
                                
                            }
                            
                        }
                        WeatherDataView()
                    }
                    .background(
                        GeometryReader { _ in
                            SpriteView(scene: RainFallLanding(), options: [.allowsTransparency])
                                .offset(y: -10)
                        }
                            .offset(y: -(offset + topEdge) > 90 ? -(offset + (90 + topEdge)) : 0)
                            .opacity(showRain ? 1 : 0)
                    )
                    .padding(.top, 20)
                    
                }
                .padding(.top, 25)
                .padding(.top, topEdge)
                .padding([.horizontal, .bottom])
                
                // Getting Offset
                .overlay(
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY
                        
                        DispatchQueue.main.async {
                            self.offset = minY
                            // Including topEdge since we ignored topEdge on mainView
//                            print("\(minY + topEdge)")
                            // Approx 90, since we including topEdge
                            // So the values will be same for smaller devices too
                        }
                        
                        return Color.clear
                    }
                )
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    showRain = true
                }
            }
        }
        
    }
    
    func getTitleOpacity() -> CGFloat {
        let titleOffset = -getTitleOffset()
        let progress = titleOffset / 20
        let opacity = 1 - progress
        
        return opacity
    }
    
    func getTitleOffset() -> CGFloat {
        // Setting one maxHeight for whole title, considering max = 120
        if offset < 0 {
            let progress = -offset / 120
            
            // Since topPadding = 25
            let newOffset = (progress <= 1.0 ? progress : 1) * 20
            
            return -newOffset
        }
        return 0
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ForecastView: View {
    
    var time: String
    var celsius: CGFloat
    var image: String
    
    var body: some View {
        VStack(spacing: 15) {
            
            Text(time)
                .font(.callout.bold())
                .foregroundColor(.white)
            
            Image(systemName: image)
                .font(.title2)
            // MultiColor
                .symbolVariant(.fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.yellow, .white)
            // MaxFrame
                .frame(height: 30)
            
            Text("\(Int(celsius))°")
                .font(.callout.bold())
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
    }
}

// MARK: Creating Rain/Snow Effect like iOS 15 WeatherApp - SpriteKit Rain Scene

class RainFall: SKScene {
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        // Anchor Point
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        // BgColor
        backgroundColor = .clear
        
        // Creating node & adding to scene
        let node = SKEmitterNode(fileNamed: "RainFall.sks")!
        addChild(node)
        
        // Full width
        node.particlePositionRange.dx = UIScreen.main.bounds.width
        
    }
}

// Next RainFall Landing Scene
class RainFallLanding: SKScene {
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        // Anchor Point
        let height = UIScreen.main.bounds.height
        // Getting % by emitting position range
        anchorPoint = CGPoint(x: 0.5, y: (height - 5) / height)
        
        // BgColor
        backgroundColor = .clear
        
        // Creating node & adding to scene
        let node = SKEmitterNode(fileNamed: "RainFallLanding.sks")!
        addChild(node)
        
        // Removed for card padding
        node.particlePositionRange.dx = UIScreen.main.bounds.width - 30
        
    }
}
