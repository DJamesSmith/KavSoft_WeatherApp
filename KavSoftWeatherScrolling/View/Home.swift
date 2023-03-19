import SwiftUI

struct Home: View {
    
    @State var offset: CGFloat = 0
    var topEdge: CGFloat
    
    var body: some View {
        
        ZStack {
            
            // GeometryReader for height & width
            GeometryReader { proxy in
                Image("sky1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            // Blur material
            .overlay(.ultraThinMaterial)
            
            // Main View
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    // Weather Data
                    VStack(alignment: .center, spacing: 5) {
                        
                        Text("San Jose")
                            .padding(.top, 60)
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
                    
                    // Custom Data View
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
                    
                }
                .padding(.top, 25)
                .padding([.horizontal, .bottom])
                
                // Getting Offset
                .overlay(
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY
                        
                        DispatchQueue.main.async {
                            self.offset = minY
                        }
                        
                        return Color.clear
                    }
                )
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


// 18:30
