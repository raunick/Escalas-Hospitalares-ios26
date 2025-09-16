//
//  Escalas_Hospitalares_ios26App.swift
//  Escalas-Hospitalares-ios26
//
//  Created by Raunick Vileforte Vieira Generoso on 11/09/25.
//

import SwiftUI

@main
struct Escalas_Hospitalares_ios26App: App {
    // Armazena a preferência de tema do usuário
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataManager.shared.context)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
