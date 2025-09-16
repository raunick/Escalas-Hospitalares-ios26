# Escalas Hospitalares (iOS)

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS%20%7C%20visionOS-blue.svg)
![iOS](https://img.shields.io/badge/iOS-16.0+-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

Um aplicativo SwiftUI abrangente que fornece 10 escalas de avaliação médica essenciais para profissionais de saúde. Calcule pontuações e obtenha interpretações baseadas em evidências em tempo real.

---

## 🌟 Visão Geral

O **Escalas Hospitalares** é uma ferramenta móvel projetada para auxiliar médicos, enfermeiros e estudantes da área da saúde no dia a dia clínico. O aplicativo oferece uma interface limpa e intuitiva para calcular rapidamente as pontuações de escalas médicas comuns, organizadas por categorias (Adulto/Geral e Pediatria).

## ✨ Funcionalidades Principais

- **10 Escalas Médicas:** Implementação completa das principais escalas clínicas.
- **Cálculo em Tempo Real:** As pontuações são atualizadas instantaneamente à medida que os parâmetros são alterados.
- **Interpretações Clínicas:** Orientações claras e codificadas por cores (verde, laranja, vermelho) para cada resultado.
- **Interface Profissional:** Layout consistente e otimizado para uso clínico.
- **Modo Claro e Escuro:** Suporte completo a temas para melhor visualização em qualquer ambiente.
- **Funcionalidade de Reset:** Limpe facilmente todos os campos para iniciar uma nova avaliação.
- **Conteúdo Educacional:** Informações de referência e guias rápidos para cada escala.

## 🩺 Escalas Disponíveis

O aplicativo inclui 10 escalas, divididas em duas categorias principais:

### Adulto & Geral (7 escalas)
- ✅ **Glasgow:** Avaliação do nível de consciência.
- ✅ **Morse:** Risco de queda em adultos.
- ✅ **Braden:** Risco de lesão por pressão.
- ✅ **Ramsay:** Nível de sedação.
- ✅ **MEEM:** Mini Exame do Estado Mental (com ajuste de escolaridade).
- ✅ **MEWS:** Escore de Alerta Precoce Modificado.
- ✅ **NEWS2:** Escore Nacional de Alerta Precoce 2 (com lógica para DPOC).

### Pediatria (3 escalas)
- ✅ **Apgar:** Vitalidade do recém-nascido.
- ✅ **Humpty Dumpty:** Risco de queda em pediatria.
- ✅ **PEWS:** Escore de Alerta Precoce Pediátrico.

## 🏗️ Arquitetura e Tecnologia

O aplicativo é construído com as tecnologias mais recentes do ecossistema Apple, garantindo performance e uma experiência de usuário fluida.

- **UI Framework:** SwiftUI
- **Linguagem:** Swift 6.0
- **Gerenciamento de Estado:** `@State`, `@StateObject`, e propriedades computadas para reatividade.
- **Persistência:** `@AppStorage` para salvar a preferência de tema do usuário.
- **Navegação:** `NavigationStack` para uma navegação programática e robusta.
- **Design Patterns:** Componentes reutilizáveis, layout consistente com `Form` e `Section`.

### Destaques Técnicos
- **Lógica Condicional Avançada:** Implementada em escalas como NEWS2 (escalas de oxigênio duplas) e MEEM (ajuste por escolaridade).
- **Controles de Entrada Otimizados:** Uso de `Picker`, `Menu` e `Stepper` para uma entrada de dados rápida e precisa.
- **Acessibilidade:** Suporte para VoiceOver e navegação aprimorada.

## 🚀 Como Executar o Projeto

Como as ferramentas de linha de comando do Xcode não são o foco, o desenvolvimento e a execução devem ser feitos através do Xcode IDE.

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/seu-usuario/Escalas-Hospitalares-ios26.git
    ```
2.  **Abra o projeto:**
    - Navegue até a pasta do projeto e abra o arquivo `.xcodeproj` ou `.xcworkspace` no Xcode.
3.  **Selecione o simulador ou dispositivo:**
    - Escolha um simulador de iPhone (iOS 16.0+) ou um dispositivo físico conectado.
4.  **Compile e Execute:**
    - Pressione o botão "Run" (▶) no Xcode ou use o atalho `Cmd + R`.

## 🎨 Modo Claro e Escuro

O aplicativo oferece uma experiência visual consistente com suporte total aos modos claro e escuro. A troca de tema é instantânea e pode ser feita através de um ícone na tela principal. A preferência do usuário é salva e mantida entre as sessões.

<!--
!Screenshot Light Mode
!Screenshot Dark Mode
-->

## 🔮 Futuras Melhorias

O aplicativo está completo em suas funcionalidades principais. Futuras versões poderão incluir:

- **Histórico de Avaliações:** Salvar e consultar cálculos anteriores.
- **Exportação de Resultados:** Gerar PDFs ou compartilhar os resultados.
- **Suporte a Múltiplos Idiomas:** Internacionalização do conteúdo.
- **Sincronização na Nuvem:** Backup dos dados via iCloud.

## ✍️ Autor

Este projeto foi desenvolvido como um portfólio de desenvolvimento iOS.

## 📄 Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo `LICENSE` para mais detalhes.