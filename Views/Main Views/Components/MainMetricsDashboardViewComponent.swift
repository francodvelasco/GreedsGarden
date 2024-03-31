//
//  MainMetricsDashboardViewComponent.swift
//  
//
//  Created by Franco Velasco on 1/21/24.
//

import SwiftUI
import RealityKit

struct MainMetricsDashboardViewComponent: View {
    var currentYear: Int
    var moneyLevel: MetricLevel
    var temperatureLevel: MetricLevel
    var happinessLevel: MetricLevel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Year \(currentYear)")
                .fontWeight(.semibold)
                .font(.largeTitle)
            EqualWidthLayout {
                // Pollution
                VStack(alignment: .center) {
                    Gauge(
                        value: 100.0 / Double(temperatureLevel.rawValue),
                        in: 0...100.0,
                        label: {
                            EmptyView()
                        },
                        currentValueLabel: {
                            Image(systemName: "smoke.fill")
                        }
                    )
                    .gaugeStyle(.accessoryCircular)
                    .tint(temperatureLevel.badMetricColor)
                    
                    Text("Pollution")
                }
                
                // Money
                VStack(alignment: .center) {
                    Gauge(
                        value: 100.0 / Double(moneyLevel.rawValue),
                        in: 0...100.0,
                        label: {
                            EmptyView()
                        },
                        currentValueLabel: {
                            Image(systemName: "dollarsign")
                        }
                    )
                    .gaugeStyle(.accessoryCircular)
                    .tint(moneyLevel.goodMetricColor)
                    
                    Text("Money")
                }
                
                // Happiness
                VStack(alignment: .center) {
                    Gauge(
                        value: 100.0 / Double(happinessLevel.rawValue),
                        in: 0...100.0,
                        label: {
                            EmptyView()
                        },
                        currentValueLabel: {
                            Image(systemName: "face.smiling.inverse")
                        }
                    )
                    .gaugeStyle(.accessoryCircular)
                    .tint(happinessLevel.goodMetricColor)
                    
                    Text("Happiness")
                }
            }
            .font(.title3)
        }
        .padding()
        .frame(width: 400)
        .background(Color.white)
        
    }
}

extension MetricLevel {
    // Show when the metric is deemed good (aka you don't want it low)
    var goodMetricColor: Color {
        switch self {
            case .zero:
                return .red
            case .lowest:
                return .red
            case .low_mid:
                return .orange
            case .middle:
                return .yellow
            case .mid_high:
                return .mint
            case .highest:
                return .green
        }
    }
    
    // Show when the metric is deemed bad (aka you don't want it high)
    var badMetricColor: Color {
        switch self {
            case .zero:
                return .green
            case .lowest:
                return .mint
            case .low_mid:
                return .yellow
            case .middle:
                return .orange
            case .mid_high:
                return .red
            case .highest:
                return .red
        }
    }
}

#Preview {
    //MainMetricsDashboardViewComponent(moneyLevel: .middle, temperatureLevel: .middle, happinessLevel: .middle)
    Text("Wow!")
}
