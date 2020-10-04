//
//  ContentView.swift
//  Reminder
//
//  Created by Appnap WS01 on 1/10/20.
//

import SwiftUI
import DataBaseFramework
import WidgetKit

struct ContentView: View {
    @State var showAlert = false
    @State var newTask = ""
    @State var getTask = CoreDataManager.shared.fetch()
    @State var selectedDate: Date = Date()
    @AppStorage("allTasks", store: UserDefaults(suiteName: "group.com.Appnap.Reminder"))
    var data: Data = Data()
    
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(getTask, id: \.self) { item in
                    VStack {
                        Text(item.taskDescription)
                            .font(.title2)
                        HStack {
                            Text(item.givenTime, style: .date)
        
                            Text(item.givenTime, style: .time)
                        }
                    }
                    
                }
                
                
            }
            .navigationBarTitle("Reminder", displayMode: .inline)
            .navigationBarItems(trailing:
                    Button(action: {
                        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                        showAlert = true
                    })
                    {
                        Image(systemName: "plus.circle.fill")
                    }
            )
            .foregroundColor(.green)
            .sheet(isPresented: $showAlert) {
                AlertShow()
                    .onDisappear {
                        
                        //print(selectedDate)
                        
                        let tempdata = CoreDataManager.shared.fetch()
                        getTask = tempdata
                        
                        var taskArray: [String] = []
                        var idArray: [Int] = []
                        var dateArray: [Date] = []
                        var i = 0
                        for each in tempdata {
                            taskArray.append(each.taskDescription)
                            idArray.append(i)
                            dateArray.append(each.givenTime)
                            i += 1
                        }
                        let allTask = DataModel(id: idArray, task: taskArray, date: dateArray)
                        guard let getData = try? JSONEncoder().encode(allTask) else { return }
                        data.self = getData
                        WidgetCenter.shared.reloadTimelines(ofKind: "ReminderWidget")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}
