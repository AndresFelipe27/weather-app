//
//  CachedRemoteImage.swift
//  Weather
//
//  Created by Usuario on 4/01/26.
//

import Combine
import SwiftUI
import UIKit

struct CachedRemoteImage: View {
    let urlString: String?
    let renderingMode: Image.TemplateRenderingMode?

    @StateObject private var loader = ImageLoader()

    init(urlString: String?, renderingMode: Image.TemplateRenderingMode? = nil) {
        self.urlString = urlString
        self.renderingMode = renderingMode
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(renderingMode)
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear { loader.load(urlString: urlString) }
    }
}

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?

    func load(urlString: String?) {
        guard let urlString,
              let url = URL(string: normalize(urlString)),
              let cached = ImageCache.shared.get(url: url) else {
            download(urlString: urlString)
            return
        }
        image = cached
    }

    private func download(urlString: String?) {
        guard let urlString,
              let url = URL(string: normalize(urlString)) else { return }

        if let cached = ImageCache.shared.get(url: url) {
            image = cached
            return
        }

        cancellable?.cancel()
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] img in
                    guard let self, let img else { return }
                    ImageCache.shared.set(img, for: url)
                    self.image = img
                }
            )
    }

    private func normalize(_ value: String) -> String {
        value.hasPrefix("//") ? "https:\(value)" : value
    }

    deinit { cancellable?.cancel() }
}

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()

    private init() {}

    func get(url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
