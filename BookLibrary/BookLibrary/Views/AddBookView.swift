//
//  AddBookView.swift
//  BookLibrary
//
//  Created by taeni on 10/25/25.
//


import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    
    let library: Library
    
    @State private var title = ""
    @State private var author = ""
    @State private var isRead = false
    @State private var rating: Int?
    
    var body: some View {
        NavigationView {
            Form {
                Section("책 정보") {
                    TextField("제목", text: $title)
                    TextField("저자", text: $author)
                }
                
                Section("읽기 상태") {
                    Toggle("읽음", isOn: $isRead)
                }
                
                Section("평점") {
                    ratingPicker
                    
                    if rating != nil {
                        Button("평점 제거") {
                            rating = nil
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("새 책 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("추가") {
                        addBook()
                    }
                    .disabled(!isValidInput)
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var ratingPicker: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { star in
                Button {
                    if rating == star {
                        rating = nil
                    } else {
                        rating = star
                    }
                } label: {
                    Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(star <= (rating ?? 0) ? .yellow : .gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Computed Properties
    
    private var isValidInput: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !author.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Actions
    
    private func addBook() {
        let newBook = Book(
            title: title.trimmingCharacters(in: .whitespaces),
            author: author.trimmingCharacters(in: .whitespaces),
            isRead: isRead,
            rating: rating
        )
        
        library.add(newBook)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    AddBookView(library: Library())
}