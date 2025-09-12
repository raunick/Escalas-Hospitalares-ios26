# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI iOS application called "Escalas-Hospitalares-ios26" that provides medical assessment scales for healthcare professionals. The app displays various medical scales organized by category and allows users to calculate scores and get interpretations.

## Development Commands

Since Xcode command line tools are not available, development work should be done through the Xcode IDE:

- **Build and Run**: Use Xcode to build and run the application
- **Target Platform**: iOS 26.0+ (also supports macOS and visionOS)
- **Swift Version**: 6.0

## Architecture Overview

### Core Components

1. **App Structure**: SwiftUI-based app with a single window group
   - `Escalas_Hospitalares_ios26App.swift:11` - Main app entry point
   - `ContentView.swift:37` - Main view with scale list organized by categories

2. **Data Models**:
   - `ScaleCategory` enum - Defines two categories: "adulto" and "pediatria"
   - `MedicalScale` struct - Represents individual scales with name, description, and category
   - `ScalesData` - Static data source containing all medical scales

3. **Navigation Architecture**:
   - Uses `NavigationStack` with programmatic navigation
   - `ScaleDetailView` acts as a router to switch between different scale implementations

4. **Scale Implementations**:
   - `GlasgowScaleView` - Glasgow Coma Scale assessment (GlasgowScale.swift:4)
   - `MorseScaleView` - Fall risk assessment (referenced but missing file)
   - Other scales show "Em Construção" placeholder

### Scale Categories and Available Scales

**Adulto & Geral**:
- Glasgow (implemented) - Consciousness level assessment
- Morse (missing file) - Fall risk in adults  
- Braden - Pressure injury risk
- Ramsay - Sedation level
- MEEM - Mini Mental State Examination
- MEWS - Early warning score for adults
- NEWS2 - National early warning score

**Pediatria**:
- Apgar - Newborn vitality
- Humpty Dumpty - Pediatric fall risk
- PEWS - Pediatric early warning score

### UI Patterns

- **Consistent Layout**: All scale views use `Form` with `Section` headers
- **Score Display**: Prominent score display with color-coded interpretation
- **Input Controls**: Menu-based selection with dropdown options
- **Actions**: Save button with animation feedback and reset functionality
- **Result Cards**: Visual score cards with total points and interpretation

### State Management

- Uses `@State` properties for form inputs
- Computed properties for real-time score calculation and interpretation
- Local state for UI feedback (save animations)

## Code Style

- Brazilian Portuguese comments and UI text
- SwiftUI declarative syntax
- MARK comments for code organization
- Consistent spacing and padding
- Color-coded interpretations (green/orange/red)
- Menu-based selection controls with dropdown options
- Animation effects for user feedback

## Implementation Notes

- Each scale view follows a similar pattern: state variables, computed properties, form layout, and action handlers
- Views include `PreviewProvider` for Xcode canvas preview
- Navigation uses `navigationDestination` with data passing
- Placeholder views for unimplemented scales use consistent "under construction" design
- Glasgow scale includes save animation overlay and toolbar integration
- Menu components are reusable with custom `@ViewBuilder` functions

## Missing Files

- `MorseScale.swift` - Referenced in project but file is missing
- Additional scale implementations show "Em Construção" placeholder