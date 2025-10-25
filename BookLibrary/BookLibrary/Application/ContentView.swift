//
//  ContentView.swift
//  BookLibrary
//
//  Created by taeni on 10/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var library = Library.makeSample()
    @State private var searchQuery = ""
    @State private var showingAddBook = false
    @State private var selectedFilter: FilterOption = .all
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                filterPicker
                
                bookList
            }
            .navigationTitle("내 도서관")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddBook = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: "책 제목이나 저자 검색")
            .sheet(isPresented: $showingAddBook) {
                AddBookView(library: library)
            }
        }
    }
    
    // MARK: - View Components
    
    private var filterPicker: some View {
        Picker("필터", selection: $selectedFilter) {
            ForEach(FilterOption.allCases, id: \.self) { option in
                Text(option.title)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    private var bookList: some View {
        List {
            ForEach(filteredBooks) { book in
                BookRowView(book: book, library: library)
            }
            .onDelete(perform: deleteBooks)
        }
        .overlay {
            if filteredBooks.isEmpty {
                emptyStateView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "books.vertical")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("책이 없습니다")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(emptyStateMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    // MARK: - Computed Properties
    
    private var filteredBooks: [Book] {
        let searchResults = library.books(matching: searchQuery)
        
        switch selectedFilter {
        case .all:
            return searchResults
        case .read:
            return searchResults.filter { $0.isRead }
        case .unread:
            return searchResults.filter { !$0.isRead }
        }
    }
    
    private var emptyStateMessage: String {
        if !searchQuery.isEmpty {
            return "'\(searchQuery)'에 대한 검색 결과가 없습니다"
        }
        
        switch selectedFilter {
        case .all:
            return "+ 버튼을 눌러 첫 책을 추가하세요"
        case .read:
            return "아직 읽은 책이 없습니다"
        case .unread:
            return "모든 책을 읽으셨습니다! 🎉"
        }
    }
    
    // MARK: - Actions
    
    private func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            let book = filteredBooks[index]
            library.remove(book)
        }
    }
}

// MARK: - Supporting Types

extension ContentView {
    enum FilterOption: CaseIterable {
        case all
        case read
        case unread
        
        var title: String {
            switch self {
            case .all: return "전체"
            case .read: return "읽음"
            case .unread: return "안 읽음"
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
