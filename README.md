# LeetCode

Personal practice and review for C# / .NET. Each problem gets a short note in my own words, a stub I fill in when I solve it, and tests for the sample cases. The goal is to practice, then come back later and see whether the approach still makes sense.

Problem notes link out to the original problem. They do not copy the statement.

## Structure

```text
LeetCode.sln
LeetCode/                          Class library (net8.0)
LeetCode.Tests/                    xUnit tests, mirrored per problem
  problems/NNNN-slug/SolutionTests.cs
problems/NNNN-slug/                One folder per problem
  Solution.cs                      namespace LeetCode.Problems.PNNNN
  README.md                        Notes from templates/PROBLEM_README.md
templates/PROBLEM_README.md
scripts/new-problem.ps1
.github/workflows/ci.yml           Build and test
```

`LeetCode` compiles every `*.cs` file under `problems/`. Tests stay in `LeetCode.Tests` so sample cases are not part of the library.

## Add a problem

From the repo root, in PowerShell:

```powershell
./scripts/new-problem.ps1 -Number 15 -Slug 3sum
```

`Number` is the problem number (`15` becomes folder `0015`). `Slug` is the lowercase URL slug (`3sum`). The script:

1. Creates `problems/0015-3sum/README.md` from `templates/PROBLEM_README.md`.
2. Creates `problems/0015-3sum/Solution.cs` with a `Solve` stub that throws `NotImplementedException`.
3. Creates `LeetCode.Tests/problems/0015-3sum/SolutionTests.cs` with a skipped test.
4. Appends a row to the progress table. Leave the HTML comments that surround that table in place.

Then:

1. Open the linked problem and write the notes yourself. Do not paste the statement.
2. Replace `Solve` with the real method signature and point the test at the sample cases.
3. Remove `Skip` once the solution is implemented.
4. Set Difficulty, Pattern, and Status in the progress table.
5. Add the problem under the matching pattern below.

Status values: `Not started`, `In progress`, `Solved`, `Review`.

Check the work with:

```powershell
dotnet build
dotnet test
```

Unimplemented problems stay skipped, so the suite can stay green while a stub is in place.

## Progress

<!-- progress:start -->
| Number | Title | Difficulty | Pattern | Status | Link |
| --- | --- | --- | --- | --- | --- |
| 0001 | Two Sum | Easy | Hash Map | Not started | [LeetCode](https://leetcode.com/problems/two-sum/) |
<!-- progress:end -->

## Patterns

- **Hash Map**
  - [0001. Two Sum](problems/0001-two-sum/)
- **Array**
- **Two Pointers**
- **Sliding Window**
- **Binary Search**
- **Stack**
- **Queue / BFS**
- **Linked List**
- **Tree / DFS**
- **Graph**
- **Heap**
- **Intervals**
- **Greedy**
- **Backtracking**
- **Dynamic Programming**
- **Bit Manipulation**
- **String**
- **Trie**
- **Union Find**
- **Monotonic Stack**
