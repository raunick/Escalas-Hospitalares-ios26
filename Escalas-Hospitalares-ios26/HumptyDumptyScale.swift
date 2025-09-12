import SwiftUI

// Formulário específico para a Escala Humpty Dumpty
struct HumptyDumptyScaleView: View {
    // @State armazena os valores selecionados pelo usuário
    @State private var idade = 2
    @State private var genero = 1
    @State private var diagnostico = 1
    @State private var comprometimentoCognitivo = 1
    @State private var fatoresAmbientais = 1
    @State private var respostaCirurgia = 1
    @State private var usoMedicamentos = 1
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para cada categoria da escala
    let idadeOptions = [
        (1, "≥ 13 anos"),
        (2, "7-12 anos"),
        (3, "3-6 anos"),
        (4, "< 3 anos")
    ]
    
    let generoOptions = [
        (1, "Feminino"),
        (2, "Masculino")
    ]
    
    let diagnosticoOptions = [
        (1, "Outros diagnósticos"),
        (2, "Distúrbios comportamentais"),
        (3, "Alterações na oxigenação"),
        (4, "Diagnóstico neurológico")
    ]
    
    let comprometimentoCognitivoOptions = [
        (1, "Completamente orientado"),
        (2, "Orientado à própria capacidade"),
        (3, "Esquece das limitações"),
        (4, "Não consciente das limitações")
    ]
    
    let fatoresAmbientaisOptions = [
        (1, "Área ambulatorial"),
        (2, "Área cuidados especiais"),
        (3, "Requer assistência/mobiliário"),
        (4, "História de quedas/risco")
    ]
    
    let respostaCirurgiaOptions = [
        (1, "Nenhuma cirurgia"),
        (2, "Nas últimas 48 horas"),
        (3, "Nas últimas 24 horas")
    ]
    
    let usoMedicamentosOptions = [
        (1, "Outros medicamentos"),
        (2, "Um medicamento de risco"),
        (3, "Múltiplos medicamentos")
    ]

    // Calcula o score total em tempo real
    var totalScore: Int {
        idade + genero + diagnostico + comprometimentoCognitivo + fatoresAmbientais + respostaCirurgia + usoMedicamentos
    }
    
    // Determina a interpretação baseada no score total
    var interpretation: (text: String, color: Color) {
        switch totalScore {
        case 7...11:
            return ("Baixo risco de queda", .green)
        case 12...:
            return ("Alto risco de queda", .red)
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

                // Seção para Idade com Menu
                Section(header: Text("Idade")) {
                    humptyMenu(selection: $idade, options: idadeOptions)
                }
                
                // Seção para Gênero com Picker
                Section(header: Text("Gênero")) {
                    Picker("Gênero", selection: $genero) {
                        ForEach(generoOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Diagnóstico com Menu
                Section(header: Text("Diagnóstico")) {
                    humptyMenu(selection: $diagnostico, options: diagnosticoOptions)
                }
                
                // Seção para Comprometimento Cognitivo com Menu
                Section(header: Text("Comprometimento cognitivo")) {
                    humptyMenu(selection: $comprometimentoCognitivo, options: comprometimentoCognitivoOptions)
                }
                
                // Seção para Fatores Ambientais com Menu
                Section(header: Text("Fatores ambientais")) {
                    humptyMenu(selection: $fatoresAmbientais, options: fatoresAmbientaisOptions)
                }
                
                // Seção para Resposta à Cirurgia com Menu
                Section(header: Text("Resposta à cirurgia/sedação/anestesia")) {
                    humptyMenu(selection: $respostaCirurgia, options: respostaCirurgiaOptions)
                }
                
                // Seção para Uso de Medicamentos com Menu
                Section(header: Text("Uso de medicamentos")) {
                    humptyMenu(selection: $usoMedicamentos, options: usoMedicamentosOptions)
                }
                
                // Informações sobre a escala
                Section(header: Text("Sobre a Escala Humpty Dumpty")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("A Escala Humpty Dumpty avalia o risco de queda em pacientes pediátricos.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Pontuação mínima: 7")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Pontuação máxima: 23")
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
        .navigationTitle("Escala Humpty Dumpty")
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
    private func humptyMenu(selection: Binding<Int>, options: [(Int, String)]) -> some View {
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
        // Lógica para salvar os dados viria aqui
        print("Resultado salvo - Humpty Dumpty: Idade(\(idade)), Gênero(\(genero)), Diagnóstico(\(diagnostico)), Cognitivo(\(comprometimentoCognitivo)), Ambiental(\(fatoresAmbientais)), Cirurgia(\(respostaCirurgia)), Medicamentos(\(usoMedicamentos)) = Total \(totalScore)")
        
        // Ativa a animação
        isSaved = true
        
        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        idade = 2
        genero = 1
        diagnostico = 1
        comprometimentoCognitivo = 1
        fatoresAmbientais = 1
        respostaCirurgia = 1
        usoMedicamentos = 1
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar
struct HumptyDumptyScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HumptyDumptyScaleView()
        }
    }
}