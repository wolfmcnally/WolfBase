import Foundation
import Testing
import WolfBase

struct BinarySearchTests {
    @Test(arguments: zip(
        [1, 2, 3, 6, 8, 10, 12, 14, 18, 30, -10, 50, 7],
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, nil, nil, nil]
    ))
    func binarySearch(value: Int, expected: Int?) {
        let a = [1, 2, 3, 6, 8, 10, 12, 14, 18, 30]
        #expect(a.binarySearch(for: value) == expected)
    }
    
    @Test(arguments: zip(
        [-10, 0, 1, 2, 5, 15, 29, 30, 31],
        [0, 0, 1, 2, 3, 8, 9, nil, nil]
    ))
    func upperBound2(value: Int, expected: Int?) {
        let a = [1, 2, 3, 6, 8, 10, 12, 14, 18, 30]
        #expect(a.upperBound(of: value) == expected)
    }
    
    @Test(arguments: zip(
        [-10, 0, 1, 2, 5, 15, 29, 30, 31],
        [nil, nil, 0, 1, 3, 8, 9, 9, nil]
    )) func verifyLowerBound(value: Int, expected: Int?) {
        let a = [1, 2, 3, 6, 8, 10, 12, 14, 18, 30]
        #expect(a.lowerBound(of: value) == expected)
    }
    
    @Test func verifyLowerUpperBounds() {
        let a = [10, 10, 10, 20, 20, 20, 30, 30]
        let lower = a.lowerBound(of: 20)!
        let upper = a.upperBound(of: 20)!
        #expect(a[lower..<upper] == [20, 20, 20])
    }
}
