import SwiftUI

// Formulário específico para a Escala de Ramsay
struct RamsayScaleView: View {
    // @State armazena o valor selecionado pelo usuário
    @State private var nivelSedacao = 2
    
    // Controla a visibilidade da animação de "salvo"
    @State private var isSaved: Bool = false

    // Opções para os níveis de sedação
    let sedacaoOptions = [
        (1, "Ansioso, agitado, inquieto"),
        (2, "Cooperativo, orientado, tranquilo"),
        (3, "Responsivo somente a comandos"),
        (4, "Resposta rápida a estímulo glabelar ou sonoro alto"),
        (5, "Resposta lenta a estímulo glabelar ou sonoro alto"),
        (6, "Sem resposta")
    ]

    // Determina a interpretação baseada no nível de sedação
    var interpretation: (text: String, color: Color) {
        switch nivelSedacao {
        case 1:
            return ("Insuficientemente sedado", .red)
        case 2, 3:
            return ("Adequadamente sedado (alvo)", .green)
        case 4, 5, 6:
            return ("Supersedado", .orange)
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
                                Text("Nível de Sedação")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(nivelSedacao)")
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

                // Seção para Nível de Sedação com Picker
                Section(header: Text("Nível de sedação observado")) {
                    Picker("Nível de sedação", selection: $nivelSedacao) {
                        ForEach(sedacaoOptions, id: \.0) { option in
                            Text("\(option.0) - \(option.1)").tag(option.0)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                // Informações adicionais
                Section(header: Text("Referência rápida")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Níveis de Sedação:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        ForEach(sedacaoOptions, id: \.0) { option in
                            HStack {
                                Text("\(option.0):")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(width: 20, alignment: .leading)
                                Text(option.1)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                        }
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
        .navigationTitle("Escala de Ramsay")
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
        print("Resultado salvo - Ramsay: Nível \(nivelSedacao) - \(interpretation.text)")
        
        // Ativa a animação
        isSaved = true
        
        // Esconde a animação após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSaved = false
        }
    }
    
    func resetScores() {
        nivelSedacao = 2
        isSaved = false
    }
}

// Para visualizar corretamente a Navigation e a Toolbar
struct RamsayScaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RamsayScaleView()
        }
    }
}