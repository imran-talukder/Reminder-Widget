//
//  AlertShow.swift
//  Reminder
//
//  Created by Appnap WS01 on 1/10/20.
//

import SwiftUI
import DataBaseFramework
struct AlertShow: View {
    @State private var text: String = ""
    @State private var selectedDate: Date = Date()
    
    @Environment (\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        VStack {
            Text("Enter New Task")
                .font(.headline)
                .padding(.top, 10)
            TextField("Type text here", text: $text).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
            HStack {
                DatePicker(selection: $selectedDate, label: { Text("Date") })
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }
            Divider()
            HStack {
                Button(action:
                {
                    presentationMode.wrappedValue.dismiss()
                })
                {
                    Text("Cancel")
                }
                .foregroundColor(.red)
                Spacer()
                Button(action:
                {
                    CoreDataManager.shared.createTask(task: text, givenTime: selectedDate)
                    print(selectedDate)
                    presentationMode.wrappedValue.dismiss()
                    
                })
                {
                    Text("Add")
                }
                .foregroundColor(.blue)
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.bottom, 10)
            .padding(.top, 10)
        }
        
        .background(Color(white: 0.9))
        .padding(.all)
        .cornerRadius(70)
        .shadow(radius: 15)
    }
}

struct AlertShow_Previews: PreviewProvider {
    static var previews: some View {
        AlertShow()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}
