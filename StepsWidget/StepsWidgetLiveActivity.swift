//
//  StepsWidgetLiveActivity.swift
//  StepsWidget
//
//  Created by Taha Chaudhry on 26/08/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct StepsWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct StepsWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StepsWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension StepsWidgetAttributes {
    fileprivate static var preview: StepsWidgetAttributes {
        StepsWidgetAttributes(name: "World")
    }
}

extension StepsWidgetAttributes.ContentState {
    fileprivate static var smiley: StepsWidgetAttributes.ContentState {
        StepsWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: StepsWidgetAttributes.ContentState {
         StepsWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: StepsWidgetAttributes.preview) {
   StepsWidgetLiveActivity()
} contentStates: {
    StepsWidgetAttributes.ContentState.smiley
    StepsWidgetAttributes.ContentState.starEyes
}
