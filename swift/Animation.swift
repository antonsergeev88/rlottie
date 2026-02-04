import Foundation
import RLottieCPP

public struct Animation {
    private let wrapper: AnimationPointerWrapper

    public let width: Int
    public  let height: Int
    public let duration: Double
    public let frameCount: Int
    public let frameRate: Double

    private init(_ wrapper: AnimationPointerWrapper) {
        self.wrapper = wrapper

        (self.width, self.height) = {
            var width = 0
            var height = 0
            lottie_animation_get_size(*wrapper, &width, &height)
            return (width, height)
        }()
        self.duration = lottie_animation_get_duration(*wrapper)
        self.frameCount = lottie_animation_get_totalframe(*wrapper)
        self.frameRate = lottie_animation_get_framerate(*wrapper)
    }

    public init?(path: String) {
        guard let wrapper = try? AnimationPointerWrapper(path: path) else {
            return nil
        }
        self.init(wrapper)
    }

    public init?(data: Data) {
        guard let wrapper = try? AnimationPointerWrapper(data: data) else {
            return nil
        }
        self.init(wrapper)
    }

    public func frame(at position: Double) -> Int {
        lottie_animation_get_frame_at_pos(*wrapper, Float(position))
    }

    public func render(frame: Int, into data: inout Data, width: Int, height: Int) {
        data.withUnsafeMutableBytes { rawBuffer in
            let baseAddress = rawBuffer.bindMemory(to: UInt32.self).baseAddress
            if let baseAddress {
                render(frame: frame, into: baseAddress, width: width, height: height, bytesPerLine: width * 4)
            }
        }
    }

    public func render(frame: Int,
                       into buffer: UnsafeMutablePointer<UInt32>,
                       width: Int,
                       height: Int,
                       bytesPerLine: Int) {
        lottie_animation_render(*wrapper, frame, buffer, width, height, bytesPerLine)
    }
}
