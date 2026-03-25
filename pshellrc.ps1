<#
.SYNOPSIS
Copy a Unity project to a new project directory, optionally keeping Materials, Prefabs, and Scenes.

.DESCRIPTION
Copies a set of Unity project files and folders from an existing project to a new project root,
renaming the solution (.slnx) to match the new project name. Optionally preserves Materials,
Prefabs, and Scenes when -Keep is specified.

.PARAMETER Source
The existing Unity project to copy.

.PARAMETER Destination
The (non-existing) Unity project directory to create.

.PARAMETER Keep
Also keep existing Assets/Materials, Assets/Prefabs, and Scenes.

.EXAMPLE
Copy-UnityProject -Source .\OldProject -Destination NewProject

.EXAMPLE
Copy-UnityProject .\OldProject NewProject

.EXAMPLE
Copy-UnityProject -Source .\OldProject -Destination NewProject -Keep

.EXAMPLE
Copy-UnityProject .\OldProject NewProject -Keep
#>
function Copy-UnityProject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Source,

        [Parameter(Mandatory=$true, Position=1)]
        [string] $Destination,

        [switch] $Keep
    )

    # Validate source
    if (-not (Test-Path -Path $Source -PathType Container)) {
        Write-Host "Project: $Source does not exist" -ForegroundColor Red
        return 1
    }

    # Validate dest does not exist
    if (Test-Path -Path $Destination) {
        Write-Host "Project: $Destination already exists" -ForegroundColor Red
        return 1
    }

    $existingProject = (Resolve-Path -Path $Source).ProviderPath
    $newProject = Join-Path -Path $PWD -ChildPath $Destination

    # Find .slnx file(s) at top-level of source
    $slnxFiles = Get-ChildItem -Path $existingProject -Filter '*.slnx' -File -ErrorAction SilentlyContinue
    if ($slnxFiles.Count -ne 1) {
        Write-Host "Solution file: $Source contains more than 1 .slnx file" -ForegroundColor Red
        return 1
    }

    # Base set of items to copy
    $toCopy = @(
        "Assets/InputSystem_Actions.inputactions"
        "Assets/InputSystem_Actions.inputactions.meta"
        "Assets/Settings"
        "Assets/Settings.meta"
        "Packages"
        "ProjectSettings"
        ".editorconfig"
        ".gitignore"
        ".vscode"
    )

    if ($Keep) {
        $toCopy += "Assets/Materials", "Assets/Prefabs", "Assets/Scenes"
    }

    # Prepend project path
    $toCopy = $toCopy | ForEach-Object { Join-Path -Path $existingProject -ChildPath $_ }

    # Find longest path for padding (for display)
    $longest = ($toCopy | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
    if (-not $longest) { $longest = -1 }

    # Copy items
    foreach ($path in $toCopy) {
        if (-not (Test-Path -Path $path)) {
            Write-Host "Path: $path does not exist" -ForegroundColor Yellow
            continue
        }

        Push-Location -Path $existingProject
        $relPath = Resolve-Path $path -Relative
        Pop-Location
        $newPath = Join-Path -Path $newProject -ChildPath $relPath

        if (Test-Path -Path $path -PathType Container) {
            $copyStr = "Copying_directory"
        } else {
            # Make sure directory structure exists, too
            New-Item -ItemType Directory -Path (Split-Path -Path $newPath -Parent) -Force | Out-Null
            $copyStr = "Copying_file"
        }

        Write-Host ("{0,-18} {1,-$longest} {2}" -f $copyStr, $path, $newPath)
        Copy-Item -Path $path -Destination $newPath -Recurse -Force
    }

    # Copy/rename solution file to new project name (place in new project root)
    # New-Item -ItemType Directory -Path $newProject -Force | Out-Null
    $newSolutionName = (Split-Path -Path $newProject -Leaf) + ".slnx"
    $sourceSlnxPath = $slnxFiles[0].FullName
    $destSlnxPath = Join-Path -Path $newProject -ChildPath $newSolutionName
    Copy-Item -Path $sourceSlnxPath -Destination $destSlnxPath -Force

    # Ensure some directories exist
    $toMkdir = @(
        "Assets/Materials"
        "Assets/Scenes"
        "Assets/Scripts"
    )

    foreach ($rel in $toMkdir) {
        $full = Join-Path -Path $newProject -ChildPath $rel
        if (Test-Path -Path $full -PathType Container) {
            Write-Host ("{0,-18} {1}" -f "Directory_exists", $full)
        } else {
            Write-Host ("{0,-18} {1}" -f "Creating_directory", $full)
            New-Item -ItemType Directory -Path $full -Force | Out-Null
        }
    }

    return 0
}