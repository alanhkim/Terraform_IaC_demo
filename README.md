# GitHub Copilot Terraform Refactoring Demo

This repository demonstrates how GitHub Copilot can analyze an existing Terraform implementation, apply repository-specific organizational standards, refactor the configuration into reusable modules, validate the result, and prepare a pull request summary.

The workflow is intentionally human-controlled: Copilot first analyzes and proposes an architecture, waits for approval, performs the refactor, and then validates its work with the standard Terraform toolchain.

## Demo Prerequisites

- VS Code with GitHub Copilot Chat
- GitHub Copilot Chat in Agent mode
- Terraform 1.6 or later available on `PATH`
- The repository opened at its root
- No Azure deployment is required

Before presenting, confirm that the starting repository contains the original single-file implementation and that [.github/instructions/terraform.instructions.md](.github/instructions/terraform.instructions.md) is available.

## 1. Introduce the Scenario

### Show

Open [main.tf](main.tf) and scroll through it briefly so the audience can see that multiple Azure resources are defined together.

### What This Showcases

- Copilot can begin with an existing, working Terraform implementation.
- A configuration that is manageable today may need a more maintainable structure as infrastructure, environments, and contributors grow.
- The workflow starts with understanding the current implementation rather than immediately changing it.

## 2. Show the Organizational Standards

### Show

Open [.github/instructions/terraform.instructions.md](.github/instructions/terraform.instructions.md) and highlight standards such as:

- Reusable logical modules
- Root-level orchestration
- Environment-specific variables instead of hard-coded values
- Standard tags
- Secure defaults
- Typed variables and useful outputs
- Preservation of existing behavior

### What This Showcases

- Repository instructions give Copilot durable organizational context.
- Teams do not need to repeat the same modularization, naming, tagging, security, and configuration requirements in every prompt.
- Copilot can use standards that are versioned alongside the code.

## 3. Analyze and Visualize the Before and After States

This is the first major Copilot interaction. Paste the following prompt into Copilot Chat.

### Prompt 1

```text
Review the existing Terraform implementation and compare it against the Terraform standards defined in .github/instructions/terraform.instructions.md.
Do not modify any files yet.
Before proposing any code changes, show me a clear BEFORE vs. AFTER view of the Terraform project hierarchy.
For BEFORE, show the current project structure and, underneath main.tf, show the major Azure resources currently defined there.
For AFTER, show the recommended project structure after refactoring, including the proposed modules/ hierarchy and which resources or logical capabilities would live within each module.
Format both views as easy-to-read directory trees:
BEFORE
└── ...
AFTER
└── ...
Then briefly explain:
	○ Why you recommend each module
	○ What becomes reusable
	○ What responsibilities remain at the root level
	○ Which organizational Terraform standards this refactoring would address
	○ Any security or configuration improvements you recommend
Do not implement the changes yet. Wait for my approval before refactoring anything.
```

### What This Showcases

- Copilot can inspect the repository and compare the implementation with local standards.
- A before-and-after hierarchy makes the architectural recommendation easy to review.
- Explicitly telling Copilot not to edit keeps the first interaction focused on analysis and preserves human approval as a gate.

## 4. Walk Through the Before View

Copilot should return a view similar to:

```text
BEFORE
Terraform_IaC_demo/
├── main.tf
│   ├── Resource Group
│   ├── App Service Plan
│   ├── Linux Web App
│   ├── Storage Account
│   ├── Key Vault
│   └── Application Insights
├── variables.tf
├── outputs.tf
├── providers.tf
└── terraform.tfvars.example
```

### What This Showcases

- Copilot identified the existing Azure resources and their current location.
- The hierarchy makes the concentration of infrastructure responsibilities in `main.tf` immediately visible.
- The goal is maintainability and reuse as the environment grows, not fixing Terraform that is inherently invalid.

## 5. Walk Through the After View

Copilot should propose a structure similar to:

```text
AFTER
Terraform_IaC_demo/
├── main.tf                   ← Module orchestration
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars.example
│
└── modules/
    ├── web-app/
    │   ├── main.tf           ← App Service Plan + Web App
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── storage/
    │   ├── main.tf           ← Storage Account
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── key-vault/
    │   ├── main.tf           ← Key Vault
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── monitoring/
        ├── main.tf           ← Application Insights
        ├── variables.tf
        └── outputs.tf
```

### What This Showcases

- Copilot organizes infrastructure into logical, reusable capabilities based on repository standards.
- Modules do not need to map one-to-one with Azure resources. For example, an App Service Plan and Web App can form one web application capability.
- No files have changed yet, leaving the presenter in control of the architectural decision.

## 6. Approve the Architecture and Refactor

After reviewing and accepting the proposed architecture, paste the following prompt.

### Prompt 2

```text
The proposed architecture looks good.
Proceed with the refactoring using the Terraform standards defined in this repository.
Requirements:
	○ Preserve the functionality of the existing infrastructure.
	○ Refactor the infrastructure into the proposed reusable logical modules.
	○ Move configurable values into module variables.
	○ Add appropriate module outputs.
	○ Apply our required tagging standards where supported.
	○ Remove unnecessary hard-coded values.
	○ Keep provider configuration at the root.
	○ Make the root main.tf primarily responsible for composing the modules.
	○ Preserve existing resource dependencies.
	○ Prefer secure defaults defined by our Terraform instructions.
	○ Do not deploy any Azure resources.
After completing the changes, show me the updated project hierarchy and summarize what changed.
```

### Show

Let Agent mode create and edit the files. In Explorer, watch the `modules/` directory appear, then expand the generated module files. Open the repository instruction file if Copilot reports that it used it.

### What This Showcases

- Human approval moves Copilot from analysis into action.
- Agent mode can create modules, move resource definitions, and update root composition across multiple files.
- Copilot applies the standards already defined in the repository instead of relying only on requirements repeated in the prompt.

## 7. Show the Actual Transformation

Expand `modules/` in Explorer. The repository should look roughly like:

```text
Terraform_IaC_demo/
│
├── .github/
│   └── instructions/
│       └── terraform.instructions.md
│
├── modules/
│   ├── web-app/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── storage/
│   ├── key-vault/
│   └── monitoring/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── providers.tf
```

Open the new root `main.tf`, then open a module implementation such as `modules/web-app/main.tf`.

### What This Showcases

- The approved architecture is now reflected in the repository.
- The root configuration primarily orchestrates modules rather than directly implementing every resource.
- Implementation details remain available, but now live in logical components that are easier to maintain and reuse.

## 8. Show the Applied Organizational Standards

Choose two or three concrete examples from the generated code rather than attempting to cover every change. Useful examples include:

- Typed variables such as `environment`
- Standard tags: `environment`, `application`, `owner`, and `managed_by`
- Removed hard-coded values
- Secure defaults required by the repository instructions
- Module outputs used by other modules or by the root configuration

### What This Showcases

- Modularization is only one outcome of repository-aware assistance.
- Copilot can consistently apply input, tagging, configuration, and security standards across the refactor.
- The standards remain inspectable and reviewable in both the instructions and generated Terraform.

## 9. Validate the Generated Terraform

Paste the following prompt after the refactor completes.

### Prompt 3

```text
Now validate the refactored Terraform.
Do not deploy any infrastructure.
Run the appropriate local validation steps:
	○ terraform fmt -recursive
	○ terraform init
	○ terraform validate
Also review the implementation for:
	○ Broken references
	○ Missing variables
	○ Missing outputs
	○ Incorrect module dependencies
	○ Provider configuration issues
	○ Hard-coded environment-specific values
	○ Violations of .github/instructions/terraform.instructions.md
If validation identifies an issue, explain the issue, fix it, and validate again.
At the end, give me a concise validation summary.
```

### What This Showcases

- AI-generated code still goes through normal engineering controls.
- Formatting, initialization, and validation test whether module references and dependencies are correct.
- When validation finds a problem, Copilot can use the error context in a realistic generate, validate, diagnose, fix, and revalidate loop.
- The workflow validates locally and never deploys Azure resources.

## 10. Generate a Pull Request Description

Once validation succeeds, paste the final prompt.

### Prompt 4

```text
Review the changes between the original Terraform implementation and the current refactored implementation.
Do not make additional code changes.
Generate a concise pull request description with:
Summary
What changed.
Architecture
What modules were introduced and their responsibilities.
Standards
How the implementation now aligns with our Terraform repository instructions.
Validation
What Terraform validation was performed and the result.
Reviewer Focus
What areas should receive human review before this infrastructure is deployed.
```

### What This Showcases

- Copilot retains the workflow context: the original implementation, architectural reasoning, resulting changes, and validation outcome.
- That context can be carried into the software development lifecycle as a structured pull request description.
- The output calls out areas that still require human review before deployment.

## Closing Summary

This demo follows a complete, controlled engineering workflow:

1. Copilot understands the existing implementation.
2. Repository instructions supply the organizational standards.
3. Copilot visualizes the current and proposed architectures before changing files.
4. A human reviews and approves the architecture.
5. Agent mode performs the refactor and applies the standards.
6. Terraform tooling validates the result without deploying infrastructure.
7. Copilot summarizes the work for reviewers.

The central message is not simply that Copilot can generate Terraform. It can participate in a standards-driven workflow while architectural approval, validation, and deployment decisions remain under human control.

