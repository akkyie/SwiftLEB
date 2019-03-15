public enum LEBError: Swift.Error, Equatable {
    case overflow
    case insufficientBytes
}

extension FixedWidthInteger where Self: UnsignedInteger {
    public init<T: Sequence>(LEB bytes: T) throws where T.Element == UInt8 {
        var result: Self = 0
        var shift: UInt = 0

        var iterator = bytes.makeIterator()
        var byte: UInt8
        repeat {
            byte = try {
                guard let byte = iterator.next() else {
                    throw LEBError.insufficientBytes
                }
                return byte
            }()

            guard shift < Self.bitWidth else {
                throw LEBError.overflow
            }

            let slice = Self(byte & 0b0111_1111)
            guard (slice << shift) >> shift == slice else {
                throw LEBError.overflow
            }
            result |= slice << shift
            shift += 7
        } while byte & 0b1000_0000 != 0

        self = result
    }
}

extension FixedWidthInteger where Self: SignedInteger {
    public init<T: Sequence>(LEB bytes: T) throws where T.Element == UInt8 {
        var result: Self = 0
        var shift: Self = 0

        var iterator = bytes.makeIterator()
        var byte: UInt8
        repeat {
            byte = try {
                guard let byte = iterator.next() else {
                    throw LEBError.insufficientBytes
                }
                return byte
            }()

            guard shift < Self.bitWidth else {
                throw LEBError.overflow
            }

            let slice = Self(byte & 0b0111_1111)
            result |= slice << shift
            shift += 7
        } while byte & 0b1000_0000 != 0

        if byte & 0b0100_0000 != 0 {
            result |= Self(~0) << shift
        }

        self = result
    }
}
