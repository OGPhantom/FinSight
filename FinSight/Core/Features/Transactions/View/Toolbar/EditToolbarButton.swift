//
//  EditToolbarButton.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct EditToolbarButton: View {
    @Binding var editMode: EditMode

    var body: some View {
        Button {
            withAnimation {
                editMode = editMode == .active ? .inactive : .active
            }
        } label: {
            Text(editMode == .active ? "Done" : "Edit")
                .font(.system(size: 18, weight: .semibold))
        }
    }
}
