import SwiftUI

// Enum para definir as categorias das escalas.
enum ScaleCategory: String, CaseIterable {
    case adulto = "Avaliações Adulto & Geral"
    case pediatria = "Avaliações Pediátricas"
}

// Estrutura para representar cada escala médica, agora com uma categoria.
struct MedicalScale: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let category: ScaleCategory
}

// Onde definimos todas as escalas, agora atribuindo uma categoria a cada uma.
struct ScalesData {
    static let allScales: [MedicalScale] = [
        // Adulto & Geral
        MedicalScale(name: "Glasgow", description: "Avaliação do nível de consciência", category: .adulto),
        MedicalScale(name: "Morse", description: "Risco de queda em adultos", category: .adulto),
        MedicalScale(name: "Braden", description: "Risco de lesão por pressão", category: .adulto),
        MedicalScale(name: "Ramsay", description: "Nível de sedação", category: .adulto),
        MedicalScale(name: "MEEM", description: "Mini Exame do Estado Mental", category: .adulto),
        MedicalScale(name: "MEWS", description: "Alerta de deterioração em adultos", category: .adulto),
        MedicalScale(name: "NEWS2", description: "Alerta nacional de deterioração", category: .adulto),
        
        // Pediátricas
        MedicalScale(name: "Apgar", description: "Vitalidade do recém-nascido", category: .pediatria),
        MedicalScale(name: "Humpty Dumpty", description: "Risco de queda em pediatria", category: .pediatria),
        MedicalScale(name: "PEWS", description: "Alerta de deterioração pediátrica", category: .pediatria)
    ]
}

// A tela principal (Home), agora com a lista dividida em seções.
struct ContentView: View {
    let escalas = ScalesData.allScales
    let categories = ScaleCategory.allCases // Pega todas as categorias do Enum.

    var body: some View {
        NavigationStack {
            List {
                // Loop para criar uma seção para cada categoria.
                ForEach(categories, id: \.self) { category in
                    Section(header: Text(category.rawValue)) {
                        // Filtra e lista apenas as escalas que pertencem à categoria atual.
                        ForEach(escalas.filter { $0.category == category }) { escala in
                            NavigationLink(value: escala) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(escala.name)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    Text(escala.description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Escalas Médicas")
            .navigationDestination(for: MedicalScale.self) { escala in
                ScaleDetailView(scale: escala)
            }
        }
    }
}

// View que decide qual formulário de escala mostrar.
struct ScaleDetailView: View {
    let scale: MedicalScale
    
    var body: some View {
        // Um 'switch' para direcionar para a View correta baseada no nome da escala.
        switch scale.name {
        case "Glasgow":
            GlasgowScaleView()
        // Você pode adicionar `case` para as outras escalas aqui.
        default:
            // Uma view padrão para as escalas que ainda não foram implementadas.
            VStack(spacing: 16) {
                Image(systemName: "hammer.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                Text("Em Construção")
                    .font(.title)
                    .fontWeight(.bold)
                Text("O formulário para a escala de \(scale.name) estará disponível em breve.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
            }
            .navigationTitle(scale.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// Visualizador para o Xcode poder mostrar o design da ContentView.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

