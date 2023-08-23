// Based on http://giflib.sourceforge.net/whatsinagif/lzw_image_data.html
import Logging

fileprivate let log = Logger(label: "GIF.LzwEncoderTable")

struct LzwEncoderTable: CustomStringConvertible {
    // Stores the mapping from multiple indices to a single code
    private var entries: [[Int32]: Int] = [:]
    public var meta: LzwTableMeta
    public var description: String { "\(entries)" }

    public init(colorCount: Int) {
        meta = LzwTableMeta(colorCount: colorCount)
    }

    public subscript(indices: [Int32]) -> Int? {
        if indices.count == 1 {
            // A single index matches its color code
            return Int(indices.first!)
        } else {
            return entries[indices]
        }
    }

    public mutating func append(indices: [Int32]) {
        assert(indices.count > 1)
        entries[indices] = meta.count
        log.trace("Added \(meta.count)")
        meta.incrementCount()
        meta.updateCodeSize(offset: 1)
    }

    public func contains(indices: [Int32]) -> Bool {
        return self[indices] != nil
    }

    public mutating func reset() {
        entries = [:]
        meta.reset()
    }
}
