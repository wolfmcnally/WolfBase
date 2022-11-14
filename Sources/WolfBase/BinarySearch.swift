import Foundation
import Algorithms

public extension RandomAccessCollection where Element: Comparable {
    /// Returns the index that matches the element `val`. If no such
    /// index exists, returns `nil`.
    ///
    /// The collection must be sorted by ascending value.
    ///
    /// - Parameters:
    ///   - val: The element to be searched for.
    /// - Returns: The index of the searched for element, or `nil`.
    @inlinable
    func binarySearch(for val: Element) -> Index? {
        binarySearch(for: val, belongsInSecondPartition: { val <= $0 })
    }
    
    /// Returns the index that matches the element `val`. If no such
    /// index exists, returns `nil`.
    ///
    /// The collection must already be partitioned by the predicate.
    ///
    /// - Parameters:
    ///   - val: The element to be searched for.
    ///   - pred: A predicate that partitions the elements of the collection.
    /// - Returns: The index of the searched for element, or `nil`.
    @inlinable
    func binarySearch(for val: Element, belongsInSecondPartition: (Element) -> Bool) -> Index? {
        guard
            !isEmpty,
            first! <= last!,
            (first!...last!).contains(val)
        else {
            return nil
        }
        let index = partitioningIndex(where: belongsInSecondPartition)
        guard
            index != endIndex,
            self[index] == val
        else {
            return nil
        }
        return index
    }
    
    /// Returns the first index that compares greater than `val`. If no such index
    /// exists, returns `nil`.
    ///
    /// The collection must be sorted by ascending value.
    ///
    /// Unlike `lowerBound`, the value at the index returned by this function cannot be
    /// equivalent to `val`, only greater.
    ///
    /// - Parameters:
    ///   - val: The element to be searched for.
    /// - Returns: The index of the first greater element, or `nil`.
    @inlinable
    func upperBound(of val: Element) -> Index? {
        upperBound(of: val, belongsInSecondPartition: { val < $0 })
    }
    
    /// Returns the first index that compares greater than `val`. If no such index
    /// exists, returns `nil`.
    ///
    /// The collection must already be partitioned by the predicate.
    ///
    /// Unlike `lowerBound`, the value at the index returned by this function cannot be
    /// equivalent to `val`, only greater.
    ///
    /// - Parameters:
    ///   - val: The element to be searched for.
    ///   - pred: A predicate that partitions the elements of the collection.
    /// - Returns: The index of the first greater element, or `nil`.
    @inlinable
    func upperBound(of val: Element, belongsInSecondPartition: (Element) -> Bool) -> Index? {
        let index = partitioningIndex(where: belongsInSecondPartition)
        guard index != endIndex else {
            return nil
        }
        return index
    }
    
    /// Returns the first index that does not compare less than `val`. If no such index
    /// exists, returns `nil`.
    ///
    /// The collection must be sorted by ascending value.
    ///
    /// Unlike `upperBound`, the value at the index returned by this function may also
    /// be equivalent to `val`, and not only greater.
    ///
    /// - Parameters:
    ///   - val: The element to be searched for.
    /// - Returns: The index of the first greater element, or `nil`.
    @inlinable
    func lowerBound(of val: Element) -> Index? {
        lowerBound(of: val, belongsInSecondPartition: { val <= $0 })
    }

    /// Returns the first index that does not compare less than `val`. If no such index
    /// exists, returns `nil`.
    ///
    /// The collection must already be partitioned by the predicate.
    ///
    /// Unlike `upperBound`, the value at the index returned by this function may also
    /// be equivalent to `val`, and not only greater.
    ///
    /// - Parameters:
    ///   - val: The element to be searched for.
    ///   - pred: A predicate that partitions the elements of the collection.
    /// - Returns: The index of the first greater element, or `nil`.
    @inlinable
    func lowerBound(of val: Element, belongsInSecondPartition: (Element) -> Bool) -> Index? {
        guard
            !isEmpty,
            first! <= last!,
            (first!...last!).contains(val)
        else {
            return nil
        }
        let index = partitioningIndex(where: { belongsInSecondPartition($0) })
        guard index != endIndex else {
            return nil
        }
        return index
    }
}
