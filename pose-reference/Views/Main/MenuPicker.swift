//
//  MenuPicker.swift
//  pose-reference
//
//  Created by jo on 2021-01-19.
//

import SwiftUI

public struct MenuPicker<T, V: View>: View {
    
    @Binding var selected: Int
    var array: [T]
    var title: String?
    let mapping: (T) -> V
    
    public init(selected: Binding<Int>, array: [T], title: String? = nil,
                mapping: @escaping (T) -> V) {
        self._selected = selected
        self.array = array
        self.title = title
        self.mapping = mapping
    }
    
    public var body: some View {
        if let existingTitle = title {
            HStack {
                Text(existingTitle)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                menu
            }
        } else {
            menu
        }
    }
    
    var menu: some View {
        Menu(content: {
            ForEach(array.indices, id: \.self) { index in
                Button(action: {
                    selected = index
                }, label: {
                   // view(for: index)
                })
            }
        }, label: {
            mapping(array[selected])
        })
    }
}
