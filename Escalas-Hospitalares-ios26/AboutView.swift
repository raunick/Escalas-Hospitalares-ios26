import SwiftUI

struct AboutView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Constants
    private enum Constants {
        static let iconSize: CGFloat = 80
        static let spacing: CGFloat = 24
        static let horizontalPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 12
        static let lineSpacing: CGFloat = 5
        static let appVersion = "1.0.0"
        static let developerName = "Raunick Vileforte"
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Constants.spacing) {
                appIconSection
                appInfoSection
                appDescriptionSection
                developerSection
                warningSection
                
                Spacer(minLength: 32)
            }
            .padding(.vertical, 32)
        }
        .navigationTitle("Sobre")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

// MARK: - View Components
private extension AboutView {
    
    var appIconSection: some View {
        Image(systemName: "stethoscope.fill")
            .font(.system(size: Constants.iconSize))
            .foregroundStyle(.tint)
            .accessibility(label: Text("Ícone do aplicativo Escalas Médicas"))
    }
    
    var appInfoSection: some View {
        VStack(spacing: 8) {
            Text("Escalas Médicas")
                .font(.largeTitle)
                .fontWeight(.light)
                .foregroundStyle(.primary)
            
            Text("Versão \(Constants.appVersion)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibility(label: Text("Escalas Médicas, Versão \(Constants.appVersion)"))
    }
    
    var appDescriptionSection: some View {
        Text("Este aplicativo foi desenvolvido para auxiliar profissionais e estudantes da área da saúde no cálculo rápido e preciso de escalas médicas comuns na prática clínica.")
            .font(.body)
            .lineSpacing(Constants.lineSpacing)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, Constants.horizontalPadding)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    var developerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Desenvolvido por:")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(Constants.developerName)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Constants.horizontalPadding)
        .accessibility(label: Text("Desenvolvido por \(Constants.developerName)"))
    }
    
    var warningSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            warningHeader
            warningText
        }
        .padding(Constants.horizontalPadding)
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal, Constants.horizontalPadding)
        .accessibility(label: Text("Aviso importante: Esta ferramenta é um suporte e não substitui o julgamento clínico profissional"))
    }
    
    var warningHeader: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
                .font(.title2)
                .accessibility(hidden: true)
            
            Text("Aviso Importante")
                .font(.headline)
                .foregroundStyle(.primary)
        }
    }
    
    var warningText: some View {
        Text("Esta ferramenta é um suporte e não substitui o julgamento clínico profissional. As decisões devem ser baseadas na avaliação completa do paciente.")
            .font(.body)
            .foregroundStyle(.secondary)
            .lineSpacing(Constants.lineSpacing)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Preview
#Preview("About View") {
    NavigationStack {
        AboutView()
    }
}

#Preview("About View - Dark Mode") {
    NavigationStack {
        AboutView()
    }
    .preferredColorScheme(.dark)
}
