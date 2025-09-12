import SwiftUI

// Formulário específico para a Escala de Morse
struct MorseScaleView: View {
    // @State armazena os valores selecionados pelo usuário
    @State private var historiaQuedas = 0
    @State private var diagnosticoSecundario = 0
    @State private var auxilioDeambulacao = 0
    @State private var terapiaEndovenosa = 0
    @State private var marchaTransferencia = 0
    @State private var estadoMental = 0
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para cada categoria da escala
    let historiaQuedasOptions = [
        (0, "Não"), (25, "Sim")
    ]
    
    let diagnosticoSecundarioOptions = [
        (0, "Não"), (15, "Sim")
    ]
    
    let auxilioDeambulacaoOptions = [
        (0, "Nenhum"),
        (15, "Bengala/Muleta"),
        (30, "Apoio")
    ]
    
    let terapiaEndovenosaOptions = [
        (0, "Não"), (20, "Sim")
    ]
    
    let marchaTransferenciaOptions = [
        (0, "Normal"),
        (10, "Fraca"),
        (20, "Prejudicada")
    ]
    
    let estadoMentalOptions = [
        (0, "Orientado"),
        (15, "Desorientado")
    ]

    // Calcula o score total em tempo real
    var totalScore: Int {
        historiaQuedas + diagnosticoSecundario + auxilioDeambulacao + terapiaEndovenosa + marchaTransferencia + estadoMental
    }
    
    // Determina a interpretação baseada no score total
    var interpretation: (text: String, color: Color) {
        switch totalScore {
        case 0...24:
            return ("Baixo risco de queda", .green)
        case 25...50:
            return ("Risco moderado de queda", .orange)
        case 51...:
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

                // Seção para História de Quedas com Picker
                Section(header: Text("História de quedas")) {
                    Picker("História de quedas", selection: $historiaQuedas) {
                        ForEach(historiaQuedasOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Seção para Diagnóstico Secundário com Picker
                Section(header: Text("Diagnóstico secundário")) {
                    Picker("Diagnóstico secundário", selection: $diagnosticoSecundario) {
                        ForEach(diagnosticoSecundarioOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Seção para Auxílio na Deambulação com Menu
                Section(header: Text("Auxílio na deambulação")) {
                    morseMenu(selection: $auxilioDeambulacao, options: auxilioDeambulacaoOptions)
                }
                
                // Seção para Terapia Endovenosa com Picker
                Section(header: Text("Terapia endovenosa")) {
                    Picker("Terapia endovenosa", selection: $terapiaEndovenosa) {
                        ForEach(terapiaEndovenosaOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Marcha/Transferência com Menu
                Section(header: Text("Marcha/Transferência")) {
                    morseMenu(selection: $marchaTransferencia, options: marchaTransferenciaOptions)
                }
                
                // Seção para Estado Mental com Picker
                Section(header: Text("Estado mental")) {
                    Picker("Estado mental", selection: $estadoMental) {
                        ForEach(estadoMentalOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
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
        .navigationTitle("Escala de Morse")
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
    private func morseMenu(selection: Binding<Int>, options: [(Int, String)]) -> some View {
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
        print("Resultado salvo - Morse: História(\(historiaQuedas)), Diagnóstico(\(diagnosticoSecundario)), Auxílio(\(auxilioDeambulacao)), Terapia(\(terapiaEndovenosa)), Marcha(\(marchaTransferencia)), Mental(\(estadoMental)) = Total \(totalScore)")
        
        // Ativa a animação
        isSaved = true
        
        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        historiaQuedas = 0
        diagnosticoSecundario = 0
        auxilioDeambulacao = 0
        terapiaEndovenosa = 0
        marchaTransferencia = 0
        estadoMental = 0
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar
struct MorseScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MorseScaleView()
        }
    }
}
