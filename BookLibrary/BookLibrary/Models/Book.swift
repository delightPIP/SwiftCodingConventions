//
//  Book.swift
//  BookLibrary
//
//  Created by taeni on 10/25/25.
//

import Foundation

/// A book in the library with title, author, and reading status.
struct Book: Identifiable, Equatable {
    let id: UUID
    var title: String
    var author: String
    var isRead: Bool
    var rating: Int?
    
    /// Creates a new book with the specified details.
    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        isRead: Bool = false,
        rating: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.isRead = isRead
        self.rating = rating
    }
    
    // MARK: - Nonmutating Methods (명사구로 읽힘)
    
    /// Returns a copy of this book marked as read.
    func markingAsRead() -> Book {
        Book(
            id: id,
            title: title,
            author: author,
            isRead: true,
            rating: rating
        )
    }
    
    /// Returns a copy of this book with the specified rating.
    func rating(_ newRating: Int) -> Book {
        Book(
            id: id,
            title: title,
            author: author,
            isRead: isRead,
            rating: newRating
        )
    }
    
    // MARK: - Mutating Methods (명령형 동사구로 읽힘)
    
    /// Marks this book as read.
    mutating func markAsRead() {
        isRead = true
    }
    
    /// Sets the rating for this book.
    mutating func rate(_ newRating: Int) {
        rating = newRating
    }
    
    /// Removes the rating from this book.
    mutating func clearRating() {
        rating = nil
    }
}

extension Book {
    /// Returns `true` if this book has a rating; otherwise, `false`.
    var hasRating: Bool {
        rating != nil
    }
    
    /// Returns `true` if this book matches the search query; otherwise, `false`.
    func matches(searchQuery: String) -> Bool {
        guard !searchQuery.isEmpty else { return true }
        
        let lowercasedQuery = searchQuery.lowercased()
        return title.lowercased().contains(lowercasedQuery) ||
               author.lowercased().contains(lowercasedQuery)
    }
}
