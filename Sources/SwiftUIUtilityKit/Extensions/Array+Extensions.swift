//
//  Array+Extensions.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 09/04/25.
//

import Foundation

public extension Array {
    
    // MARK: - Safe Indexing
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    // MARK: - Chunking
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
    
    // MARK: - Random Safe Element
    var randomElementSafe: Element? {
        return isEmpty ? nil : randomElement()
    }
    
    // MARK: - Map with Index
    func mapWithIndex<T>(_ transform: (Int, Element) throws -> T) rethrows -> [T] {
        return try enumerated().map(transform)
    }
    
    // MARK: - Compact Map with Default
    func compactMapWithDefault<T>(_ transform: (Element) -> T?, defaultValue: T) -> [T] {
        return map { transform($0) ?? defaultValue }
    }
    
    // MARK: - First Matching Element with Default
    func first(where predicate: (Element) -> Bool, default defaultValue: Element) -> Element {
        return first(where: predicate) ?? defaultValue
    }

    // MARK: - Pretty Print (For Debugging)
    func prettyPrint() where Element: CustomStringConvertible {
        for item in self {
            print(item.description)
        }
    }
}

public extension Array where Element: Hashable {
    
    // MARK: - Removing Duplicates
    func removingDuplicates() -> [Element] {
        return Array(Set(self))
    }
}

// MARK: - Optional Advanced Utilities
public extension Array where Element: BinaryInteger {
    var sum: Element {
        reduce(0, +)
    }
    
    var average: Double {
        guard !isEmpty else { return 0 }
        return Double(sum) / Double(count)
    }
}

public extension Array where Element: BinaryFloatingPoint {
    var sum: Element {
        reduce(0, +)
    }
    
    var average: Double {
        guard !isEmpty else { return 0 }
        return Double(sum) / Double(count)
    }
}

public extension Array {

    // MARK: - Check if Array is Not Empty
    var isNotEmpty: Bool {
        return !isEmpty
    }

    // MARK: - Check if Array Contains Only Specific Element
    func containsOnly(_ element: Element) -> Bool where Element: Equatable {
        return allSatisfy { $0 == element }
    }

    // MARK: - Get Indexes Where Predicate is True
    func indexes(where predicate: (Element) -> Bool) -> [Int] {
        return enumerated().compactMap { predicate($0.element) ? $0.offset : nil }
    }
}

