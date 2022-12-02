//
//  SettingView.swift
//  TextSnip
//
//  Created by PAN on 2022/12/2.
//

import KeyboardShortcuts
import SwiftUI
import LaunchAtLogin

struct SettingView: View {
    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                Text("Launch at Login")
                Toggle(isOn: $launchAtLogin.isEnabled) {
                    EmptyView()
                }
                .toggleStyle(.checkbox)
                Spacer()
            }
            HStack(spacing: 10) {
                Text("Shortcut")
                KeyboardShortcuts.Recorder("", name: .startCapture)
                Button("Reset") {
                    KeyboardShortcuts.reset(.startCapture)
                }
                .padding(.horizontal, 10)
                Spacer()
            }
            .padding(.trailing, 20)
            Spacer()
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 30)
        .frame(width: 400)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
