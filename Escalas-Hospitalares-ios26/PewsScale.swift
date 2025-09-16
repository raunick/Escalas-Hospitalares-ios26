import SwiftUI

// Formulário específico para a Escala PEWS
struct PewsScaleView: View {
    // @State armazena os valores selecionados pelo usuário
    @State private var comportamento = 0
    @State private var cardiovascular = 0
    @State private var respiratorio = 0
    @State private var usoNebulizacao = 0
    @State private var vomitoPosOperatorio = 0
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para cada categoria da escala
    let comportamentoOptions = [
        (0, "Brincando/apropriado"),
        (1, "Brincando/apropriado, consolável ou adormecido"),
        (2, "Irritável, consolável, comportamento inadequado"),
        (3, "Letárgico/confuso, redução da resposta à dor")
    ]
    
    let cardiovascularOptions = [
        (0, "Frequência cardíaca normal, CEC 1-2 seg, PA normal"),
        (1, "Taquicardia até 10 acima do normal"),
        (2, "Taquicardia até 20 acima do normal, CEC 3 seg"),
        (3, "Taquicardia >20 acima do normal, CEC >3 seg, PA reduzida")
    ]
    
    let respiratorioOptions = [
        (0, "Frequência respiratória normal, SatO2 >95%"),
        (1, "Taquipneia até 10 acima do normal"),
        (2, "Taquipneia >10 acima do normal, uso de O2, SatO2 <95%"),
        (3, "Taquipneia >20 acima do normal, retrações, esforço, FiO2 >50%")
    ]
    
    let usoNebulizacaoOptions = [
        (0, "Não usa nebulização"),
        (1, "Nebulização intermitente (até 3x por turno)"),
        (2, "Nebulização contínua ou >1x por turno")
    ]
    
    let vomitoPosOperatorioOptions = [
        (0, "Sem vômito ou não relacionado à cirurgia"),
        (1, "Vômito persistente pós-cirurgia")
    ]

    // Calcula o score total em tempo real
    var totalScore: Int {
        comportamento + cardiovascular + respiratorio + usoNebulizacao + vomitoPosOperatorio
    }
    
    // Determina a interpretação baseada no score total
    var interpretation: (text: String, color: Color) {
        switch totalScore {
        case 0...2:
            return ("Baixo risco - continuar cuidados de rotina", .green)
        case 3...4:
            return ("Risco intermediário - aumentar frequência de avaliação", .orange)
        case 5...:
            return ("Alto risco - considerar transferência para UTI", .red)
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

                // Seção para Comportamento com Menu
                Section(header: Text("Comportamento")) {
                    pewsMenu(selection: $comportamento, options: comportamentoOptions)
                }
                
                // Seção para Cardiovascular com Menu
                Section(header: Text("Cardiovascular")) {
                    pewsMenu(selection: $cardiovascular, options: cardiovascularOptions)
                }
                
                // Seção para Respiratório com Menu
                Section(header: Text("Respiratório")) {
                    pewsMenu(selection: $respiratorio, options: respiratorioOptions)
                }
                
                // Seção para Uso de Nebulização com Menu
                Section(header: Text("Uso de nebulização")) {
                    pewsMenu(selection: $usoNebulizacao, options: usoNebulizacaoOptions)
                }
                
                // Seção para Vômito Pós-operatório com Picker
                Section(header: Text("Vômito persistente pós-operatório")) {
                    Picker("Vômito pós-operatório", selection: $vomitoPosOperatorio) {
                        ForEach(vomitoPosOperatorioOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Informações sobre a escala
                Section(header: Text("Sobre a Escala PEWS")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pediatric Early Warning Score - Identificação precoce de deterioração clínica em pacientes pediátricos.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("CEC = Tempo de enchimento capilar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("PA = Pressão arterial")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("SatO2 = Saturação de oxigênio")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Pontuação máxima: 13")
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
        .navigationTitle("Escala PEWS")
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
    private func pewsMenu(selection: Binding<Int>, options: [(Int, String)]) -> some View {
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
            scaleName: "Escala PEWS",
            category: "pediatria",
            description: "Pediatric Early Warning Score - Identificação precoce de deterioração clínica em pacientes pediátricos",
            score: Int16(totalScore),
            totalPoints: Int16(totalScore),
            interpretation: interpretation.text,
            parameters: "Comportamento: \(comportamento), Cardiovascular: \(cardiovascular), Respiratório: \(respiratorio), Nebulização: \(usoNebulizacao), Vômito: \(vomitoPosOperatorio)"
        )

        // Ativa a animação
        isSaved = true

        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        comportamento = 0
        cardiovascular = 0
        respiratorio = 0
        usoNebulizacao = 0
        vomitoPosOperatorio = 0
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar
struct PewsScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PewsScaleView()
        }
    }
}