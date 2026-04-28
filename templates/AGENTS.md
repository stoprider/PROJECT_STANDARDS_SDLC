# AGENTS.md — Project Rules for AI Assistants

## RBAC / Permission Rules (MANDATORY)

1. **No permission hardcode in module code.**
   - Do not create `USER_ID_ROLE_FALLBACK`, `USERNAME_ROLE_FALLBACK`, or any object that maps specific users to roles outside `rbac-policy.json`.
   - The only allowed role fallback in UI code is `"employee"` (least privilege) when WRAuth is unavailable.

2. **Update rbac-policy.json first for any new menu or permission.**
   - New menu items → add to `menuAccess`
   - New permission keys → add to `permissions`
   - User-specific overrides → add to `userRoleOverrides`, `userMenuAllow`, `userMenuDeny`, or `userPermissionDeny`

3. **Backend routes must have auth middleware.**
   - Every POST/PUT/DELETE route must use `requireRole([...])`.
   - GET routes with sensitive data must use `authMiddleware` at minimum.

4. **UI permission checks use WRAuth API.**
   - `WRAuth.hasPermission(user, key)` for action permissions
   - `WRAuth.canAccessMenu(user, menuId)` for menu visibility
   - Fallback to conservative `PERMS` object only when WRAuth is not loaded

5. **Policy ref**: `docs/23_RBAC_SOT_ENFORCEMENT_POLICY.md`
   **PR checklist**: `docs/24_PERMISSION_CHANGE_CHECKLIST.md`
   **SOT file**: `apps/_shared/auth/rbac-policy.json`
