# Claude Code Commands

This directory contains custom command templates for working with this Flutter City Guide project. These commands provide guidance to Claude Code (claude.ai/code) for common development workflows.

## Available Commands

### Development Workflow
- **`/tdd`** - Test-Driven Development guide for Flutter with BLoC patterns
- **`/plan`** - Implementation planning following Clean Architecture
- **`/code-review`** - Comprehensive code quality review checklist
- **`/build-fix`** - Systematic build error diagnosis and fixes
- **`/generate`** - Run code generation for routes and other generated files

### Feature Development
- **`/add-feature`** - Create new feature package with Clean Architecture structure
- **`/add-bloc`** - Create new BLoC following sealed class patterns
- **`/refactor-clean`** - Identify and remove dead code safely

### Testing
- **`/e2e`** - Generate end-to-end integration tests for user flows

## How to Use

These commands are markdown templates that provide step-by-step guidance. When working with Claude Code, reference these commands to follow project-specific workflows.

Example:
```
"Please add a new profile feature following /add-feature"
"Run code review following /code-review checklist"
"Help me implement TDD for this feature using /tdd"
```

## Command Structure

Each command file contains:
- **Purpose**: What the command helps accomplish
- **Workflow**: Step-by-step instructions
- **Code examples**: Templates following project patterns
- **Common issues**: Troubleshooting guidance
- **Best practices**: Project-specific conventions

## Customization

These commands are tailored specifically for this project:
- Flutter 3.38.7 with FVM
- Melos monorepo structure
- Clean Architecture with package-by-feature
- BLoC state management with sealed classes
- Type-safe routing with go_router_builder
- Strict linting rules from analysis_options.yaml

## Adding New Commands

To add a new command:
1. Create a new `.md` file in this directory
2. Follow the structure of existing commands
3. Include project-specific patterns and conventions
4. Add entry to this README
5. Reference in main CLAUDE.md if appropriate
