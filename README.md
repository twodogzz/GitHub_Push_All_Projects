# GitHub_Push_All_Projects

I'll retrieve information about the GitHub Push All Projects repository to provide you with a summary of the script operations.Now let me get the main script files to understand the operations:## Summary: GitHub Push All Projects Script Operations

The **GitHub Push All Projects** repository contains an automated batch commit and push tool designed to safely manage multiple Git repositories across a local file system. Here's what the script does:

### **Core Functionality**

The PowerShell script (`GitHubPushAllProjects.ps1`) automates the process of committing and pushing changes across all Git repositories in a specified directory. It's a multi-repo management tool that handles the repetitive tasks of staging, committing, and pushing changes to multiple projects at once.

### **Key Operations**

1. **Repository Discovery**
   - Scans the base path (`E:\SoftwareProjects` by default) for all subdirectories
   - Identifies only directories that contain a `.git` folder (valid Git repositories)

2. **Change Detection**
   - Checks each repository for uncommitted changes using `git status --porcelain`
   - Skips repositories with no changes to save time
   - Reports the status of detected changes to the user

3. **Untracked File Handling**
   - Detects untracked files (not yet added to version control)
   - Prompts the user for confirmation before adding them
   - Allows selective inclusion of new files

4. **User-Guided Commit Process**
   - Requires confirmation before committing changes in each repository
   - Provides a menu for selecting commit types using Conventional Commits format:
     - `feat` - new feature
     - `fix` - bug fix
     - `refactor` - code cleanup
     - `docs` - documentation update
     - `chore` - maintenance
     - `other` - custom type
   - Accepts a custom commit message body from the user
   - Defaults to "update" if no message is provided

5. **Push Operations**
   - Attempts to push committed changes to the remote repository
   - Includes error handling for failed pushes
   - Reports success or failure with colored output

6. **Comprehensive Logging**
   - Maintains a timestamped log file (`PushAllProjects.log`) next to the script
   - Logs all operations including: repository checks, skips, commits, and push results
   - Useful for auditing and troubleshooting

### **User Interface**
- **Color-coded output**: Cyan for checks, Yellow for changes, Green for success, Red for errors
- **Interactive prompts**: User confirmation at key decision points
- **Exit handling**: Pauses before closing (unless running in PowerShell ISE)

### **Execution Methods**
- **Direct PowerShell**: Run the `.ps1` file directly
- **Batch file wrapper** (`GitHub_Push_All.bat`): Launches PowerShell with bypass execution policy
- **Windows shortcut** (`.lnk` file): Desktop launcher for convenience

### **Language Composition**
- 97.1% PowerShell
- 2.9% Batch file

This tool is ideal for developers managing multiple related projects who want to ensure all repositories are kept synchronized with consistent, properly-formatted commit messages.
