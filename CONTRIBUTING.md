# Contributing to Ubuntu Development Setup

Thank you for your interest in contributing to this project! We welcome contributions from the community.

## How to Contribute

### Reporting Issues

If you encounter any problems or have suggestions for improvements:

1. Check if the issue already exists in the [Issues](https://github.com/LexiconAngelus93/ubuntu-dev-setup/issues) section
2. If not, create a new issue with:
   - Clear description of the problem
   - Steps to reproduce (if applicable)
   - Your Ubuntu version and system information
   - Expected vs actual behavior

### Suggesting Enhancements

We welcome suggestions for new packages, tools, or improvements:

1. Open an issue with the "enhancement" label
2. Describe the proposed addition or change
3. Explain why it would be valuable for developers
4. Provide any relevant links or documentation

### Pull Requests

1. Fork the repository
2. Create a new branch for your feature: `git checkout -b feature-name`
3. Make your changes
4. Test the script on a clean Ubuntu installation
5. Update documentation if needed
6. Commit your changes with clear commit messages
7. Push to your fork and submit a pull request

### Guidelines

#### Code Style
- Use consistent bash scripting style
- Add comments for complex sections
- Group related packages together
- Maintain alphabetical order within groups when possible

#### Testing
- Test on Ubuntu 20.04 LTS and 22.04 LTS minimum
- Ensure the script runs without errors
- Verify that added packages install correctly
- Check that services start properly if applicable

#### Documentation
- Update README.md if adding new categories or significant features
- Update CHANGELOG.md with your changes
- Include usage examples for new tools when relevant

### Package Addition Guidelines

When adding new packages:

1. **Verify the package is useful for development**
   - Should be commonly used by developers
   - Should have active maintenance
   - Should be available in official repositories when possible

2. **Choose the right installation method**
   - Prefer `apt` for system packages
   - Use `pip3` for Python packages
   - Use `npm` for Node.js packages
   - Use `cargo` for Rust tools
   - Use `snap` or `flatpak` for desktop applications

3. **Consider dependencies**
   - Ensure dependencies are already included
   - Add dependencies if they're not already present
   - Group related packages together

4. **Update documentation**
   - Add the package to the appropriate section in README.md
   - Include a brief description of what it does
   - Update the package count if significant

### Categories for New Packages

- **Development Tools**: Compilers, debuggers, build tools
- **Programming Languages**: Runtimes, interpreters, language-specific tools
- **Databases**: Database servers, clients, management tools
- **Web Development**: Frameworks, servers, testing tools
- **DevOps**: Container tools, cloud CLIs, infrastructure tools
- **Data Science**: Analysis tools, visualization, ML libraries
- **System Tools**: Monitoring, networking, file management
- **Media Tools**: Graphics, video, audio processing
- **Communication**: Chat, email, collaboration tools
- **Productivity**: Office suites, note-taking, organization

### Commit Message Format

Use clear, descriptive commit messages:

```
Add: Brief description of what was added
Update: Brief description of what was updated
Fix: Brief description of what was fixed
Remove: Brief description of what was removed
```

Examples:
- `Add: TensorFlow and PyTorch for machine learning`
- `Update: Node.js packages to include latest tools`
- `Fix: Docker group permission setup`
- `Remove: Deprecated package xyz`

### Review Process

1. All pull requests will be reviewed by maintainers
2. We may request changes or ask questions
3. Once approved, your contribution will be merged
4. You'll be credited in the contributors section

### Getting Help

If you need help with contributing:

1. Check existing issues and pull requests
2. Open a discussion issue
3. Reach out to maintainers

## Code of Conduct

Please be respectful and constructive in all interactions. We want this to be a welcoming community for developers of all backgrounds and experience levels.

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions
- Special thanks for major improvements

Thank you for helping make this project better for the developer community!

