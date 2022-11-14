import Foundation

public class WeightedRandomGenerator {
    private let prefixSums: [Int]
    
    public init(_ weights: [Int]) {
        precondition(!weights.isEmpty)
        var prefixSums: [Int] = []
        prefixSums.reserveCapacity(weights.count)
        prefixSums.append(weights.first!)
        for index in 1 ..< weights.count {
            prefixSums.append(prefixSums[index - 1] + weights[index])
        }
        self.prefixSums = prefixSums
    }

    public func pick() -> Int {
        var rng = SystemRandomNumberGenerator()
        return pick(using: &rng)
    }
    
    public func pick<R: RandomNumberGenerator>(using rng: inout R) -> Int {
        let totalSum = prefixSums.last!
        let value = Int.random(in: 0 ..< totalSum, using: &rng)
        return prefixSums.upperBound(of: value)!
    }
}
