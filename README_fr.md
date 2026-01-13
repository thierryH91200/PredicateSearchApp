
<a href="README.md">English</a> | <a href="README_fr.md">Français</a>




Application SwiftUI pour macOS démontrant l'utilisation de NSPredicateEditor avec SwiftData.

📋 Description
Cette application permet de créer des requêtes complexes sur une base de données SwiftData en utilisant l'interface graphique NSPredicateEditor. L'application parse automatiquement les prédicats NSPredicate générés par l'éditeur et les convertit en #Predicate SwiftData lorsque c'est possible.
✨ Fonctionnalités

Interface graphique intuitive : Utilisez NSPredicateEditor pour construire des requêtes complexes sans écrire de code
Conversion automatique : Parse les NSPredicate en #Predicate SwiftData pour des performances optimales
Support complet des opérateurs :

Comparaison : ==, !=, <, >, <=, >=
Texte : contains, beginsWith, endsWith (case sensitive/insensitive)
Logique : AND, OR, NOT
Booléens : true/false


Fallback intelligent : Si la conversion en #Predicate échoue, filtre manuellement les résultats
Prédicats imbriqués : Support des requêtes complexes avec plusieurs niveaux de conditions
Recherche en temps réel : Affichage instantané des résultats

🏗️ Architecture
Modèle de données
swift@Model
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
Composants principaux

PredicateEditorWrapper : Wrapper NSViewRepresentable pour intégrer NSPredicateEditor dans SwiftUI
PredicateParser : Parse les NSPredicate en structures utilisables
PredicateFactory : Génère des #Predicate SwiftData à partir des règles parsées
ModelContext Extension : Méthodes helper pour exécuter les recherches

🚀 Utilisation
Lancement de l'application

Ouvrez le projet dans Xcode
Compilez et exécutez (⌘R)
L'application charge automatiquement des données d'exemple

Créer une recherche

Cliquez sur le bouton "+" pour ajouter une condition
Sélectionnez le champ (firstName, age, country, etc.)
Choisissez l'opérateur (égal, contient, supérieur à, etc.)
Entrez la valeur recherchée
Ajoutez des conditions supplémentaires avec AND/OR
Cliquez sur "Rechercher" pour voir les résultats

Exemples de recherches
Trouver toutes les personnes de plus de 30 ans :

age > 30

Trouver les personnes en France avec un prénom commençant par "A" :

country == "France" AND firstName beginsWith "A"

Recherche complexe :

(age >= 25 AND age <= 40) AND (country == "France" OR country == "Belgium")

Recherche booléenne :

isBool == true AND department contains "IT"

🔧 Fonctionnalités techniques
Parsing NSPredicate → #Predicate
L'application parse intelligemment les NSPredicate :
swift// NSPredicate de NSPredicateEditor
let nsPredicate = NSPredicate(format: "age > 25 AND country == 'France'")

// Parser automatique
let parsed = PredicateParser.parse(nsPredicate)

// Conversion en #Predicate SwiftData
let swiftPredicate = #Predicate<EntityPerson> { person in
    person.age > 25 && person.country == "France"
}
```

### Limitations de #Predicate

Certaines fonctions ne sont pas supportées par `#Predicate` et nécessitent un filtrage manuel :

❌ Non supporté :
- `hasPrefix()` / `hasSuffix()` 
- Fonctions String complexes

✅ Supporté :
- `==`, `!=`, `<`, `>`, `<=`, `>=`
- `contains()`
- `localizedStandardContains()`

### Stratégie de recherche

1. **Tentative #Predicate** : L'app essaie d'abord de créer un #Predicate natif (plus performant)
2. **Fallback manuel** : Si impossible, filtre en mémoire avec NSPredicate
3. **Résultats garantis** : Vous obtenez toujours des résultats corrects

## 📊 Structure du code
```
PredicateSearchApp/
├── Models/
│   └── EntityPerson.swift           # Modèle SwiftData
├── Views/
│   ├── ContentView.swift            # Vue principale
│   ├── PredicateEditorWrapper.swift # Wrapper NSPredicateEditor
│   └── PersonListView.swift         # Liste des résultats
├── Parser/
│   ├── PredicateParser.swift        # Parse NSPredicate
│   ├── PredicateFactory.swift       # Génère #Predicate
│   └── PredicateBuilder.swift       # Builder pattern
├── Extensions/
│   └── ModelContext+Predicate.swift # Extensions helper
└── App/
    └── PredicateSearchApp.swift     # Point d'entrée
🎯 Cas d'usage

Gestion de personnel : Rechercher des employés selon plusieurs critères
Base de données clients : Filtrage avancé de contacts
Analyse de données : Requêtes complexes sur des ensembles de données
Outils d'administration : Interface de recherche pour administrateurs

🛠️ Technologies utilisées

SwiftUI : Interface utilisateur moderne
SwiftData : Persistance des données
AppKit : NSPredicateEditor pour macOS
Combine : Gestion des états réactifs

⚙️ Configuration requise

macOS 14.0+ (Sonoma)
Xcode 15.0+
Swift 5.9+

📝 Notes de développement
Ajout de nouveaux champs
Pour ajouter un champ de recherche :

Ajoutez la propriété dans EntityPerson
Créez le template dans PredicateEditorConfigurator
Ajoutez le cas dans PredicateField enum
Implémentez la logique dans PredicateFactory

Personnalisation
Modifiez PredicateEditorConfigurator.swift pour :

Changer les opérateurs disponibles
Ajouter/retirer des champs
Personnaliser les options (case sensitive, etc.)

🐛 Débogage
Pour voir le parsing en détail :
swiftif let parsed = PredicateParser.parse(predicate) {
    print(PredicateParser.debugDescription(parsed))
}
🤝 Contribution
Les contributions sont les bienvenues ! Pour contribuer :

Fork le projet
Créez une branche feature (git checkout -b feature/AmazingFeature)
Committez vos changements (git commit -m 'Add AmazingFeature')
Push vers la branche (git push origin feature/AmazingFeature)
Ouvrez une Pull Request

📄 Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
🙏 Remerciements

Apple pour SwiftData et NSPredicateEditor
La communauté Swift pour les bonnes pratiques
Tous les contributeurs du projet

📧 Contact
Pour toute question ou suggestion, n'hésitez pas à ouvrir une issue sur GitHub.

Note : Cette application est un exemple de démonstration. Pour une utilisation en production, ajoutez une gestion d'erreurs plus robuste, des tests unitaires, et optimisez les performances pour de grandes quantités de données.
</parameter>
</invoke>
</function_calls>
<function_calls>
<invoke name="computer">
<parameter name="action">bash</parameter>
<parameter name="command">cd /home/claude && wc -l PredicateSearchApp/README.md</parameter>
</invoke>
</function_calls>
<function_calls>
<invoke name="computer">
<parameter name="action">bash</parameter>
<parameter name="command">cp /home/claude/PredicateSearchApp/README.md /mnt/user-data/outputs/README.md</parameter>
