//
//  WeatherView.swift
//  WeatherInfo
//
//  Created by ali cihan on 25.07.2024.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject private var vm = WeatherViewModel()
    var body: some View {
        
        ZStack {
            Image("weatherappbg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            if vm.dataReady {
                VStack {
                    Spacer()
                    
                    Text("\(vm.city)")
                        .bold().font(.largeTitle)
                    Text("\(vm.temp)°")
                        .bold().font(.system(size: 96))
                    AsyncImage(url: vm.iconURL) { image in
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }

                    Text("\(vm.desc)")
                        .bold().font(.title3)
                    Spacer()
                    
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading) {
                                WeatherRow(logo: "thermometer.high", name: "Max temp", value: "\(vm.maxTemp)°")
                                WeatherRow(logo: "wind", name: "Wind", value: "\(vm.windSpeed) m/s")
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                WeatherRow(logo: "thermometer.low", name: "Min temp", value: "\(vm.minTemp)°")
                                WeatherRow(logo: "humidity.fill", name: "Humidty", value: "\(vm.humidity)%")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .background(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    
                }
            } else {
                ProgressView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WeatherView()
}
