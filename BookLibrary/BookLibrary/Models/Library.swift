//
//  Library.swift
//  BookLibrary
//
//  Created by taeni on 10/25/25.
//

import Foundation
internal import Combine

/// A collection of books that supports adding, removing, and filtering operations.
@MainActor
class Library: ObservableObject {
    @Published private(set) var books: [Book] = []
    
    /// Creates an empty library.
    init() {
        self.books = []
    }
    
    /// Creates a library containing the specified books.
    init(books: [Book]) {
        self.books = books
    }
    
    // MARK: - Adding Books
    
    /// Inserts the specified book at the end of the library.
    func add(_ book: Book) {
        books.append(book)
    }
    
    /// Inserts the contents of the specified books, in order, at the end of the library.
    func add(contentsOf newBooks: [Book]) {
        books.append(contentsOf: newBooks)
    }
    
    // MARK: - Removing Books
    
    /// Removes and returns the book at the specified position.
    func remove(at index: Int) -> Book {
        books.remove(at: index)
    }
    
    /// Removes the specified book from the library.
    func remove(_ book: Book) {
        books.removeAll { $0.id == book.id }
    }
    
    /// Removes all books from the library.
    func removeAll() {
        books.removeAll()
    }
    
    // MARK: - Updating Books
    
    /// Updates the book with the specified identifier.
    func update(_ book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else {
            return
        }
        books[index] = book
    }
    
    // MARK: - Querying Books
    
    /// Returns books that match the specified search query.
    func books(matching searchQuery: String) -> [Book] {
        guard !searchQuery.isEmpty else { return books }
        return books.filter { $0.matches(searchQuery: searchQuery) }
    }
    
    /// Returns books that have been read.
    func readBooks() -> [Book] {
        books.filter { $0.isRead }
    }
    
    /// Returns books that have not been read.
    func unreadBooks() -> [Book] {
        books.filter { !$0.isRead }
    }
    
    /// Returns books sorted by the specified criteria.
    func books(sortedBy criteria: SortCriteria) -> [Book] {
        switch criteria {
        case .title:
            return books.sorted { $0.title < $1.title }
        case .author:
            return books.sorted { $0.author < $1.author }
        case .readStatus:
            return books.sorted { $0.isRead && !$1.isRead }
        }
    }
    
    // MARK: - Statistics
    
    /// Returns `true` if the library contains no books; otherwise, `false`.
    var isEmpty: Bool {
        books.isEmpty
    }
    
    /// The total number of books in the library.
    var count: Int {
        books.count
    }
    
    /// The number of books that have been read.
    var readCount: Int {
        books.filter { $0.isRead }.count
    }
    
    /// The percentage of books that have been read.
    var readingProgress: Double {
        guard !isEmpty else { return 0 }
        return Double(readCount) / Double(count)
    }
}

// MARK: - Supporting Types

extension Library {
    /// Criteria for sorting books.
    enum SortCriteria {
        case title
        case author
        case readStatus
    }
}

// MARK: - Sample Data

extension Library {
    /// Creates a library with sample books for testing and previews.
    static func makeSample() -> Library {
        Library(books: [
            Book(title: "1984", author: "George Orwell", isRead: true, rating: 5),
            Book(title: "To Kill a Mockingbird", author: "Harper Lee", isRead: true, rating: 5),
            Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", isRead: false),
            Book(title: "Pride and Prejudice", author: "Jane Austen", isRead: true, rating: 4),
            Book(title: "The Catcher in the Rye", author: "J.D. Salinger", isRead: false)
        ])
    }
}
