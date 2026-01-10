//
//  ContentView.swift
//  PredicateSearchApp
//
//  Created by thierryH24 on 09/01/2026.
//

import SwiftUI
import SwiftData

// MARK: - Content View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allPersons: [EntityPerson]
    
    @State private var currentPredicate: NSPredicate?
    @State private var displayedPersons: [EntityPerson] = []
    @State private var parsedSwiftDataPredicate: String = ""
    @State private var showingAddPerson = false
    @State private var isFiltered = false
    
    var body: some View {
        NavigationSplitView {
            // Sidebar avec l'éditeur de prédicat
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Éditeur de prédicat")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color(nsColor: .controlBackgroundColor))
                
                Divider()
                
                // NSPredicateEditor
                NSPredicateEditorView(
                    predicate: $currentPredicate,
                    onPredicateChange: applyPredicate
                )
                .frame(minHeight: 250, maxHeight: .infinity)
                
                Divider()
                
                // Affichage du prédicat converti
                PredicateDisplayView(
                    nsPredicate: currentPredicate,
                    swiftDataPredicate: parsedSwiftDataPredicate
                )
            }
            .navigationSplitViewColumnWidth(min: 400, ideal: 500, max: 700)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: clearPredicate) {
                        Label("Effacer", systemImage: "trash")
                    }
                    .disabled(currentPredicate == nil)
                }
            }
        } detail: {
            // Liste des résultats
            ResultsView(
                persons: displayedPersons,
                totalCount: allPersons.count,
                isFiltered: isFiltered,
                onAddSample: addSampleData,
                onAddPerson: { showingAddPerson = true }
            )
        }
        .sheet(isPresented: $showingAddPerson) {
            AddPersonView()
        }
        .onChange(of: allPersons.count) { oldValue, newValue in
            print("AllPersons count changed: \(oldValue) -> \(newValue)")
            if !isFiltered {
                displayedPersons = allPersons
            }
        }
        .onAppear {
            displayedPersons = allPersons
        }
    }
    
    private func applyPredicate() {
        guard let predicate = currentPredicate else {
            clearPredicate()
            return
        }
        
        print("=== APPLY PREDICATE ===")
        print("NSPredicate: \(predicate)")
        print("Predicate format: \(predicate.predicateFormat)")
        
        // Vérifier que le prédicat est complet
        let predicateString = predicate.predicateFormat
        if predicateString.isEmpty || predicateString.contains("nil") {
            print("Predicate incomplete, skipping filter")
            return
        }
        
        // Filtrer les personnes en convertissant chaque personne en dictionnaire
        displayedPersons = allPersons.filter { person in
            let dict: [String: Any] = [
                "firstName": person.firstName,
                "lastName": person.lastName,
                "age": person.age,
                "department": person.department,
                "country": person.country,
                "isBool": person.isBool,
                "dateOfBirth": person.dateOfBirth
            ]
            
            return predicate.evaluate(with: dict)
        }
        
        // Convertir en SwiftData predicate
        parsedSwiftDataPredicate = convertToSwiftDataPredicate(predicate)
        
        isFiltered = true
        
        print("Filtered: \(displayedPersons.count) / \(allPersons.count)")
    }
    
    private func clearPredicate() {
        currentPredicate = nil
        displayedPersons = allPersons
        parsedSwiftDataPredicate = ""
        isFiltered = false
    }
    
    private func convertToSwiftDataPredicate(_ predicate: NSPredicate) -> String {
        let predicateString = predicate.predicateFormat
        
        // Conversion basique du format NSPredicate vers SwiftData
        var converted = predicateString
        
        // Remplacer les noms de clés par person.property
        let properties = ["firstName", "lastName", "age", "department", "country", "isBool", "dateOfBirth"]
        for property in properties {
            converted = converted.replacingOccurrences(of: property, with: "person.\(property)")
        }
        
        // Remplacer les opérateurs NSPredicate par Swift
        converted = converted.replacingOccurrences(of: " AND ", with: " && ")
        converted = converted.replacingOccurrences(of: " OR ", with: " || ")
        converted = converted.replacingOccurrences(of: " NOT ", with: " !")
        converted = converted.replacingOccurrences(of: "BEGINSWITH", with: "hasPrefix")
        converted = converted.replacingOccurrences(of: "ENDSWITH", with: "hasSuffix")
        converted = converted.replacingOccurrences(of: "CONTAINS", with: "contains")
        
        return "#Predicate<EntityPerson> { person in\n    \(converted)\n}"
    }
    
    private func addSampleData() {
        print("=== ADD SAMPLE DATA ===")
        let samples = [
            EntityPerson(firstName: "Jean", lastName: "Dupont", dateOfBirth: Date(timeIntervalSinceNow: -946080000), age: 30, department: "IT", country: "France", isBool: true),
            EntityPerson(firstName: "Marie", lastName: "Martin", dateOfBirth: Date(timeIntervalSinceNow: -788400000), age: 25, department: "HR", country: "France", isBool: false),
            EntityPerson(firstName: "Pierre", lastName: "Bernard", dateOfBirth: Date(timeIntervalSinceNow: -1262304000), age: 40, department: "Finance", country: "Belgique", isBool: true),
            EntityPerson(firstName: "Sophie", lastName: "Dubois", dateOfBirth: Date(timeIntervalSinceNow: -630720000), age: 20, department: "Marketing", country: "France", isBool: true),
            EntityPerson(firstName: "Luc", lastName: "Moreau", dateOfBirth: Date(timeIntervalSinceNow: -1104624000), age: 35, department: "IT", country: "Suisse", isBool: false),
            EntityPerson(firstName: "Isabelle", lastName: "Rousseau", dateOfBirth: Date(timeIntervalSinceNow: -820368000), age: 26, department: "Marketing", country: "France", isBool: true),
            EntityPerson(firstName: "Marc", lastName: "Lefevre", dateOfBirth: Date(timeIntervalSinceNow: -1420070400), age: 45, department: "IT", country: "Canada", isBool: false),
            EntityPerson(firstName: "Claire", lastName: "Fontaine", dateOfBirth: Date(timeIntervalSinceNow: -599616000), age: 19, department: "HR", country: "Belgique", isBool: true)
        ]
        
        for sample in samples {
            print("Adding: \(sample.firstName) \(sample.lastName)")
            modelContext.insert(sample)
        }
        
        do {
            try modelContext.save()
            print("Saved \(samples.count) persons successfully")
        } catch {
            print("Error saving: \(error)")
        }
    }
}
