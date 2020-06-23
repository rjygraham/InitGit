function Initialize-Git {
    param(
        [Parameter(ParameterSetName = 'GitHub')]
        [ValidatePattern('^(?!-)(?!.*--)[A-Za-z0-9-]+(?<!-)/(?!-)(?!.*--)[A-Za-z0-9-]+(?<!-)$')]
        [string] $Repository,
        [Parameter(ParameterSetName = 'GitHub')]
        [ValidatePattern('^(?!-)(?!.*--)[A-Za-z0-9-]+(?<!-)$')]
        [string] $Branch,
        [string] $Pat,
        [Parameter(ParameterSetName = 'Local')]
        [string] $Path,
        [switch] $Commit
    )

    $CurrentPath = Get-Location
    Write-Debug "Current path: $CurrentPath"

    # Can't validate GitHub URL without actually downloading it.

    # Validate Path input.
    if ($Path -and !(Test-Path -Path $Path)) {
        Write-Error "$Path does not exist. Please provide the path to a valid directory."
        return
    }

    # Initialize Git repo in current location.
    (git init)

    if ($Path) {
        # Copy the contents of path to the location of the new repo.
        $Exclude = @(".git")
        Get-ChildItem $Path -Exclude $Exclude -Recurse | Copy-Item -Destination {Join-Path $CurrentPath $_.FullName.Substring($Path.length)}
    } 
    # Download GitHub repo branch to local folder
    else {
        $Uri = "https://api.github.com/repos/{0}/zipball/{1}" -f $Repository, $Branch
        Write-Debug "GitHub uri: $Uri"

        $Headers = @{}
        if ($Pat) {
            $Headers.Add("Authorization", "token $Pat")
        }
        
        $OutFile = Join-Path $CurrentPath "temp.zip"
        Write-Debug "Downloading repo to: $OutFile"
        try {
            Invoke-RestMethod -Uri $Uri -Headers $Headers -OutFile $OutFile
            if (-not ($IsLinux -or $IsOSX)) {
                Unblock-File $OutFile
            }

            # Unzip the file contents 
            Expand-Archive -Path $OutFile -DestinationPath $CurrentPath -Force

            $ArchivePath = Get-ChildItem -Directory -Filter "$($Repository.Replace('/', '-'))*"
            Write-Debug "Archived path: $ArchivePath"

            #Move files up one level since GitHub includes the repo name and commit hash as root folder.
            Get-ChildItem $ArchivePath -Recurse | Move-Item -Destination {Join-Path $CurrentPath $_.FullName.Substring($ArchivePath.FullName.length)}

            # Remove the temporary zip file and archive directory
            Remove-Item $OutFile -Force
            Remove-Item $ArchivePath -Force
        }
        catch {
            Write-Error "An error occurred while attempting to download the repository. If this is a private repo, please use the Pat parameter to pass in a token."
        }
        
    }

    # Commit the initialized repo if switch is present.
    if ($Commit.IsPresent) {
        (git add * && git commit -m "Initial commit.")
    }
}