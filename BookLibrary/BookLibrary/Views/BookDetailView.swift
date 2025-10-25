//
//  BookDetailView.swift
//  BookLibrary
//
//  Created by taeni on 10/25/25.
//


import SwiftUI

struct BookDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let book: Book
    let library: Library
    
    @State private var editedBook: Book
    @State private var isEditing = false
    
    init(book: Book, library: Library) {
        self.book = book
        self.library = library
        _editedBook = State(initialValue: book)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    bookCover
                    
                    bookInfo
                    
                    readingStatus
                    
                    ratingSection
                }
                .padding()
            }
            .navigationTitle("책 상세")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("완료") {
                            saveChanges()
                        }
                    } else {
                        Button("편집") {
                            isEditing = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var bookCover: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(editedBook.isRead ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .frame(width: 150, height: 200)
            
            Image(systemName: "book.fill")
                .font(.system(size: 60))
                .foregroundColor(editedBook.isRead ? .blue : .gray)
        }
    }
    
    private var bookInfo: some View {
        VStack(spacing: 12) {
            if isEditing {
                TextField("제목", text: $editedBook.title)
                    .textFieldStyle(.roundedBorder)
                    .font(.title2)
                
                TextField("저자", text: $editedBook.author)
                    .textFieldStyle(.roundedBorder)
                    .font(.title3)
            } else {
                Text(editedBook.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(editedBook.author)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var readingStatus: some View {
        VStack(spacing: 8) {
            Text("읽기 상태")
                .font(.headline)
            
            Toggle(isOn: $editedBook.isRead) {
                Text(editedBook.isRead ? "읽음" : "안 읽음")
            }
            .toggleStyle(.switch)
            .disabled(!isEditing)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var ratingSection: some View {
        VStack(spacing: 12) {
            Text("평점")
                .font(.headline)
            
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        if isEditing {
                            if editedBook.rating == star {
                                editedBook.clearRating()
                            } else {
                                editedBook.rate(star)
                            }
                        }
                    } label: {
                        Image(systemName: star <= (editedBook.rating ?? 0) ? "star.fill" : "star")
                            .font(.title)
                            .foregroundColor(star <= (editedBook.rating ?? 0) ? .yellow : .gray)
                    }
                    .disabled(!isEditing)
                }
            }
            
            if !editedBook.hasRating {
                Text("아직 평가하지 않음")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Actions
    
    private func saveChanges() {
        library.update(editedBook)
        isEditing = false
    }
}

// MARK: - Preview

#Preview {
    BookDetailView(
        book: Book(title: "1984", author: "George Orwell", isRead: true, rating: 5),
        library: Library()
    )
}