//
//  MetricsRow.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import SwiftUI

struct MetricsRow: View {
    struct Metric: Equatable {
        let title: String
        let value: String
        let systemImage: String
    }

    let metrics: [Metric]

    var body: some View {
        HStack(spacing: .spacing12) {
            ForEach(metrics, id: \.title) { metric in
                MetricPill(metric: metric)
            }
        }
    }
}

private struct MetricPill: View {
    let metric: MetricsRow.Metric

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: metric.systemImage)
                .font(.caption)

            VStack(alignment: .leading, spacing: 2) {
                Text(metric.title)
                    .font(.caption2)
                    .opacity(0.7)
                Text(metric.value)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(SecondaryCardBackground())
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .frame(maxWidth: .infinity)
    }
}

private extension CGFloat {
    static let spacing12: CGFloat = 12
}
