//
//  QuestionnaireOnboarding.swift
//  My_iOS_Library
//
//  Questionnaire/Survey style onboarding
//

import SwiftUI

// MARK: - Questionnaire Onboarding View

public struct QuestionnaireOnboardingView: View {
    @StateObject private var viewModel: QuestionnaireViewModel
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    private let title: String
    private let subtitle: String?
    private let accentColor: Color

    public init(
        title: String,
        subtitle: String? = nil,
        questions: [OnboardingQuestion],
        accentColor: Color = .blue,
        onComplete: @escaping ([String: Any]) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.accentColor = accentColor
        self._viewModel = StateObject(wrappedValue: QuestionnaireViewModel(
            questions: questions,
            onComplete: onComplete
        ))
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                // Background
                theme.backgroundPrimary
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Progress Bar
                    ProgressView(value: viewModel.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: accentColor))
                        .frame(height: 4)
                        .background(Color.secondary.opacity(0.2))

                    // Content
                    if viewModel.currentQuestionIndex < viewModel.questions.count {
                        QuestionView(
                            question: viewModel.questions[viewModel.currentQuestionIndex],
                            selectedOptions: viewModel.selectedOptions[viewModel.currentQuestionIndex] ?? [],
                            accentColor: accentColor,
                            onSelect: { option in
                                viewModel.selectOption(option)
                            }
                        )
                    }

                    Spacer()

                    // Bottom Controls
                    bottomControls
                        .padding()
                        .background(
                            theme.backgroundPrimary
                                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
                        )
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.canGoBack {
                        Button(action: {
                            viewModel.previousQuestion()
                        }) {
                            Image(systemName: "chevron.left")
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        viewModel.skipQuestionnaire()
                    }
                    .foregroundColor(theme.textSecondary)
                }
            }
        }
    }

    private var bottomControls: some View {
        VStack(spacing: 16) {
            // Continue Button
            Button(action: {
                viewModel.nextQuestion()
            }) {
                Text(viewModel.isLastQuestion ? "Complete" : "Continue")
                    .font(theme.typography.body1)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        viewModel.canContinue ? accentColor : Color.secondary.opacity(0.3)
                    )
                    .cornerRadius(12)
            }
            .disabled(!viewModel.canContinue)

            // Question Counter
            Text("\(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
                .font(theme.typography.label2)
                .foregroundColor(theme.textSecondary)
        }
    }
}

// MARK: - Question View

struct QuestionView: View {
    @Environment(\.theme) private var theme
    let question: OnboardingQuestion
    let selectedOptions: [QuestionOption]
    let accentColor: Color
    let onSelect: (QuestionOption) -> Void

    @State private var animateIn = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Question Text
                Text(question.question)
                    .font(theme.typography.heading2)
                    .foregroundColor(theme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.top, 32)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 20)

                // Options
                VStack(spacing: 12) {
                    ForEach(Array(question.options.enumerated()), id: \.element.id) { index, option in
                        OptionRow(
                            option: option,
                            isSelected: selectedOptions.contains { $0.id == option.id },
                            accentColor: accentColor,
                            allowsMultiple: question.allowsMultipleSelection,
                            onTap: {
                                onSelect(option)
                            }
                        )
                        .opacity(animateIn ? 1 : 0)
                        .offset(x: animateIn ? 0 : -20)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                                .delay(Double(index) * 0.1),
                            value: animateIn
                        )
                    }
                }
                .padding(.horizontal)

                if question.allowsMultipleSelection {
                    Text("Select all that apply")
                        .font(theme.typography.label2)
                        .foregroundColor(theme.textSecondary)
                        .padding(.horizontal)
                        .opacity(animateIn ? 0.7 : 0)
                }
            }
            .padding(.bottom, 100)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                animateIn = true
            }
        }
        .onChange(of: question.id) { _ in
            animateIn = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.5)) {
                    animateIn = true
                }
            }
        }
    }
}

// MARK: - Option Row

struct OptionRow: View {
    @Environment(\.theme) private var theme
    let option: QuestionOption
    let isSelected: Bool
    let accentColor: Color
    let allowsMultiple: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Selection Indicator
                ZStack {
                    if allowsMultiple {
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(
                                isSelected ? accentColor : Color.secondary.opacity(0.3),
                                lineWidth: 2
                            )
                            .frame(width: 24, height: 24)

                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.caption.bold())
                                .foregroundColor(accentColor)
                        }
                    } else {
                        Circle()
                            .strokeBorder(
                                isSelected ? accentColor : Color.secondary.opacity(0.3),
                                lineWidth: 2
                            )
                            .frame(width: 24, height: 24)

                        if isSelected {
                            Circle()
                                .fill(accentColor)
                                .frame(width: 12, height: 12)
                        }
                    }
                }

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        if let icon = option.icon {
                            Image(systemName: icon)
                                .font(.body)
                                .foregroundColor(isSelected ? accentColor : theme.textPrimary)
                        }

                        Text(option.title)
                            .font(theme.typography.body1)
                            .foregroundColor(theme.textPrimary)
                    }

                    if let subtitle = option.subtitle {
                        Text(subtitle)
                            .font(theme.typography.body2)
                            .foregroundColor(theme.textSecondary)
                    }
                }

                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? accentColor.opacity(0.1) : Color.secondary.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        isSelected ? accentColor : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Questionnaire ViewModel

@MainActor
class QuestionnaireViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var selectedOptions: [Int: [QuestionOption]] = [:]

    let questions: [OnboardingQuestion]
    private let onComplete: ([String: Any]) -> Void

    init(questions: [OnboardingQuestion], onComplete: @escaping ([String: Any]) -> Void) {
        self.questions = questions
        self.onComplete = onComplete
    }

    var progress: Double {
        guard questions.count > 0 else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(questions.count)
    }

    var canGoBack: Bool {
        currentQuestionIndex > 0
    }

    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }

    var canContinue: Bool {
        selectedOptions[currentQuestionIndex]?.isEmpty == false
    }

    func selectOption(_ option: QuestionOption) {
        let question = questions[currentQuestionIndex]
        var currentSelection = selectedOptions[currentQuestionIndex] ?? []

        if question.allowsMultipleSelection {
            if let index = currentSelection.firstIndex(where: { $0.id == option.id }) {
                currentSelection.remove(at: index)
            } else {
                currentSelection.append(option)
            }
        } else {
            currentSelection = [option]
        }

        selectedOptions[currentQuestionIndex] = currentSelection
    }

    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            withAnimation(.spring()) {
                currentQuestionIndex += 1
            }
        } else {
            completeQuestionnaire()
        }
    }

    func previousQuestion() {
        if currentQuestionIndex > 0 {
            withAnimation(.spring()) {
                currentQuestionIndex -= 1
            }
        }
    }

    func skipQuestionnaire() {
        completeQuestionnaire()
    }

    private func completeQuestionnaire() {
        // Collect responses
        var responses: [String: Any] = [:]

        for (index, options) in selectedOptions {
            let questionId = questions[index].question
            if questions[index].allowsMultipleSelection {
                responses[questionId] = options.map { $0.value }
            } else {
                responses[questionId] = options.first?.value
            }
        }

        // Save to OnboardingManager
        for (key, value) in responses {
            OnboardingManager.shared.saveResponse(key: key, value: value)
        }

        OnboardingManager.shared.markOnboardingCompleted(version: "1.0.0")
        onComplete(responses)
    }
}

// MARK: - Sample Questions

public extension OnboardingQuestion {
    static let sampleQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            question: "What brings you here today?",
            options: [
                QuestionOption(
                    title: "Personal Use",
                    subtitle: "Track my personal activities",
                    icon: "person.fill",
                    value: "personal"
                ),
                QuestionOption(
                    title: "Work & Professional",
                    subtitle: "Manage work projects and tasks",
                    icon: "briefcase.fill",
                    value: "professional"
                ),
                QuestionOption(
                    title: "Team Collaboration",
                    subtitle: "Coordinate with my team",
                    icon: "person.3.fill",
                    value: "team"
                ),
                QuestionOption(
                    title: "Just Exploring",
                    subtitle: "See what the app can do",
                    icon: "magnifyingglass",
                    value: "exploring"
                )
            ]
        ),
        OnboardingQuestion(
            question: "Which features interest you most?",
            options: [
                QuestionOption(
                    title: "Task Management",
                    icon: "checklist",
                    value: "tasks"
                ),
                QuestionOption(
                    title: "Calendar & Scheduling",
                    icon: "calendar",
                    value: "calendar"
                ),
                QuestionOption(
                    title: "Notes & Documentation",
                    icon: "doc.text",
                    value: "notes"
                ),
                QuestionOption(
                    title: "Analytics & Reports",
                    icon: "chart.bar",
                    value: "analytics"
                ),
                QuestionOption(
                    title: "Team Communication",
                    icon: "bubble.left.and.bubble.right",
                    value: "communication"
                )
            ],
            allowsMultipleSelection: true
        ),
        OnboardingQuestion(
            question: "How would you describe your experience level?",
            options: [
                QuestionOption(
                    title: "Beginner",
                    subtitle: "I'm new to productivity apps",
                    value: "beginner"
                ),
                QuestionOption(
                    title: "Intermediate",
                    subtitle: "I use similar apps regularly",
                    value: "intermediate"
                ),
                QuestionOption(
                    title: "Advanced",
                    subtitle: "I'm a power user",
                    value: "advanced"
                )
            ]
        ),
        OnboardingQuestion(
            question: "How can we personalize your experience?",
            options: [
                QuestionOption(
                    title: "Show me tips and tutorials",
                    icon: "lightbulb",
                    value: "tips"
                ),
                QuestionOption(
                    title: "Enable smart suggestions",
                    icon: "wand.and.stars",
                    value: "suggestions"
                ),
                QuestionOption(
                    title: "Set up integrations",
                    icon: "link",
                    value: "integrations"
                ),
                QuestionOption(
                    title: "Customize the interface",
                    icon: "paintbrush",
                    value: "customize"
                )
            ],
            allowsMultipleSelection: true
        )
    ]
}