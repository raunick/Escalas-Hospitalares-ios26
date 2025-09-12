import SwiftUI

// Formulário específico para o Mini Exame do Estado Mental (MEEM)
struct MeemScaleView: View {
    // @State armazena os valores selecionados pelo usuário
    @State private var orientacaoTemporal = 5
    @State private var orientacaoEspacial = 5
    @State private var memoriaImediata = 3
    @State private var atencaoCalculo = 5
    @State private var evocacao = 3
    @State private var linguagem = 9
    @State private var escolaridade = 2 // 1: Analfabeto, 2: 1-4 anos, 3: 5-8 anos, 4: 9+ anos
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para escolaridade
    let escolaridadeOptions = [
        (1, "Analfabeto"),
        (2, "1-4 anos"),
        (3, "5-8 anos"),
        (4, "9+ anos")
    ]

    // Calcula o score total em tempo real
    var totalScore: Int {
        orientacaoTemporal + orientacaoEspacial + memoriaImediata + atencaoCalculo + evocacao + linguagem
    }
    
    // Determina a interpretação baseada no score total e escolaridade
    var interpretation: (text: String, color: Color) {
        let cutoff = getAdjustedCutoff()
        
        if totalScore >= cutoff + 2 {
            return ("Normal", .green)
        } else if totalScore >= cutoff - 1 {
            return ("Alteração leve", .orange)
        } else if totalScore >= cutoff - 6 {
            return ("Alteração moderada", .orange)
        } else {
            return ("Alteração grave", .red)
        }
    }
    
    // Retorna o cut-off ajustado por escolaridade
    private func getAdjustedCutoff() -> Int {
        switch escolaridade {
        case 1: // Analfabeto
            return 26 // 27 - 1
        case 2: // 1-4 anos
            return 27 // Padrão
        case 3: // 5-8 anos
            return 28 // 27 + 1
        case 4: // 9+ anos
            return 29 // 27 + 2
        default:
            return 27
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
                                Text("\(totalScore)/30")
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

                // Seção para Escolaridade
                Section(header: Text("Escolaridade (para ajuste de pontuação)")) {
                    Picker("Escolaridade", selection: $escolaridade) {
                        ForEach(escolaridadeOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.accentColor)
                }
                
                // Seção para Orientação Temporal
                Section(header: Text("Orientação temporal (5 pontos)")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Perguntas (1 ponto cada):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        meemStepper(value: $orientacaoTemporal, title: "Ano atual", max: 1)
                        meemStepper(value: $orientacaoTemporal, title: "Estação do ano", max: 1)
                        meemStepper(value: $orientacaoTemporal, title: "Mês atual", max: 1)
                        meemStepper(value: $orientacaoTemporal, title: "Data atual", max: 1)
                        meemStepper(value: $orientacaoTemporal, title: "Dia da semana", max: 1)
                        
                        Text("Total: \(orientacaoTemporal)/5")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Seção para Orientação Espacial
                Section(header: Text("Orientação espacial (5 pontos)")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Perguntas (1 ponto cada):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        meemStepper(value: $orientacaoEspacial, title: "País", max: 1)
                        meemStepper(value: $orientacaoEspacial, title: "Estado", max: 1)
                        meemStepper(value: $orientacaoEspacial, title: "Cidade", max: 1)
                        meemStepper(value: $orientacaoEspacial, title: "Local específico", max: 1)
                        meemStepper(value: $orientacaoEspacial, title: "Andar/local no prédio", max: 1)
                        
                        Text("Total: \(orientacaoEspacial)/5")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Seção para Memória Imediata
                Section(header: Text("Memória imediata (3 pontos)")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Repetir 3 palavras (1 ponto cada):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        meemStepper(value: $memoriaImediata, title: "Palavras corretas", max: 3)
                        
                        Text("Total: \(memoriaImediata)/3")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Seção para Atenção e Cálculo
                Section(header: Text("Atenção e cálculo (5 pontos)")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contar de 100 para trás de 7 em 7 (1 ponto cada):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        meemStepper(value: $atencaoCalculo, title: "Subtrações corretas", max: 5)
                        
                        Text("Total: \(atencaoCalculo)/5")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Seção para Evocação
                Section(header: Text("Evocação (3 pontos)")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Lembrar as 3 palavras iniciais (1 ponto cada):")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        meemStepper(value: $evocacao, title: "Palavras lembradas", max: 3)
                        
                        Text("Total: \(evocacao)/3")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Seção para Linguagem
                Section(header: Text("Linguagem (9 pontos)")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Itens avaliados:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        meemStepper(value: $linguagem, title: "Nomear 2 objetos (2 pontos)", max: 2)
                        meemStepper(value: $linguagem, title: "Repetir frase (1 ponto)", max: 1)
                        meemStepper(value: $linguagem, title: "Comando de 3 estágios (3 pontos)", max: 3)
                        meemStepper(value: $linguagem, title: "Ler e obedecer (1 ponto)", max: 1)
                        meemStepper(value: $linguagem, title: "Escrever frase (1 ponto)", max: 1)
                        meemStepper(value: $linguagem, title: "Copiar desenho (1 ponto)", max: 1)
                        
                        Text("Total: \(linguagem)/9")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Informações sobre a escala
                Section(header: Text("Sobre o MEEM")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mini Exame do Estado Mental - Avaliação cognitiva breve.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("Pontuação ajustada por escolaridade:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Cut-off base: 27 pontos")
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
        .navigationTitle("Mini Exame do Estado Mental")
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
    
    // Componente de stepper para controle de pontuação
    @ViewBuilder
    private func meemStepper(value: Binding<Int>, title: String, max: Int) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
            Spacer()
            Stepper(value: value, in: 0...max) {
                Text("\(value.wrappedValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 30, alignment: .trailing)
            }
        }
    }

    // MARK: - Logic
    
    private func saveResult() {
        // Lógica para salvar os dados viria aqui
        print("Resultado salvo - MEEM: Total \(totalScore)/30 - \(interpretation.text) (Escolaridade: \(escolaridadeOptions.first(where: { $0.0 == escolaridade })?.1 ?? ""))")
        
        // Ativa a animação
        isSaved = true
        
        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        orientacaoTemporal = 5
        orientacaoEspacial = 5
        memoriaImediata = 3
        atencaoCalculo = 5
        evocacao = 3
        linguagem = 9
        escolaridade = 2
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar
struct MeemScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MeemScaleView()
        }
    }
}