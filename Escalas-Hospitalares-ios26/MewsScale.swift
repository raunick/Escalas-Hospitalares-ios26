import SwiftUI

// Formulário específico para a Escala MEWS
struct MewsScaleView: View {
    // @State armazena os valores selecionados pelo usuário
    @State private var pressaoArterial = 0
    @State private var frequenciaCardiaca = 0
    @State private var frequenciaRespiratoria = 0
    @State private var temperatura = 0
    @State private var nivelConsciencia = 0
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para cada categoria da escala
    let pressaoArterialOptions = [
        (0, "101-160 mmHg"),
        (1, "81-100 ou 161-180 mmHg"),
        (2, "71-80 ou 181-199 mmHg"),
        (3, "≤70 ou ≥200 mmHg")
    ]
    
    let frequenciaCardiacaOptions = [
        (0, "101-110 bpm"),
        (1, "51-100 bpm"),
        (2, "41-50 ou 111-129 bpm"),
        (3, "≤40 ou ≥130 bpm")
    ]
    
    let frequenciaRespiratoriaOptions = [
        (0, "21-24 rpm"),
        (1, "15-20 rpm"),
        (2, "9-14 ou 21-24 rpm"),
        (3, "≤8 ou ≥25 rpm")
    ]
    
    let temperaturaOptions = [
        (0, "36.1-37.9°C"),
        (1, "35.1-36.0 ou 38.0-38.4°C"),
        (2, "≤35.0 ou ≥38.5°C")
    ]
    
    let nivelConscienciaOptions = [
        (0, "A - Alert"),
        (1, "V - Voice"),
        (2, "P - Pain"),
        (3, "U - Unresponsive")
    ]

    // Calcula o score total em tempo real
    var totalScore: Int {
        pressaoArterial + frequenciaCardiaca + frequenciaRespiratoria + temperatura + nivelConsciencia
    }
    
    // Determina a interpretação baseada no score total
    var interpretation: (text: String, color: Color) {
        switch totalScore {
        case 0...2:
            return ("Baixo risco - frequência normal", .green)
        case 3...4:
            return ("Risco moderado - avaliar 4/4h", .orange)
        case 5...:
            return ("Alto risco - avaliação médica urgente", .red)
        default:
            return ("Pontuação inválida", .gray)
        }
    }

    var body: some View {
        // ZStack permite sobrepor a animação de "Salvo" sobre o formulário
        ZStack {
            Form {
                // Card de Resultado
                Section {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Pontuação Total")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(totalScore)")
                                    .font(.system(size: 48, weight: .bold))
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Interpretação")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(interpretation.text)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(interpretation.color)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(interpretation.color.opacity(0.1))
                                    .cornerRadius(200)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color(.systemGroupedBackground))

                // Seção para Pressão Arterial com Menu
                Section(header: Text("Pressão arterial sistólica")) {
                    mewsMenu(selection: $pressaoArterial, options: pressaoArterialOptions)
                }
                
                // Seção para Frequência Cardíaca com Menu
                Section(header: Text("Frequência cardíaca")) {
                    mewsMenu(selection: $frequenciaCardiaca, options: frequenciaCardiacaOptions)
                }
                
                // Seção para Frequência Respiratória com Menu
                Section(header: Text("Frequência respiratória")) {
                    mewsMenu(selection: $frequenciaRespiratoria, options: frequenciaRespiratoriaOptions)
                }
                
                // Seção para Temperatura com Menu
                Section(header: Text("Temperatura")) {
                    mewsMenu(selection: $temperatura, options: temperaturaOptions)
                }
                
                // Seção para Nível de Consciência com Menu
                Section(header: Text("Nível de consciência (AVPU)")) {
                    mewsMenu(selection: $nivelConsciencia, options: nivelConscienciaOptions)
                }
                
                // Informações sobre a escala
                Section(header: Text("Sobre a Escala MEWS")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Modified Early Warning Score - Identificação precoce de pacientes em risco de deterioração clínica.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("AVPU = Alert, Voice, Pain, Unresponsive")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Pontuação máxima: 15")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("rpm = respirações por minuto")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("bpm = batimentos por minuto")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                // Referência rápida
                Section(header: Text("Referência rápida - Pontos")) {
                    VStack(alignment: .leading, spacing: 4) {
                        referenceText("Pressão arterial:", pressaoArterialOptions)
                        referenceText("Frequência cardíaca:", frequenciaCardiacaOptions)
                        referenceText("Frequência respiratória:", frequenciaRespiratoriaOptions)
                        referenceText("Temperatura:", temperaturaOptions)
                        referenceText("Consciência:", nivelConscienciaOptions)
                    }
                }
            }
            
            // Overlay de confirmação que aparece quando isSaved é true
            if isSaved {
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    Text("Salvo!")
                        .font(.title2)
                        .bold()
                }
                .padding(30)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .transition(.opacity.combined(with: .scale))
                .shadow(radius: 10)
            }
        }
        .animation(.spring(), value: isSaved) // Anima a entrada e saída do overlay
        .navigationTitle("Escala MEWS")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Botão de Reset
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: resetScores) {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
            
            // Grupo de botões na barra inferior
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer() // Empurra o botão para a direita
                Button(action: saveResult) {
                    Label("Salvar", systemImage: "square.and.arrow.down")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    // Componente de Menu reutilizável
    @ViewBuilder
    private func mewsMenu(selection: Binding<Int>, options: [(Int, String)]) -> some View {
        Menu {
            ForEach(options, id: \.0) { option in
                Button(action: {
                    selection.wrappedValue = option.0
                }) {
                    Text("\(option.1) (\(option.0))")
                }
            }
        } label: {
            HStack {
                Text(selectedOptionText(for: selection.wrappedValue, from: options))
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(.accentColor)
            }
            .foregroundColor(Color(.label))
        }
    }
    
    // Componente para texto de referência
    @ViewBuilder
    private func referenceText(_ title: String, _ options: [(Int, String)]) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
            
            HStack {
                let sortedOptions = options.sorted(by: { $0.0 < $1.0 })
                ForEach(Array(sortedOptions.enumerated()), id: \.element.0) { index, option in
                    Text("\(option.0)")
                        .font(.caption)
                        .foregroundColor(.primary)
                    if index < sortedOptions.count - 1 {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Logic
    
    private func selectedOptionText(for value: Int, from options: [(Int, String)]) -> String {
        if let option = options.first(where: { $0.0 == value }) {
            return "\(option.1) (\(option.0))"
        }
        return "Selecione uma opção"
    }
    
    private func saveResult() {
        // Salva o resultado no Core Data
        CoreDataManager.shared.saveScaleResult(
            scaleName: "Escala MEWS",
            category: "adulto",
            description: "Modified Early Warning Score - Identificação precoce de pacientes em risco de deterioração clínica",
            score: Int16(totalScore),
            totalPoints: Int16(totalScore),
            interpretation: interpretation.text,
            parameters: "PA: \(pressaoArterial), FC: \(frequenciaCardiaca), FR: \(frequenciaRespiratoria), Temp: \(temperatura), Consciência: \(nivelConsciencia)"
        )

        // Ativa a animação
        isSaved = true

        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        pressaoArterial = 0
        frequenciaCardiaca = 0
        frequenciaRespiratoria = 0
        temperatura = 0
        nivelConsciencia = 0
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar
struct MewsScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MewsScaleView()
        }
    }
}