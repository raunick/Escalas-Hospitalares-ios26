import SwiftUI

// Formulário específico para a Escala de Apgar
struct ApgarScaleView: View {
    // @State armazena os valores selecionados pelo usuário
    @State private var frequenciaCardiaca = 2
    @State private var respiracao = 2
    @State private var tonusMuscular = 2
    @State private var irritabilidadeReflexa = 2
    @State private var corPele = 2
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para cada parâmetro
    let frequenciaCardiacaOptions = [
        (0, "Ausente"),
        (1, "< 100 bpm"),
        (2, "> 100 bpm")
    ]
    
    let respiracaoOptions = [
        (0, "Ausente"),
        (1, "Choro fraco/irregular"),
        (2, "Choro forte")
    ]
    
    let tonusMuscularOptions = [
        (0, "Flácido"),
        (1, "Flexão de braços e pernas"),
        (2, "Ativo")
    ]
    
    let irritabilidadeReflexaOptions = [
        (0, "Sem resposta"),
        (1, "Careta"),
        (2, "Choro")
    ]
    
    let corPeleOptions = [
        (0, "Azul/pálido"),
        (1, "Extremidades azuladas"),
        (2, "Rosado")
    ]

    // Calcula o score total em tempo real
    var totalScore: Int {
        frequenciaCardiaca + respiracao + tonusMuscular + irritabilidadeReflexa + corPele
    }
    
    // Determina a interpretação baseada no score total
    var interpretation: (text: String, color: Color) {
        switch totalScore {
        case 8...10:
            return ("Ótimas condições", .green)
        case 4...7:
            return ("Moderada dificuldade", .orange)
        case 0...3:
            return ("Grave dificuldade", .red)
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
                                Text("\(totalScore)/10")
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

                // Seção para Frequência Cardíaca com Picker
                Section(header: Text("Frequência cardíaca")) {
                    Picker("Frequência cardíaca", selection: $frequenciaCardiaca) {
                        ForEach(frequenciaCardiacaOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Respiração com Picker
                Section(header: Text("Respiração")) {
                    Picker("Respiração", selection: $respiracao) {
                        ForEach(respiracaoOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Tônus Muscular com Picker
                Section(header: Text("Tônus muscular")) {
                    Picker("Tônus muscular", selection: $tonusMuscular) {
                        ForEach(tonusMuscularOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Irritabilidade Reflexa com Picker
                Section(header: Text("Irritabilidade reflexa")) {
                    Picker("Irritabilidade reflexa", selection: $irritabilidadeReflexa) {
                        ForEach(irritabilidadeReflexaOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Cor da Pele com Picker
                Section(header: Text("Cor da pele")) {
                    Picker("Cor da pele", selection: $corPele) {
                        ForEach(corPeleOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Informações sobre a escala
                Section(header: Text("Sobre a Escala de Apgar")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("A Escala de Apgar avalia a vitalidade do recém-nascido nos primeiros minutos de vida.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Avaliação realizada:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("• 1 minuto após o nascimento")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("• 5 minutos após o nascimento") 
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("• 10 minutos se pontuação < 7")
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
        .navigationTitle("Escala de Apgar")
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
    
    // MARK: - Logic
    
    private func saveResult() {
        // Lógica para salvar os dados viria aqui
        print("Resultado salvo - Apgar: FC(\(frequenciaCardiaca)), Resp(\(respiracao)), Tonus(\(tonusMuscular)), Reflexo(\(irritabilidadeReflexa)), Cor(\(corPele)) = Total \(totalScore)")
        
        // Ativa a animação
        isSaved = true
        
        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        frequenciaCardiaca = 2
        respiracao = 2
        tonusMuscular = 2
        irritabilidadeReflexa = 2
        corPele = 2
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar
struct ApgarScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ApgarScaleView()
        }
    }
}