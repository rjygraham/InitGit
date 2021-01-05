# InitGit

InitGit enables initializing a new Git repository with default files and folder structure based on an existing local folder structure or GitHub repository.

For example, nearly every Git repo will have the following files:

- .editorconfig
- .gitignore
- LICENSE
- README.md

With InitGit, just create a local folder (or GitHub repo) with templated versions of these files and any folder structure you'd like and provide InitGit the path and it'll handle pulling the files in.

## Installation

InitGit can be installed from the PowerShell Gallery:

`Install-Module -Name InitGit -AllowPrerelease`

Alternatively, you can clone or download the zip of this repo and then run: `Import-Module "<Path to folder containing InitGit.psd1>"`

For example:

`Import-Module "C:\Users\username\source\repos\GitHub\InitGit\InitGit"`

## Usage

Once the module has been installed/imported, change directories to the folder in which you'd like to initialize the new Git repo and run one of the commands below based on your scenario.

InitGit will do the following:

- Execute `git init`
- Copy the files from the specified template path into the root of your new git repo
- Optionally execute `git add * && git commit -m "Initial commit."` 

### Local Folder

`Initialize-Git -Path "Path to local folder"`

### Public GitHub Repo

`Initialize-Git -Repository "rjygraham/InitGitTemplate" -Branch "dotnet"`

### Private GitHub Repo

`Initialize-Git -Repository "rjygraham/InitGitTemplate" -Branch "dotnet" -Pat "d62468cf6e414817a4ba1d1a07212554..."`

### Auto-commit

To auto-commit, just add the `-Commit` switch to any of the above commands.

## License

The MIT License (MIT)

Copyright © 2020-2021 Ryan Graham

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.