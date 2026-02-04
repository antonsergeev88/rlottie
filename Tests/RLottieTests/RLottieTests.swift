import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
import XCTest
import RLottieCPP
@testable import RLottie

final class RLottieTests: XCTestCase {
    func testRenderFirstFrameHasDifferentPixels() throws {
        lottie_init()
        defer { lottie_shutdown() }

        let url = try XCTUnwrap(Bundle.module.url(forResource: "EmojiWink", withExtension: "json"))
        let animation = try XCTUnwrap(Animation(path: url.path))

        XCTAssertGreaterThan(animation.width, 0)
        XCTAssertGreaterThan(animation.height, 0)
        XCTAssertGreaterThan(animation.frameCount, 0)

        let frameIndex = animation.frame(at: 0.0)
        let pixelCount = animation.width * animation.height
        let buffer = UnsafeMutablePointer<UInt32>.allocate(capacity: pixelCount)
        buffer.initialize(repeating: 0, count: pixelCount)
        defer {
            buffer.deinitialize(count: pixelCount)
            buffer.deallocate()
        }

        animation.render(frame: frameIndex,
                         into: buffer,
                         width: animation.width,
                         height: animation.height,
                         bytesPerLine: animation.width * 4)

        var minPixel = UInt32.max
        var maxPixel = UInt32.min
        for i in 0..<pixelCount {
            let pixel = buffer[i]
            if pixel < minPixel { minPixel = pixel }
            if pixel > maxPixel { maxPixel = pixel }
        }

        XCTAssertNotEqual(
            minPixel,
            maxPixel,
            "Expected at least two distinct pixels in rendered buffer. size=\(animation.width)x\(animation.height) min=\(minPixel) max=\(maxPixel)"
        )

        let data = Data(bytes: buffer, count: pixelCount * MemoryLayout<UInt32>.size)
        let provider = CGDataProvider(data: data as CFData)
        let bitmapInfo = CGBitmapInfo.init(alpha: .premultipliedFirst, component: .integer, byteOrder: .order32Little, pixelFormat: .packed)
        let cgImage = CGImage(
            width: animation.width,
            height: animation.height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: animation.width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo,
            provider: provider!,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )

        XCTAssertNotNil(cgImage, "Expected CGImage to be created from rendered buffer.")

        let pngData = NSMutableData()
        let destination = CGImageDestinationCreateWithData(pngData, "public.png" /* UTType.png.identifier */ as CFString, 1, nil)
        XCTAssertNotNil(destination, "Expected CGImageDestination to be created.")
        if let destination, let cgImage {
            CGImageDestinationAddImage(destination, cgImage, nil)
            XCTAssertTrue(CGImageDestinationFinalize(destination), "Expected PNG creation to succeed.")
            XCTAssertGreaterThan(pngData.length, 0, "Expected PNG data to be non-empty.")
        }
    }
}
