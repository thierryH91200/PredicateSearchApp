//
//  PredicateDisplayView.swift
//  test44
//
//  Created by thierryH24 on 10/01/2026.
//


import SwiftUI
import SwiftData
import AppKit

// MARK: - Predicate Display View
struct PredicateDisplayView: View {
    let nsPredicate: NSPredicate?
    let swiftDataPredicate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let predicate = nsPredicate {
                VStack(alignment: .leading, spacing: 8) {
                    Text("NSPredicate Format:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(predicate.predicateFormat)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.primary)
                        .textSelection(.enabled)
                        .padding(8)
                        .background(Color(nsColor: .controlBackgroundColor))
                        .cornerRadius(4)
                }
                
                if !swiftDataPredicate.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SwiftData #Predicate:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(swiftDataPredicate)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.blue)
                            .textSelection(.enabled)
                            .padding(8)
                            .background(Color(nsColor: .controlBackgroundColor))
                            .cornerRadius(4)
                    }
                }
            } else {
                Text("Aucun prédicat défini")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Results View
struct ResultsView: View {
    let persons: [EntityPerson]
    let totalCount: Int
    let isFiltered: Bool
    var onAddSample: () -> Void
    var onAddPerson: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                if isFiltered {
                    Text("Résultats: \(persons.count) / \(totalCount)")
                        .font(.headline)
                } else {
                    Text("Toutes les personnes: \(totalCount)")
                        .font(.headline)
                }
                
                Spacer()
                
                if totalCount == 0 {
                    Button("⚡ Ajouter des exemples", action: onAddSample)
                        .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))
            
            Divider()
            
            // Liste ou vue vide
            if persons.isEmpty {
                ContentUnavailableView(
                    isFiltered ? "Aucun résultat" : "Aucune personne",
                    systemImage: isFiltered ? "line.3.horizontal.decrease.circle" : "person.slash",
                    description: Text(isFiltered ? "Aucune personne ne correspond au prédicat" : "Ajoutez des personnes pour commencer")
                )
            } else {
                
                Table(persons) {
                    TableColumn("First Name") { Text(String($0.firstName)) }
                    TableColumn("Last Name") { Text(String($0.lastName)) }
                    TableColumn("Age") { Text(String($0.age)) }
                    TableColumn("Country") { Text(String($0.country)) }
                    TableColumn("Department") { Text(String($0.department)) }
                    TableColumn("Bool") { Text($0.isBool ? "true" : "false") }
                    TableColumn("Date of birth") {
                        Text($0.dateOfBirth.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: onAddPerson) {
                    Label("Ajouter", systemImage: "plus")
                }
            }
            
            if totalCount > 0 {
                ToolbarItem(placement: .automatic) {
                    Button("Ajouter des exemples", action: onAddSample)
                }
            }
        }
    }
}

// MARK: - Add Person View
struct AddPersonView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = 25
    @State private var department = "IT"
    @State private var country = "France"
    @State private var isBool = true
    
    let departments = ["IT", "HR", "Finance", "Marketing", "Sales"]
    let countries = ["France", "Belgique", "Suisse", "Canada"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informations personnelles") {
                    TextField("Prénom", text: $firstName)
                    TextField("Nom", text: $lastName)
                    Stepper("Âge: \(age)", value: $age, in: 18...99)
                }
                
                Section("Informations professionnelles") {
                    Picker("Département", selection: $department) {
                        ForEach(departments, id: \.self) { dept in
                            Text(dept).tag(dept)
                        }
                    }
                    
                    Picker("Pays", selection: $country) {
                        ForEach(countries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                    
                    Toggle("Statut booléen", isOn: $isBool)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Nouvelle personne")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        addPerson()
                        dismiss()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty)
                }
            }
            .frame(minWidth: 400, minHeight: 300)
        }
    }
    
    private func addPerson() {
        let person = EntityPerson(
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: Date(timeIntervalSinceNow: -Double(age) * 31536000),
            age: age,
            department: department,
            country: country,
            isBool: isBool
        )
        modelContext.insert(person)
        try? modelContext.save()
    }
}
