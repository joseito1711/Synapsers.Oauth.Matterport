# PowerShell script to build and pack the Synapsers.Oauth.Matterport NuGet package

# Prompt for version
$version = Read-Host "Enter the version you want to build (e.g., 1.0.0)"

# Use the correct csproj file name
$csprojPath = "Synapsers.Oauth.Matterport.csproj"
if (!(Test-Path $csprojPath)) {
    Write-Host "ERROR: Could not find $csprojPath in the current directory." -ForegroundColor Red
    exit 1
}

# Update the version in the .csproj file
[xml]$csproj = Get-Content $csprojPath
$propertyGroups = $csproj.Project.PropertyGroup
$versionSet = $false
foreach ($pg in $propertyGroups) {
    if ($pg.Version) {
        $pg.Version = $version
        $versionSet = $true
        break
    }
}
if (-not $versionSet) {
    $newVersion = $csproj.CreateElement("Version")
    $newVersion.InnerText = $version
    if ($propertyGroups) {
        $propertyGroups[0].AppendChild($newVersion) | Out-Null
    } else {
        $newPG = $csproj.CreateElement("PropertyGroup")
        $newPG.AppendChild($newVersion) | Out-Null
        $csproj.Project.AppendChild($newPG) | Out-Null
    }
}
$csproj.Save($csprojPath)

# Define output directory
$nupkgOutput = "nupkg"
if (!(Test-Path $nupkgOutput)) {
    New-Item -ItemType Directory -Path $nupkgOutput | Out-Null
}

# Clean any existing packages for this version
Write-Host "Cleaning existing packages for version $version..."
Get-ChildItem -Path $nupkgOutput -Filter "Synapsers.Oauth.Matterport.$version.*" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue

# Clean the project
Write-Host "Cleaning project..."
dotnet clean $csprojPath -c Release

# Build the project
Write-Host "Building project with version $version..."
dotnet build $csprojPath -c Release

# Pack the project
Write-Host "Packing NuGet package version $version..."
dotnet pack $csprojPath -c Release --output $nupkgOutput

# Verify the package was created
$packagePath = Join-Path $nupkgOutput "Synapsers.Oauth.Matterport.$version.nupkg"
if (Test-Path $packagePath) {
    Write-Host "Success! Package created at: $packagePath" -ForegroundColor Green
} else {
    Write-Host "Failed to create package. Checking for build output..." -ForegroundColor Red
    $foundPackages = Get-ChildItem -Path "." -Recurse -Filter "Synapsers.Oauth.Matterport.$version.nupkg" -ErrorAction SilentlyContinue
    if ($foundPackages.Count -gt 0) {
        Write-Host "Found package(s) in other locations:" -ForegroundColor Yellow
        foreach ($pkg in $foundPackages) {
            Write-Host $pkg.FullName -ForegroundColor Yellow
            Copy-Item -Path $pkg.FullName -Destination $nupkgOutput -Force
            Write-Host "Copied to $nupkgOutput folder" -ForegroundColor Green
        }
    } else {
        Write-Host "No packages found for version $version anywhere in the project." -ForegroundColor Red
    }
}

# List all packages in the output directory
Write-Host "Contents of $nupkgOutput folder:"
Get-ChildItem -Path $nupkgOutput | ForEach-Object { Write-Host $_.Name }

# Git commit, tag, and push for the new release
Write-Host "Committing, tagging, and pushing release v$version to git..."
git add $csprojPath
if ($LASTEXITCODE -ne 0) { Write-Host "git add failed" -ForegroundColor Red; exit 1 }
git commit -m "Release v$version"
git tag v$version
git push
git push --tags
Write-Host "Git release and tag v$version created and pushed."
