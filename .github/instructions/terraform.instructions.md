---
applyTo: "**/*.tf"
---

# Terraform standards

- Organize infrastructure into reusable logical modules instead of placing all resources in a single configuration.
- Group modules around logical capabilities and lifecycle boundaries; do not automatically create one module per Azure resource.
- Keep the root `main.tf` focused primarily on orchestrating and composing modules.
- Keep provider configurations in the root module. Each child module must declare its own `required_providers` entries, including provider source addresses and compatible minimum versions, but must not contain `provider` blocks.
- Expose module configuration through typed, documented variables.
- Expose useful module values through documented outputs so callers can compose modules without reaching into their internals.
- Avoid hard-coded environment-specific values. Supply values that vary by environment through root-module variables or environment-specific variable files.
- Use `<application>-<environment>-<resource-type>` as the default resource-name pattern. Add a caller-supplied uniqueness suffix only where Azure requires a globally unique name, and normalize separators, length, and character set only as required by the target resource type.
- Apply the standard tags `environment`, `application`, `owner`, and `managed_by` to every resource that supports tags. Source `environment`, `application`, and `owner` from root-module variables, and set `managed_by` to `terraform`.
- Do not store secrets, credentials, access keys, or other sensitive values directly in Terraform code. Use secure secret stores and identity-based access.
- Prefer secure defaults for Azure resources: require TLS 1.2 or later, use encryption, grant least-privilege access, and use managed identities where supported. Enable Key Vault soft delete and purge protection; for Storage Accounts containing persistent data, enable blob and container soft delete and blob versioning. Expose retention periods as validated variables.
- Disable unnecessary public access for Storage Accounts and other Azure resources. Use network restrictions or private connectivity when public access is not required.
- Preserve existing infrastructure behavior when refactoring. Use Terraform state migration mechanisms such as `moved` blocks when resource addresses change, and review plans for unintended replacement or deletion.
- Format and validate every Terraform change with `terraform fmt` and `terraform validate` before considering it complete.
