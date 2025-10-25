//
//  BookRowView.swift
//  BookLibrary
//
//  Created by taeni on 10/25/25.
//

import SwiftUI

struct BookRowView: View {
    let book: Book
    let library: Library
    
    @State private var showingDetail = false
    
    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(spacing: 12) {
                bookIcon
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(book.author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if book.hasRating, let rating = book.rating {
                        ratingView(rating: rating)
                    }
                }
                
                Spacer()
                
                if book.isRead {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $showingDetail) {
            BookDetailView(book: book, library: library)
        }
    }
    
    // MARK: - View Components
    
    private var bookIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(book.isRead ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .frame(width: 50, height: 70)
            
            Image(systemName: "book.fill")
                .font(.title2)
                .foregroundColor(book.isRead ? .blue : .gray)
        }
    }
    
    private func ratingView(rating: Int) -> some View {
        HStack(spacing: 2) {
            ForEach(0..<rating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    List {
        BookRowView(
            book: Book(title: "1984", author: "George Orwell", isRead: true, rating: 5),
            library: Library()
        )
        BookRowView(
            book: Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald"),
            library: Library()
        )
    }
}
