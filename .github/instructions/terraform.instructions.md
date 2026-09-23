---
applyTo: "**/*.tf"
---

# Terraform standards

- Organize infrastructure into reusable logical modules instead of placing all resources in a single configuration.
- Group modules around logical capabilities and lifecycle boundaries; do not automatically create one module per Azure resource.
- Keep the root `main.tf` focused primarily on orchestrating and composing modules.
- Keep Terraform provider requirements and provider configuration at the root level. Do not configure providers inside child modules.
- Expose module configuration through typed, documented variables.
- Expose useful module values through documented outputs so callers can compose modules without reaching into their internals.
- Avoid hard-coded environment-specific values. Supply values that vary by environment through root-module variables or environment-specific variable files.
- Use consistent resource naming derived from the application name and environment while respecting Azure naming constraints.
- Apply the standard tags `environment`, `application`, `owner`, and `managed_by` to every resource that supports tags.
- Do not store secrets, credentials, access keys, or other sensitive values directly in Terraform code. Use secure secret stores and identity-based access.
- Prefer secure defaults for Azure resources, including encryption, current TLS versions, least-privilege access, managed identities, and appropriate recovery protections.
- Disable unnecessary public access for Storage Accounts and other Azure resources. Use network restrictions or private connectivity when public access is not required.
- Preserve existing infrastructure behavior when refactoring. Use Terraform state migration mechanisms such as `moved` blocks when resource addresses change, and review plans for unintended replacement or deletion.
- Format and validate every Terraform change with `terraform fmt` and `terraform validate` before considering it complete.
