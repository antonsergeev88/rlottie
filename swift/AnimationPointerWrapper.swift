import Foundation
import RLottieCPP

class AnimationPointerWrapper {
    fileprivate let pointer: OpaquePointer

    init(path: String) throws {
        guard let pointer = lottie_animation_from_file(path) else {
            throw Error.load
        }
        self.pointer = pointer
    }

    init(data: Data) throws {
        self.pointer = try data.withUnsafeBytes {
            let data = $0.bindMemory(to: Int8.self).baseAddress
            guard let pointer = lottie_animation_from_data(data, "", "") else {
                throw Error.load
            }
            return pointer
        }
    }

    deinit {
        lottie_animation_destroy(pointer)
    }

    enum Error: Swift.Error {
        case load
    }
}

prefix operator *

prefix func *(_ pointerWrapper: AnimationPointerWrapper) -> OpaquePointer {
    pointerWrapper.pointer
}
