//
//  View.swift
//  NoteApp
//
//  Created by Manato Abe on 2024/11/04.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var selectedNote: Note?
    @State private var animateView: Bool = false
    @State private var notes: [Note] = mockNotes
    
    @Namespace private var animation
    
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                SearchBar()
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    ForEach($notes) { $note in
                        CardView(note)
                            .frame(height: 160)
                            .onTapGesture {
                                guard selectedNote == nil else { return }
                                
                                selectedNote = note
                                note.allowHitTesting = true
                                
                                withAnimation(noteAnimation) {
                                    animateView = true
                                }
                            }
                    }
                }
            }
        }
        .safeAreaPadding(15)
        .overlay {
            GeometryReader { _ in
                // 同時に開くのを避ける
                ForEach(mockNotes) { note in
                    if note.id == selectedNote?.id && animateView {
                        DetailView(animation: animation, note: note)
                            .ignoresSafeArea(.container, edges: .top)
                    }
                }
                
            }
            
            .safeAreaInset(edge: .bottom,  spacing: 0) {
                ButtonView()
                
            }
        }
    }
    // 検索バー
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
            
            TextField("検索", text: $searchText)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.primary.opacity(0.06), in: .rect(cornerRadius: 10))
    }
    
    // カード
    @ViewBuilder
    func CardView(_ note: Note) -> some View {
        ZStack {
            if selectedNote?.id == note.id && animateView {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(note.color.gradient)
                    .matchedGeometryEffect(id: note.id, in: animation)
            }
        }
    }
    // ボタンバー
    @ViewBuilder
    func ButtonView() -> some View {
        HStack(spacing: 15) {
            Button {
                
            } label: {
                Image(systemName: selectedNote == nil ? "plus.circle.fill" : "trash.fill")
                    .font(.title2)
                    .foregroundStyle(selectedNote == nil ? Color.primary : .red)
                    .contentShape(.rect)
                    .contentTransition(.symbolEffect(.replace))
            }
            Spacer(minLength: 0)
            
            if selectedNote != nil {
                Button {
                    if let firstIndex = notes.firstIndex(where: { $0.id == selectedNote?.id }) {
                        notes[firstIndex].allowHitTesting = false
                    }
                    
                    withAnimation(noteAnimation) {
                        animateView = false
                        selectedNote = nil
                    }
                } label: {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.title2)
                        .foregroundStyle(Color.primary)
                        .contentShape(.rect)
                }
            }
            
        }
        .overlay {
            Text("Notes")
                .font(.callout)
                .fontWeight(.semibold)
                .opacity(selectedNote == nil ? 0 : 1)
        }
        .overlay {
            if selectedNote != nil {
                CardColorPicker()
                    .transition(.blurReplace)
            }
        }
        .padding(15)
        .background(.bar)
    }
    
    //
    @ViewBuilder
    func CardColorPicker() -> some View {
        HStack(spacing: 10) {
            ForEach(1...5, id: \.self) { index in
                Circle()
                    .fill(.red.gradient)
                    .frame(width: 20, height: 20)
                
            }
        }
    }
    
    
}
#Preview {
    HomeView()
}

struct DetailView: View {
    @State private var animateLayer: Bool = false
    
    var animation: Namespace.ID
    var note: Note
    
    var body: some View {
        RoundedRectangle(cornerRadius:animateLayer ? 0 : 10)
            .fill(note.color.gradient)
            .matchedGeometryEffect(id: note.id, in: animation)
            .transition(.offset(y: 1))
        //閉じてる間に別のメモを開く
            .allowsHitTesting(note.allowHitTesting)
            .onChange(of: note.allowHitTesting, initial: true) { oldValue, newValue in
                withAnimation(noteAnimation) {
                    animateLayer = newValue
                }
            }
    }
}


extension View {
    // アニメーション
    var noteAnimation: Animation {
        .smooth(duration: 0.3, extraBounce: 0)
    }
    
}
