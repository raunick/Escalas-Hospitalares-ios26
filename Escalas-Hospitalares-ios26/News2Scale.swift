import SwiftUI

// Formulário específico para a Escala NEWS2
struct News2ScaleView: View {
    // @State armazena os valores selecionados pelo usuário
    @State private var frequenciaRespiratoria = 0
    @State private var saturacaoOxigenio = 0
    @State private var oxigenoterapia = 0
    @State private var pressaoArterial = 0
    @State private var frequenciaCardiaca = 0
    @State private var nivelConsciencia = 0
    @State private var temperatura = 0
    @State private var escalaOxigenio = 1 // 1: Normal, 2: DPOC
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para escala de oxigenação
    let escalaOxigenioOptions = [
        (1, "Escala 1 (maioria dos pacientes)"),
        (2, "Escala 2 (DPOC com retenção de CO2)")
    ]

    // Opções para frequência respiratória
    let frequenciaRespiratoriaOptions = [
        (0, "12-20 rpm"),
        (1, "9-11 rpm"),
        (2, "21-24 rpm"),
        (3, "≤8 ou ≥25 rpm")
    ]

    // Opções para saturação de oxigênio
    private var saturacaoOxigenioOptions: [(Int, String)] {
        if escalaOxigenio == 1 {
            // Escala 1 - maioria dos pacientes
            return [
                (0, "≥96%"),
                (1, "94-95%"),
                (2, "92-93%"),
                (3, "≤91%")
            ]
        } else {
            // Escala 2 - DPOC com retenção de CO2
            return [
                (0, "≥88%"),
                (1, "86-87%"),
                (2, "84-85%"),
                (3, "≤83%")
            ]
        }
    }
    
    let oxigenoterapiaOptions = [
        (0, "Ar ambiente"),
        (2, "Suplementação de O2")
    ]
    
    let pressaoArterialOptions = [
        (0, "111-219 mmHg"),
        (1, "101-110 mmHg"),
        (2, "91-100 mmHg"),
        (3, "≤90 ou ≥220 mmHg")
    ]
    
    let frequenciaCardiacaOptions = [
        (0, "51-90 bpm"),
        (1, "91-110 bpm"),
        (2, "41-50 ou 111-130 bpm"),
        (3, "≤40 ou ≥131 bpm")
    ]
    
    let nivelConscienciaOptions = [
        (0, "Alerta"),
        (3, "Confuso")
    ]
    
    let temperaturaOptions = [
        (0, "36.1-38.0°C"),
        (1, "36.1-38.0°C ou 38.1-39.0°C"),
        (2, "35.1-36.0°C ou ≥39.1°C"),
        (3, "≤35.0°C")
    ]

    // Calcula o score total em tempo real
    var totalScore: Int {
        frequenciaRespiratoria + saturacaoOxigenio + oxigenoterapia + pressaoArterial + frequenciaCardiaca + nivelConsciencia + temperatura
    }
    
    // Determina a interpretação baseada no score total
    var interpretation: (text: String, color: Color) {
        // Verifica se há pontuação 3 em qualquer parâmetro individual
        let hasScore3 = frequenciaRespiratoria == 3 || saturacaoOxigenio == 3 || pressaoArterial == 3 || frequenciaCardiaca == 3 || nivelConsciencia == 3 || temperatura == 3
        
        if hasScore3 {
            return ("Frequência 1/1h - considerar cuidados nível 2", .red)
        }
        
        switch totalScore {
        case 0:
            return ("Frequência mínima 12/12h", .green)
        case 1...4:
            return ("Frequência 4-6/6h", .orange)
        case 5...6:
            return ("Frequência 1/1h - considerar cuidados nível 2", .red)
        case 7...:
            return ("Contínua - emergência - cuidados nível 3", .red)
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

                // Seção para Escala de Oxigenação
                Section(header: Text("Escala de oxigenação")) {
                    Picker("Escala de oxigenação", selection: $escalaOxigenio) {
                        ForEach(escalaOxigenioOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Frequência Respiratória com Menu
                Section(header: Text("Frequência respiratória")) {
                    news2Menu(selection: $frequenciaRespiratoria, options: frequenciaRespiratoriaOptions)
                }
                
                // Seção para Saturação de Oxigênio com Menu
                Section(header: Text("Saturação de oxigênio \(escalaOxigenio == 1 ? "(Escala 1)" : "(Escala 2 - DPOC)")")) {
                    news2Menu(selection: $saturacaoOxigenio, options: saturacaoOxigenioOptions)
                }
                
                // Seção para Oxigenoterapia com Picker
                Section(header: Text("Oxigenoterapia")) {
                    Picker("Oxigenoterapia", selection: $oxigenoterapia) {
                        ForEach(oxigenoterapiaOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Pressão Arterial com Menu
                Section(header: Text("Pressão arterial sistólica")) {
                    news2Menu(selection: $pressaoArterial, options: pressaoArterialOptions)
                }
                
                // Seção para Frequência Cardíaca com Menu
                Section(header: Text("Frequência cardíaca")) {
                    news2Menu(selection: $frequenciaCardiaca, options: frequenciaCardiacaOptions)
                }
                
                // Seção para Nível de Consciência com Picker
                Section(header: Text("Nível de consciência")) {
                    Picker("Nível de consciência", selection: $nivelConsciencia) {
                        ForEach(nivelConscienciaOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Temperatura com Menu
                Section(header: Text("Temperatura")) {
                    news2Menu(selection: $temperatura, options: temperaturaOptions)
                }
                
                // Informações sobre a escala
                Section(header: Text("Sobre a Escala NEWS2")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("National Early Warning Score 2 - Sistema padronizado de detecção de deterioração clínica.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Escala 1: Para maioria dos pacientes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Escala 2: Para pacientes com DPOC e retenção de CO2")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Atenção: Pontuação 3 em qualquer parâmetro requer avaliação imediata")
                            .font(.caption)
                            .foregroundColor(.red)
                            .fontWeight(.medium)
                        
                        Text("Pontuação máxima: 20")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
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
        .navigationTitle("Escala NEWS2")
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
    private func news2Menu(selection: Binding<Int>, options: [(Int, String)]) -> some View {
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
            scaleName: "Escala NEWS2",
            category: "adulto",
            description: "National Early Warning Score 2 - Sistema padronizado de detecção de deterioração clínica",
            score: Int16(totalScore),
            totalPoints: Int16(totalScore),
            interpretation: interpretation.text,
            parameters: "FR: \(frequenciaRespiratoria), SatO2: \(saturacaoOxigenio), O2: \(oxigenoterapia), PA: \(pressaoArterial), FC: \(frequenciaCardiaca), Consciência: \(nivelConsciencia), Temp: \(temperatura), Escala O2: \(escalaOxigenio)"
        )

        // Ativa a animação
        isSaved = true

        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        frequenciaRespiratoria = 0
        saturacaoOxigenio = 0
        oxigenoterapia = 0
        pressaoArterial = 0
        frequenciaCardiaca = 0
        nivelConsciencia = 0
        temperatura = 0
        escalaOxigenio = 1
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar
struct News2ScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            News2ScaleView()
        }
    }
}