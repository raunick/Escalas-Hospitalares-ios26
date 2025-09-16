import SwiftUI

// Formulário específico para a Escala de Braden
struct BradenScaleView: View {
    // @State armazena os valores selecionados pelo usuário
    @State private var percepcaoSensorial = 4
    @State private var umidade = 4
    @State private var atividade = 4
    @State private var mobilidade = 4
    @State private var nutricao = 4
    @State private var friccaoCisalhamento = 3
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para cada categoria da escala
    let percepcaoSensorialOptions = [
        (1, "Completamente limitado"),
        (2, "Muito limitado"),
        (3, "Levemente limitado"),
        (4, "Nenhuma limitação")
    ]
    
    let umidadeOptions = [
        (1, "Constantemente úmida"),
        (2, "Frequentemente úmida"),
        (3, "Ocasionalmente úmida"),
        (4, "Raramente úmida")
    ]
    
    let atividadeOptions = [
        (1, "Acamado"),
        (2, "Confinado à cadeira"),
        (3, "Ocasionalmente caminha"),
        (4, "Caminha frequentemente")
    ]
    
    let mobilidadeOptions = [
        (1, "Completamente imóvel"),
        (2, "Muito limitado"),
        (3, "Levemente limitado"),
        (4, "Sem limitações")
    ]
    
    let nutricaoOptions = [
        (1, "Muito pobre"),
        (2, "Provavelmente inadequada"),
        (3, "Adequada"),
        (4, "Excelente")
    ]
    
    let friccaoCisalhamentoOptions = [
        (1, "Problema"),
        (2, "Problema em potencial"),
        (3, "Sem problema aparente")
    ]

    // Calcula o score total em tempo real
    var totalScore: Int {
        percepcaoSensorial + umidade + atividade + mobilidade + nutricao + friccaoCisalhamento
    }
    
    // Determina a interpretação baseada no score total
    var interpretation: (text: String, color: Color) {
        switch totalScore {
        case 19...:
            return ("Baixo risco", .green)
        case 15...18:
            return ("Risco moderado", .orange)
        case 13...14:
            return ("Alto risco", .red)
        case ...12:
            return ("Risco muito alto", .red)
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
                                Text("\(totalScore)/23")
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

                // Seção para Percepção Sensorial com Menu
                Section(header: Text("Percepção sensorial")) {
                    bradenMenu(selection: $percepcaoSensorial, options: percepcaoSensorialOptions)
                }
                
                // Seção para Umidade com Menu
                Section(header: Text("Umidade")) {
                    bradenMenu(selection: $umidade, options: umidadeOptions)
                }
                
                // Seção para Atividade com Menu
                Section(header: Text("Atividade")) {
                    bradenMenu(selection: $atividade, options: atividadeOptions)
                }
                
                // Seção para Mobilidade com Menu
                Section(header: Text("Mobilidade")) {
                    bradenMenu(selection: $mobilidade, options: mobilidadeOptions)
                }
                
                // Seção para Nutrição com Menu
                Section(header: Text("Nutrição")) {
                    bradenMenu(selection: $nutricao, options: nutricaoOptions)
                }
                
                // Seção para Fricção e Cisalhamento com Menu
                Section(header: Text("Fricção e cisalhamento")) {
                    bradenMenu(selection: $friccaoCisalhamento, options: friccaoCisalhamentoOptions)
                }
                
                // Informações sobre a escala
                Section(header: Text("Sobre a Escala de Braden")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("A Escala de Braden avalia o risco de desenvolver lesões por pressão.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Pontuação mínima: 6 (risco máximo)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Pontuação máxima: 23 (risco mínimo)")
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
        .navigationTitle("Escala de Braden")
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
    private func bradenMenu(selection: Binding<Int>, options: [(Int, String)]) -> some View {
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
        let parameters = "Percepção(\(percepcaoSensorial)), Umidade(\(umidade)), Atividade(\(atividade)), Mobilidade(\(mobilidade)), Nutrição(\(nutricao)), Fricção(\(friccaoCisalhamento))"

        CoreDataManager.shared.saveScaleResult(
            scaleName: "Braden",
            category: "adulto",
            description: "Risco de lesão por pressão",
            score: Int16(totalScore),
            totalPoints: Int16(totalScore),
            interpretation: interpretation.text,
            parameters: parameters
        )

        print("Resultado salvo - Braden: \(parameters) = Total \(totalScore)")

        // Ativa a animação
        isSaved = true

        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        percepcaoSensorial = 4
        umidade = 4
        atividade = 4
        mobilidade = 4
        nutricao = 4
        friccaoCisalhamento = 3
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar
struct BradenScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BradenScaleView()
        }
    }
}