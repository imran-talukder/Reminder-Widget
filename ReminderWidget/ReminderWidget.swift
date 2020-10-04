//
//  ReminderWidget.swift
//  ReminderWidget
//
//  Created by Appnap WS01 on 1/10/20.
//

import WidgetKit
import SwiftUI
import DataBaseFramework

struct Provider: TimelineProvider {
    
    @AppStorage("allTasks", store: UserDefaults(suiteName: "group.com.Appnap.Reminder"))
    var localData: Data = Data()
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), task: "Preview task", ID: 0, doTime: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), task: "Preview task", ID: 0, doTime: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        DispatchQueue.main.async {
            guard let updatedData = try? JSONDecoder().decode(DataModel.self, from: localData) else { return }
            for p in 1...4 {
                for i in updatedData.id {
                    let fixedDate = Calendar.current.date(byAdding: .second, value: (p - 1) * (updatedData.task.count) * 3 + i * 3, to: Date())!
                    entries.append(SimpleEntry(date: fixedDate, task: updatedData.task[i], ID: (i % updatedData.task.count) + 1, doTime: updatedData.date[i]))
                }
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let task: String
    let ID: Int
    let doTime: Date
}

struct ReminderWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack {
                Label(String(entry.ID), systemImage: "pencil.and.outline")
                    .padding(.top, 30)
                    .foregroundColor(.blue)
                    .font(.title)
                Spacer()
                Text(entry.task)
                    .padding(.bottom, 20)
                    //.font(.title)
                HStack {
                    Text(entry.doTime, style: .date)
                        .padding(.bottom, 20)
                        .font(.title3)
                    Text(entry.doTime, style: .time)
                        .padding(.bottom, 20)
                        .font(.title3)
                }
            }
        }
        .background(Image("background_3")
                        .scaledToFill()
        )
    }
}

@main
struct ReminderWidget: Widget {
    let kind: String = "ReminderWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ReminderWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct ReminderWidget_Previews: PreviewProvider {
    static var previews: some View {
        ReminderWidgetEntryView(entry: SimpleEntry(date: Date(), task: "Preview task", ID: 0, doTime: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
