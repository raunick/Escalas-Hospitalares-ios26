//
//  HistoryView.swift
//  Escalas-Hospitalares-ios26
//
//  Created by Raunick Vileforte Vieira Generoso on 15/09/25.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var results: [ScaleResult] = []
    @State private var showingDeleteAllAlert = false

    // Detecta o tema atual do sistema
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            List {
                if results.isEmpty {
                    Section {
                        VStack(spacing: 16) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            Text("Nenhum resultado salvo")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Os resultados das escalas salvas aparecerão aqui.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 40)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color(.systemGroupedBackground))
                } else {
                    ForEach(results, id: \.id) { result in
                        NavigationLink(destination: ResultDetailView(result: result)) {
                            HistoryRowView(result: result)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Excluir", role: .destructive) {
                                deleteResult(result)
                            }
                        }
                    }
                    .onDelete(perform: deleteResults)
                }
            }
            .onAppear {
                loadResults()
            }
            .navigationTitle("Histórico")
            .toolbar {
                if !results.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Apagar Tudo") {
                            showingDeleteAllAlert = true
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert("Apagar Todos os Registros?", isPresented: $showingDeleteAllAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Apagar", role: .destructive) {
                    deleteAllResults()
                }
            } message: {
                Text("Esta ação não pode ser desfeita. Todos os resultados salvos serão permanentemente excluídos.")
            }
        }
    }

    private func deleteResult(_ result: ScaleResult) {
        withAnimation {
            CoreDataManager.shared.deleteResult(result)
            loadResults() // Refresh the list
        }
    }

    private func deleteResults(at offsets: IndexSet) {
        for index in offsets {
            let result = results[index]
            CoreDataManager.shared.deleteResult(result)
        }
        loadResults() // Refresh the list
    }

    private func loadResults() {
        results = CoreDataManager.shared.fetchAllResults()
    }

    private func deleteAllResults() {
        withAnimation {
            CoreDataManager.shared.deleteAllResults()
            loadResults() // Refresh the list
        }
    }
}

struct HistoryRowView: View {
    let result: ScaleResult

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(result.scaleName ?? "Desconhecido")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)

                Spacer()

                Text(result.totalPoints > 0 ? "\(result.totalPoints) pts" : "\(result.score) pts")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.accentColor)
                    .cornerRadius(8)
            }

            HStack {
                Text(result.descriptionText ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text(result.date ?? Date(), style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let interpretation = result.interpretation, !interpretation.isEmpty {
                Text(interpretation)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ResultDetailView: View {
    let result: ScaleResult

    // Detecta o tema atual do sistema
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Form {
            Section(header: Text("Informações Gerais")) {
                HStack {
                    Text("Escala")
                    Spacer()
                    Text(result.scaleName ?? "Desconhecido")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Categoria")
                    Spacer()
                    Text(result.category ?? "Não informada")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Descrição")
                    Spacer()
                    Text(result.descriptionText ?? "Não informada")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Data")
                    Spacer()
                    Text(result.date ?? Date(), style: .date)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Hora")
                    Spacer()
                    Text(result.date ?? Date(), style: .time)
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Resultado")) {
                HStack {
                    Text("Pontuação")
                    Spacer()
                    Text("\(result.totalPoints > 0 ? result.totalPoints : result.score) pontos")
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                }

                if let interpretation = result.interpretation, !interpretation.isEmpty {
                    HStack {
                        Text("Interpretação")
                        Spacer()
                        Text(interpretation)
                            .foregroundColor(.secondary)
                    }
                }
            }

            if let parameters = result.parameters, !parameters.isEmpty {
                Section(header: Text("Parâmetros")) {
                    Text(parameters)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Detalhes do Resultado")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environment(\.managedObjectContext, CoreDataManager.shared.context)
    }
}