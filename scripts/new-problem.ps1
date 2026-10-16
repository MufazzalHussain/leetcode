<#
.SYNOPSIS
    Scaffold a problem folder, a method stub, and a skipped test.

.DESCRIPTION
    Creates LeetCode/problems/NNNN-slug from templates/PROBLEM_README.md, a Solution.cs
    stub under namespace LeetCode.Problems.PNNNN, and a mirrored skipped test
    in LeetCode.Tests. Appends a progress-table row in README.md.

.PARAMETER Number
    Problem number, from 1 to 9999. Stored as four digits (1 becomes 0001).

.PARAMETER Slug
    Lowercase URL slug, for example two-sum.

.EXAMPLE
    ./scripts/new-problem.ps1 -Number 15 -Slug 3sum

.EXAMPLE
    ./scripts/new-problem.ps1 20 valid-parentheses
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [int] $Number,

    [Parameter(Mandatory = $true, Position = 1)]
    [string] $Slug
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Number -lt 1 -or $Number -gt 9999) {
    throw "Number must be between 1 and 9999."
}

if (-not [regex]::IsMatch($Slug, '^[a-z0-9]+(?:-[a-z0-9]+)*$')) {
    throw "Slug must be lowercase words separated by hyphens, for example two-sum."
}

if ($Slug.Length -gt 80) {
    throw "Slug must be 80 characters or fewer."
}

function Get-TitleFromSlug {
    param([string] $Value)

    $roman = @{
        'i'    = 'I'
        'ii'   = 'II'
        'iii'  = 'III'
        'iv'   = 'IV'
        'v'    = 'V'
        'vi'   = 'VI'
        'vii'  = 'VII'
        'viii' = 'VIII'
        'ix'   = 'IX'
    }

    $words = @(foreach ($part in ($Value -split '-')) {
        if ([string]::IsNullOrEmpty($part)) {
            continue
        }

        if ($roman.ContainsKey($part)) {
            $roman[$part]
            continue
        }

        $capitalizeNext = $true
        $buffer = New-Object System.Text.StringBuilder
        foreach ($char in $part.ToCharArray()) {
            if ($capitalizeNext -and [char]::IsLetter($char)) {
                [void]$buffer.Append([char]::ToUpperInvariant($char))
                $capitalizeNext = $false
            }
            else {
                [void]$buffer.Append([char]::ToLowerInvariant($char))
                $capitalizeNext = -not [char]::IsLetter($char)
            }
        }

        $buffer.ToString()
    })

    return ($words -join ' ')
}

function Write-Utf8Text {
    param(
        [string] $Path,
        [string] $Content
    )

    if (-not $Content.EndsWith("`n")) {
        $Content += "`n"
    }

    $encoding = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$padded = '{0:D4}' -f $Number
$folderName = "$padded-$Slug"
$title = Get-TitleFromSlug -Value $Slug
$namespace = "LeetCode.Problems.P$padded"
$testNamespace = "LeetCode.Tests.Problems.P$padded"

$problemDir = Join-Path $repoRoot "LeetCode/problems/$folderName"
$testDir = Join-Path $repoRoot "LeetCode.Tests/problems/$folderName"
$templatePath = Join-Path $repoRoot 'templates/PROBLEM_README.md'
$readmePath = Join-Path $repoRoot 'README.md'

if (-not (Test-Path -LiteralPath $templatePath)) {
    throw "Missing template: $templatePath"
}

if (Test-Path -LiteralPath $problemDir) {
    throw "Problem folder already exists: $problemDir"
}

if (Test-Path -LiteralPath $testDir) {
    throw "Test folder already exists: $testDir"
}

$template = [System.IO.File]::ReadAllText($templatePath)
$problemReadme = $template.
    Replace('{{PADDED}}', $padded).
    Replace('{{NUMBER}}', "$Number").
    Replace('{{TITLE}}', $title).
    Replace('{{SLUG}}', $Slug)

if ($problemReadme -match '\{\{[A-Z0-9_]+\}\}') {
    throw "Template still contains unreplaced tokens."
}

$solution = @"
namespace $namespace;

public class Solution
{
    // Replace Solve with the problem's method signature.
    public void Solve()
    {
        throw new NotImplementedException();
    }
}
"@

$tests = @"
using $namespace;

namespace $testNamespace;

public class SolutionTests
{
    [Fact(Skip = "Not implemented yet")]
    public void Example()
    {
        var solution = new Solution();

        // Replace this with the sample cases once the method signature is in place.
        solution.Solve();
    }
}
"@

New-Item -ItemType Directory -Path $problemDir | Out-Null
New-Item -ItemType Directory -Path $testDir | Out-Null

Write-Utf8Text -Path (Join-Path $problemDir 'README.md') -Content $problemReadme
Write-Utf8Text -Path (Join-Path $problemDir 'Solution.cs') -Content $solution
Write-Utf8Text -Path (Join-Path $testDir 'SolutionTests.cs') -Content $tests

if (-not (Test-Path -LiteralPath $readmePath)) {
    Write-Warning "README.md was not found. Skipped the progress table."
}
else {
    $progress = [System.IO.File]::ReadAllText($readmePath)
    $marker = '<!-- progress:end -->'
    $row = "| $padded | $title |  |  | Not started | [LeetCode](https://leetcode.com/problems/$Slug/) |"

    $markerIndex = $progress.LastIndexOf($marker)
    $existingRow = "(?m)^\s*\|\s*$padded\s*\|"
    if ($markerIndex -lt 0) {
        Write-Warning "README.md has no <!-- progress:end --> marker. Skipped the progress table."
    }
    elseif ([regex]::IsMatch($progress, $existingRow)) {
        Write-Warning "Progress table already has $padded. Skipped the progress table."
    }
    else {
        $newline = if ($progress.Contains("`r`n")) { "`r`n" } else { "`n" }
        $updated = $progress.Substring(0, $markerIndex) + $row + $newline + $progress.Substring($markerIndex)
        Write-Utf8Text -Path $readmePath -Content $updated
    }
}

Write-Output "Created LeetCode/problems/$folderName"
Write-Output "Next: fill in the problem README, replace Solve with the real signature, add sample tests, then remove Skip."
Write-Output "Also set Difficulty, Pattern, and Status in the progress table, and add the problem to the patterns index."
