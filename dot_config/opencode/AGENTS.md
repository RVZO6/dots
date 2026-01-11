# Agent Configurations

## System Guidelines
- **Temporary Files:** Always use `/tmp/` for creating any temporary files or directories. Agents have explicit permission to read and write in this location as per the project configuration.

## Research
- **Context7:** When doing research or needing documentation, consider the Context7 MCP server. It provides a handy way to fetch documentation and context about exactly what you need to do when you need it. 
- **Github MCP:** For more granular control, consider the Github MCP, which allows you to browse github repositories, among other things. Prefer it over `gh api`.
- **Exa:** Use the Exa MCP (`web_search_exa`, `get_code_context_exa`, etc.) for general web searches, real-time information, and finding code examples or documentation. It is the preferred tool for broad external research.

## Bash
- **Trash:** Prefer `trash` over `rm` when possible for the ability to undo actions.
