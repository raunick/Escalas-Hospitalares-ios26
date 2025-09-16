import SwiftUI

// Formulário específico para a Escala de Glasgow.
struct GlasgowScaleView: View {
    // @State armazena os valores selecionados pelo usuário.
    @State private var aberturaOcular = 4
    @State private var respostaVerbal = 5
    @State private var respostaMotora = 6
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para cada categoria da escala
    let ocularOptions = [
        (4, "Espontânea"), (3, "Ao comando verbal"), (2, "À dor"), (1, "Ausente")
    ]
    let verbalOptions = [
        (5, "Orientado e conversando"), (4, "Desorientado e conversando"), (3, "Palavras inadequadas"), (2, "Sons incompreensíveis"), (1, "Ausente")
    ]
    let motorOptions = [
        (6, "Obedece a comandos"), (5, "Localiza a dor"), (4, "Retirada normal"), (3, "Retirada anormal (flexão)"), (2, "Extensão anormal"), (1, "Ausente")
    ]

    // Calcula o score total em tempo real.
    var totalScore: Int {
        aberturaOcular + respostaVerbal + respostaMotora
    }
    
    // Determina a interpretação baseada no score total.
    var interpretation: (text: String, color: Color) {
        switch totalScore {
        case 13...15:
            return ("Traumatismo leve", .green)
        case 9...12:
            return ("Traumatismo moderado", .orange)
        case 3...8:
            return ("Traumatismo grave", .red)
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

                // Seção para Abertura Ocular com Menu
                Section(header: Text("Abertura Ocular")) {
                    glasgowMenu(selection: $aberturaOcular, options: ocularOptions)
                }
                
                // Seção para Resposta Verbal com Menu
                Section(header: Text("Resposta Verbal")) {
                    glasgowMenu(selection: $respostaVerbal, options: verbalOptions)
                }
                
                // Seção para Resposta Motora com Menu
                Section(header: Text("Resposta Motora")) {
                    glasgowMenu(selection: $respostaMotora, options: motorOptions)
                }
            }
            
            // NOVO: Overlay de confirmação que aparece quando isSaved é true
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
        .animation(.spring(), value: isSaved) // NOVO: Anima a entrada e saída do overlay
        .navigationTitle("Escala de Glasgow")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Botão de Reset (já existente)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: resetScores) {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
            
            // NOVO: Grupo de botões na barra inferior
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
    private func glasgowMenu(selection: Binding<Int>, options: [(Int, String)]) -> some View {
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
        let parameters = "Olho(\(aberturaOcular)), Verbal(\(respostaVerbal)), Motor(\(respostaMotora))"

        CoreDataManager.shared.saveScaleResult(
            scaleName: "Glasgow",
            category: "adulto",
            description: "Avaliação do nível de consciência",
            score: Int16(totalScore),
            totalPoints: Int16(totalScore),
            interpretation: interpretation.text,
            parameters: parameters
        )

        print("Resultado salvo: \(parameters) = Total \(totalScore)")

        // Ativa a animação
        isSaved = true

        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        aberturaOcular = 4
        respostaVerbal = 5
        respostaMotora = 6
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar, é bom envolver em uma NavigationStack
struct GlasgowScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Ou NavigationStack
            GlasgowScaleView()
        }
    }
}