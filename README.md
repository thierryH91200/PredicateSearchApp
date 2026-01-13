# PredicateSearchApp

<a href="README.md">English</a> | <a href="README_fr.md">Français</a>

SwiftUI application for macOS demonstrating the use of NSPredicateEditor with SwiftData.

## 📋 Description

This application allows you to create complex queries on a SwiftData database using the NSPredicateEditor graphical interface. The app provides a visual interface to build predicates and filter data in real-time.

## ✨ Features

- **Intuitive graphical interface**: Use NSPredicateEditor to build complex queries without writing code
- **Real-time filtering**: Results update automatically as you modify your predicate
- **Full operator support**:
  - Comparison: `==`, `!=`, `<`, `>`, `<=`, `>=`
  - Text: `contains`, `beginsWith`, `endsWith` (case sensitive/insensitive)
  - Logic: `AND`, `OR`, `NOT`
  - Booleans: `true`/`false`
  - Dates: date comparisons
- **Database filtering**: Filters directly at the database level using Core Data's NSPredicate
- **Nested predicates**: Support for complex queries with multiple condition levels
- **Sample data**: Quick generation of test data

## 🏗️ Architecture

### Data Model

```swift
@Model
final class EntityPerson {
    var id: UUID
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var age: Int
    var department: String
    var country: String
    var isBool: Bool
}
```

### Main Components

- **NSPredicateEditorView**: NSViewRepresentable wrapper to integrate NSPredicateEditor in SwiftUI
- **ContentView**: Main view with split layout (predicate editor + results)
- **PredicateDisplayView**: Displays the generated NSPredicate format
- **ResultsView**: Table showing filtered results
- **AddPersonView**: Form to add new persons

### Technical Implementation

The app uses a hybrid approach combining SwiftData and Core Data:

1. SwiftData is used for the data model (`@Model`) and basic queries
2. Core Data's underlying `NSManagedObjectContext` is accessed for NSPredicate filtering
3. This provides optimal performance by filtering at the database level

## 🚀 Usage

### Launching the Application

1. Open the project in Xcode
2. Build and run (⌘R)
3. Click "Add examples" to load sample data

### Creating a Search

1. Click the "+" button to add a condition
2. Select the field (firstName, lastName, age, country, department, isBool, dateOfBirth)
3. Choose the operator (equals, contains, greater than, etc.)
4. Enter the search value
5. Add additional conditions with AND/OR/NOT
6. Results update automatically

### Search Examples

**Find all people over 30 years old:**
```
age > 30
```

**Find people in France with first name starting with "Marie":**
```
country == "France" AND firstName BEGINSWITH "Marie"
```

**Complex search:**
```
(age >= 25 AND age <= 40) AND (country == "France" OR country == "Belgique")
```

**Boolean search:**
```
isBool == true AND department CONTAINS "IT"
```

**Case-insensitive search:**
```
firstName CONTAINS[cd] "jean"
```

## 🔧 Technical Details

### Database Filtering

The application uses Core Data's `NSFetchRequest` under SwiftData to filter directly at the database level:

```swift
// Access the underlying NSManagedObjectContext
guard let managedObjectContext = (modelContext as? NSObject)?
    .value(forKey: "managedObjectContext") as? NSManagedObjectContext else {
    // Fallback to in-memory filtering
}

// Use NSFetchRequest with NSPredicate
let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityPerson")
fetchRequest.predicate = nsPredicate
let results = try managedObjectContext.fetch(fetchRequest)
```

### Fallback Strategy

1. **Primary**: Database-level filtering using NSPredicate with NSFetchRequest
2. **Fallback**: If Core Data context is not accessible, filters in memory using NSPredicate

This ensures the app always works, even if the internal SwiftData structure changes.

## 📊 Code Structure

```
PredicateSearchApp/
├── Models.swift                      # SwiftData model (EntityPerson)
├── ContentView.swift                 # Main view with filtering logic
├── NSPredicateEditorView.swift       # NSPredicateEditor wrapper
├── PredicateDisplayView.swift        # Results and display views
├── NSPredicateEditorRowTemplate.swift # Template extensions
├── AppDelegate.swift                 # App lifecycle
└── PredicateSearchApp.swift          # Entry point
```

## 🎯 Use Cases

- Personnel management: Search employees by multiple criteria
- Customer database: Advanced contact filtering
- Data analysis: Complex queries on datasets
- Administration tools: Search interface for administrators
- Learning tool: Understanding NSPredicateEditor and SwiftData

## 🛠️ Technologies Used

- **SwiftUI**: Modern user interface
- **SwiftData**: Data persistence and model layer
- **Core Data**: Underlying database with NSPredicate support
- **AppKit**: NSPredicateEditor for macOS

## ⚙️ Requirements

- macOS 14.0+ (Sonoma)
- Xcode 15.0+
- Swift 5.9+

## 📝 Development Notes

### Adding New Fields

To add a search field:

1. Add the property in `EntityPerson` model
2. Create the template in `NSPredicateEditorView.setupTemplates()`
3. Update the dictionary mapping in `displayedPersons` computed property (for fallback filtering)

### Customization

Modify `NSPredicateEditorView.swift` to:

- Change available operators
- Add/remove fields
- Customize options (case sensitive, diacritics, etc.)
- Modify the appearance

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.

## 🙏 Acknowledgments

- Apple for SwiftData, Core Data, and NSPredicateEditor
- The Swift community for best practices

## 📧 Contact

For any questions or suggestions, feel free to open an issue on GitHub.

---

**Note**: This application is a demonstration example. For production use, consider adding more robust error handling, unit tests, and performance optimizations for very large datasets.
