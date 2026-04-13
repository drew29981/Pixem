//
//  You.swift
//  Pixem
//
//  Created by Andrew Younan on 7/1/2026.
//

import SwiftData
import SwiftUI

struct You: View {
    @AppStorage("currencyCode") private var currencyCode: String = Locale.current.currency?.identifier ?? "AUD"

    private let currencyCodes: [String] = {
        let common = ["AUD", "USD", "EUR", "GBP", "NZD", "CAD", "JPY", "CNY", "INR"]
        let all = Set(common).union(Locale.commonISOCurrencyCodes)
        return all.sorted()
    }()

    var body: some View {
        Form {
            Section("Preferences") {
                Picker("Currency", selection: $currencyCode) {
                    ForEach(currencyCodes, id: \.self) { code in
                        Text("\(code) — \(Locale.current.localizedString(forCurrencyCode: code) ?? code)")
                            .tag(code)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("You")
            }
        }
    }
}
