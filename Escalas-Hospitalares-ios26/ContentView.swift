import SwiftUI

// Enum para definir as categorias das escalas.
enum ScaleCategory: String, CaseIterable {
    case adulto = "Avaliações Adulto & Geral"
    case pediatria = "Avaliações Pediátricas"
}

// Estrutura para representar cada escala médica, agora com uma categoria e ícone.
struct MedicalScale: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let category: ScaleCategory
    let icon: String // SF Symbol name
}

// Onde definimos todas as escalas, agora com categoria e ícone.
struct ScalesData {
    static let allScales: [MedicalScale] = [
        // Adulto & Geral
        MedicalScale(name: "Glasgow", description: "Avaliação do nível de consciência", category: .adulto, icon: "brain.head.profile"),
        MedicalScale(name: "Morse", description: "Risco de queda em adultos", category: .adulto, icon: "figure.fall"),
        MedicalScale(name: "Braden", description: "Risco de lesão por pressão", category: .adulto, icon: "bed.double"),
        MedicalScale(name: "Ramsay", description: "Nível de sedação", category: .adulto, icon: "zzz"),
        MedicalScale(name: "MEWS", description: "Alerta de deterioração em adultos", category: .adulto, icon: "heart.text.square"),
        MedicalScale(name: "NEWS2", description: "Alerta nacional de deterioração", category: .adulto, icon: "waveform.path.ecg"),
        
        // Pediátricas
        MedicalScale(name: "Apgar", description: "Vitalidade do recém-nascido", category: .pediatria, icon: "figure.child"),
        MedicalScale(name: "Humpty Dumpty", description: "Risco de queda em pediatria", category: .pediatria, icon: "figure.child.and.lock"),
        MedicalScale(name: "PEWS", description: "Alerta de deterioração pediátrica", category: .pediatria, icon: "heart.circle")
    ]
}

// A tela principal (Home), agora com a lista dividida em seções.
struct ContentView: View {
    let escalas = ScalesData.allScales
    let categories = ScaleCategory.allCases // Pega todas as categorias do Enum.
    
    // Detecta o tema atual do sistema
    @Environment(\.colorScheme) private var colorScheme
    
    // Acessa a preferência de tema do usuário
    @AppStorage("isDarkMode") private var isDarkMode = false

    
    var body: some View {
        NavigationStack {
            List {
                // Loop para criar uma seção para cada categoria.
                ForEach(categories, id: \.self) { category in
                    Section(header: Text(category.rawValue)) {
                        // Filtra e lista apenas as escalas que pertencem à categoria atual.
                        ForEach(escalas.filter { $0.category == category }) { escala in
                            NavigationLink(destination: ScaleDetailView(scale: escala)) {
                                HStack(spacing: 12) {
                                    // Ícone da escala
                                    Image(systemName: escala.icon)
                                        .font(.title2)
                                        .foregroundColor(.accentColor)
                                        .frame(width: 28, height: 28)
                                    
                                    // Conteúdo textual
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(escala.name)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                        Text(escala.description)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Escalas Médicas")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AboutView()) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.accentColor)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        NavigationLink(destination: HistoryView()) {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.accentColor)
                        }

                        Button(action: {
                            isDarkMode.toggle()
                        }) {
                            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// View que decide qual formulário de escala mostrar.
struct ScaleDetailView: View {
    let scale: MedicalScale

    // Detecta o tema atual do sistema
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Group {
            // Um 'switch' para direcionar para a View correta baseada no nome da escala.
            switch scale.name {
            case "Glasgow":
                GlasgowScaleView()
            case "Morse":
                MorseScaleView()
            case "Ramsay":
                RamsayScaleView()
            case "Apgar":
                ApgarScaleView()
            case "Braden":
                BradenScaleView()
            case "Humpty Dumpty":
                HumptyDumptyScaleView()
            case "PEWS":
                PewsScaleView()
            case "MEWS":
                MewsScaleView()
            case "NEWS2":
                News2ScaleView()
            // Você pode adicionar `case` para as outras escalas aqui.
            default:
                // Uma view padrão para as escalas que ainda não foram implementadas.
                VStack(spacing: 16) {
                    Image(systemName: "hammer.fill")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("Em Construção")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("O formulário para a escala de \(scale.name) estará disponível em breve.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                }
                .navigationTitle(scale.name)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationTitle(scale.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Visualizador para o Xcode poder mostrar o design da ContentView.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
