# Standard Operating Procedure: FlutterFlow Marketplace Template Integration

**Version:** 1.0  
**Effective Date:** October 20, 2025  
**Owner:** Scrum Master / Backend Developer  
**Review Cycle:** Quarterly

---

## Purpose

This SOP establishes the process for safely integrating FlutterFlow marketplace templates into our production project by using our sandbox environment to extract and sanitize template code.

## Scope

This procedure applies to all team members who need to incorporate UI components or widgets from FlutterFlow marketplace templates into our production project.

## Background

FlutterFlow marketplace templates often contain unnecessary code, dependencies, and configurations that aren't suitable for direct import into production. This SOP ensures we extract only the clean widget structures we need while maintaining code quality and project integrity.

---

## Roles and Responsibilities

### Scrum Master (Backend Developer)
- Review all backend implications of template integrations
- Approve final imports into production
- Maintain sandbox project health

### Frontend Developers
- Execute template imports in sandbox
- Extract and clean widget code
- Document any dependencies identified

### All Team Members
- Follow this procedure for any marketplace template usage
- Report issues or improvements to this process

---

## Procedure

### Phase 1: Template Selection and Planning

1. **Identify the needed component** from FlutterFlow marketplace
2. **Create a story/task** in your project management tool including:
   - Link to the marketplace template
   - Specific widgets/components needed
   - Target location in production project
3. **Review in sprint planning** to ensure team alignment

### Phase 2: Sandbox Import

4. **Access the sandbox project** (ensure you have appropriate permissions)
5. **Import the marketplace template** into sandbox:
   - Navigate to FlutterFlow sandbox project
   - Use the import/template feature
   - Complete the import process
6. **Document the import** in the task:
   - Template name and version
   - Import date
   - Any immediate warnings or errors

### Phase 3: Code Extraction and Cleanup

7. **Identify target widgets** within the imported template
8. **Review widget structure** for:
   - Unnecessary API calls or backend connections
   - External dependencies
   - Template-specific configurations
   - Hardcoded values that need parameterization
9. **Extract bare widget code:**
   - Copy only the widget tree structure
   - Remove all business logic
   - Remove all API integrations
   - Remove template-specific state management
10. **Document dependencies** identified during extraction:
    - Required packages
    - Asset requirements
    - Custom widget dependencies

### Phase 4: Backend Review (Required)

11. **Notify Scrum Master** for backend review if:
    - Widget requires any backend integration
    - New dependencies are needed
    - Database schema changes are implied
12. **Wait for approval** before proceeding to production import

### Phase 5: Production Integration

13. **Create a feature branch** in production project
14. **Paste cleaned widget code** into appropriate location
15. **Integrate with existing code:**
    - Connect to production state management
    - Wire up production API calls
    - Apply production styling/theming
    - Add proper error handling
16. **Test thoroughly:**
    - Widget renders correctly
    - No console errors
    - Responsive behavior works
    - Integrates properly with app flow

### Phase 6: Code Review and Deployment

17. **Create pull request** with:
    - Clear description of what was added
    - Reference to original task/story
    - Screenshots/recordings of new component
    - Note of any new dependencies added
18. **Request code review** from at least one team member
19. **Address review feedback**
20. **Merge after approval** and backend sign-off

---

## Best Practices

- **Never import templates directly into production** - always use sandbox first
- **Keep sandbox clean** - periodically remove old template experiments
- **Start small** - extract single widgets rather than entire page templates when possible
- **Maintain consistency** - ensure extracted widgets match our design system
- **Document learnings** - if a template is particularly useful or problematic, share with team

---

## Common Pitfalls to Avoid

- Importing template backend logic or API configurations
- Carrying over template-specific state management
- Including unused dependencies
- Copying authentication or security-related code
- Importing without testing in sandbox first

---

## Tools and Resources

- **Sandbox Project:** [Insert FlutterFlow sandbox project link]
- **Production Project:** [Insert FlutterFlow production project link]
- **Project Management:** [Insert tool/board link]
- **Design System:** [Insert design documentation link]

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | October 20, 2025 | Scrum Master | Initial SOP creation |

---

## Team Acknowledgment

By adding your name below and committing this file to GitHub, you confirm that you have read, understood, and agree to follow this SOP.

**Acknowledged by:**
- [Liam McKenzie] - Scrum Master / Backend Developer - [10/20/2025]
- 
- 
- 
- 

---

**Questions or Suggestions?**  
Contact the Scrum Master or raise concerns during retrospectives.




Questions or Suggestions?
Contact the Scrum Master or raise concerns during retrospectives.
