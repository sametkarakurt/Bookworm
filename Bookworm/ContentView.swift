//
//  ContentView.swift
//  Bookworm
//
//  Created by Samet Karakurt on 3.03.2022.
//

import SwiftUI


struct ContentView: View {
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var books: FetchedResults<Book>
    @State private var showingAddScreen = false
    var body: some View {
        NavigationView{
            List{
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        HStack {
                            VStack(alignment: .leading){
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                    .foregroundColor(book.rating < 2 ? .red : .white)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }

                        }
                    }
                }
                .onDelete(perform: deleteBooks(at:))
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            
            let book = books[offset]
            
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
