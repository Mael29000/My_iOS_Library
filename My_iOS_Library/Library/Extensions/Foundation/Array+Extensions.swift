//
//  Array+Extensions.swift
//  My iOS library
//
//  Essential Array extensions for productivity
//

import Foundation

extension Array {

    // MARK: - Safe Access

    /// Safely accesses element at index
    subscript(safe index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }

    /// Safely accesses array of elements at indices
    subscript(safe indices: [Int]) -> [Element] {
        return indices.compactMap { self[safe: $0] }
    }

    // MARK: - Helpers

    /// Returns true if array is not empty
    var isNotEmpty: Bool {
        return !isEmpty
    }

    /// Returns the second element if exists
    var second: Element? {
        return self[safe: 1]
    }

    /// Returns the third element if exists
    var third: Element? {
        return self[safe: 2]
    }

    /// Returns the middle element
    var middle: Element? {
        guard count > 0 else { return nil }
        return self[count / 2]
    }

    // MARK: - Chunking

    /// Splits array into chunks of specified size
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }

    /// Groups elements by a key
    func grouped<Key: Hashable>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] {
        return Dictionary(grouping: self, by: { $0[keyPath: keyPath] })
    }

    // MARK: - Unique Elements

    /// Removes duplicate elements while preserving order
    func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { element in
            let key = element[keyPath: keyPath]
            return seen.insert(key).inserted
        }
    }

    // MARK: - Random

    /// Returns random elements from array
    func random(_ count: Int) -> [Element] {
        guard count > 0 else { return [] }
        guard count < self.count else { return shuffled() }

        var result: [Element] = []
        var indices = Set<Int>()

        while result.count < count {
            let index = Int.random(in: 0..<self.count)
            if indices.insert(index).inserted {
                result.append(self[index])
            }
        }

        return result
    }

    // MARK: - Rotation

    /// Rotates array by specified distance
    func rotated(by distance: Int) -> [Element] {
        guard count > 0 else { return [] }
        let distance = distance % count
        return Array(self[distance...] + self[..<distance])
    }

    /// Rotates array left by specified distance
    func rotatedLeft(by distance: Int) -> [Element] {
        return rotated(by: distance)
    }

    /// Rotates array right by specified distance
    func rotatedRight(by distance: Int) -> [Element] {
        return rotated(by: count - distance)
    }

    // MARK: - Filtering

    /// Removes all occurrences of element
    @discardableResult
    mutating func removeAll(_ element: Element) -> [Element] where Element: Equatable {
        self = filter { $0 != element }
        return self
    }

    /// Removes elements at indices
    @discardableResult
    mutating func remove(at indices: [Int]) -> [Element] {
        let sortedIndices = indices.sorted(by: >)
        for index in sortedIndices {
            if index < count {
                remove(at: index)
            }
        }
        return self
    }

    // MARK: - Sorting

    /// Returns array sorted by keyPath
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        return sorted { lhs, rhs in
            let lhsValue = lhs[keyPath: keyPath]
            let rhsValue = rhs[keyPath: keyPath]
            return ascending ? lhsValue < rhsValue : lhsValue > rhsValue
        }
    }

    /// Sorts array by keyPath
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) {
        self = sorted(by: keyPath, ascending: ascending)
    }

    // MARK: - Operations

    /// Returns the sum of elements
    func sum() -> Element where Element: Numeric {
        return reduce(0, +)
    }

    /// Returns the average of elements
    func average() -> Double where Element: BinaryInteger {
        guard count > 0 else { return 0 }
        return Double(sum()) / Double(count)
    }

    /// Returns the average of elements
    func average() -> Element where Element: FloatingPoint {
        guard count > 0 else { return 0 }
        return sum() / Element(count)
    }

    /// Returns the product of elements
    func product() -> Element where Element: Numeric {
        return reduce(1, *)
    }

    // MARK: - Insertion

    /// Inserts element between all elements
    func interspersed(with separator: Element) -> [Element] {
        guard count > 1 else { return self }
        return Array(self.map { [$0] }.joined(separator: [separator]))
    }

    /// Prepends element to array
    func prepending(_ element: Element) -> [Element] {
        return [element] + self
    }

    /// Appends element to array
    func appending(_ element: Element) -> [Element] {
        return self + [element]
    }

    // MARK: - Zipping

    /// Zips with another array and applies transform
    func zip<T, R>(with other: [T], transform: (Element, T) -> R) -> [R] {
        return Swift.zip(self, other).map(transform)
    }
}

// MARK: - Equatable Extensions

extension Array where Element: Equatable {

    /// Removes first occurrence of element
    @discardableResult
    mutating func removeFirst(_ element: Element) -> Element? {
        if let index = firstIndex(of: element) {
            return remove(at: index)
        }
        return nil
    }

    /// Returns array with duplicates removed
    var unique: [Element] {
        var uniqueElements: [Element] = []
        for element in self {
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
        return uniqueElements
    }

    /// Checks if array contains all elements from another array
    func contains(_ elements: [Element]) -> Bool {
        return elements.allSatisfy { contains($0) }
    }

    /// Returns difference from another array
    func difference(from other: [Element]) -> [Element] {
        return filter { !other.contains($0) }
    }

    /// Returns intersection with another array
    func intersection(with other: [Element]) -> [Element] {
        return filter { other.contains($0) }
    }

    /// Returns union with another array
    func union(with other: [Element]) -> [Element] {
        return (self + other).unique
    }
}

// MARK: - Hashable Extensions

extension Array where Element: Hashable {

    /// Returns unique elements using Set (faster for large arrays)
    var uniqueElements: [Element] {
        return Array(Set(self))
    }

    /// Returns duplicate elements
    var duplicates: [Element] {
        var seen = Set<Element>()
        var duplicates = Set<Element>()

        for element in self {
            if !seen.insert(element).inserted {
                duplicates.insert(element)
            }
        }

        return Array(duplicates)
    }

    /// Returns frequency of each element
    var frequencies: [Element: Int] {
        return reduce(into: [:]) { counts, element in
            counts[element, default: 0] += 1
        }
    }
}

// MARK: - String Array Extensions

extension Array where Element == String {

    /// Joins elements with separator
    func joined(separator: String = "") -> String {
        return self.joined(separator: separator)
    }

    /// Returns non-empty strings
    var nonEmpty: [String] {
        return filter { !$0.isEmpty }
    }

    /// Returns trimmed strings
    var trimmed: [String] {
        return map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    /// Returns lowercased strings
    var lowercased: [String] {
        return map { $0.lowercased() }
    }

    /// Returns uppercased strings
    var uppercased: [String] {
        return map { $0.uppercased() }
    }

    /// Returns capitalized strings
    var capitalized: [String] {
        return map { $0.capitalized }
    }
}

// MARK: - OptionalArray Extensions

extension Array where Element == Any? {

    /// Returns non-nil elements
    var compacted: [Any] {
        return compactMap { $0 }
    }
}

// MARK: - 2D Array Extensions

extension Array where Element: Collection {

    /// Flattens 2D array
    var flattened: [Element.Element] {
        return flatMap { $0 }
    }

    /// Transposes 2D array
    func transposed<T>() -> [[T]] where Element == Array<T> {
        guard let firstRow = first else { return [] }
        return firstRow.indices.map { index in
            self.map { $0[index] }
        }
    }
}