# Test Action

> **Part of the se2-dev-game-code skill.** Invoked to run game code search tests and verify results.

Run `test_search.bat` to verify the game code search functionality is working correctly.

## Running Tests

From this skill folder, run:

```cmd
.\test_search.bat
```

Or redirect output to a file for review:

```cmd
.\test_search.bat > test_results.txt 2>&1
```

## What the Tests Cover

The test suite exercises all game code search capabilities:

| Category | Tests |
|----------|-------|
| Class declaration | Entity, GameApp |
| Class usage | Entity, GameApp |
| Struct declaration | Vector3D, ColorHSV |
| Struct usage | Vector3D, ColorHSV |
| Method declaration | Init, Update |
| Method usage | Init, Dispose |
| Method signature | Init, Update, GetPosition |
| Field declaration | Position, Forward |
| Field usage | Update (regex), Position |
| Interface declaration | IEntityContainer, IEntityLifetime |
| Interface usage | IEntityContainer |
| Enum declaration | Type |
| Enum usage | Type |
| Namespace filtering | Keen.Game2 |
| Pagination | limit and offset options |
| Count mode | counting results instead of listing |
| Regex patterns | ^Grid, Position$, ^Vector[23]D$ |
| Multiple patterns | AND logic with multiple terms |
| Hierarchy - class parent | Entity |
| Hierarchy - class children | Entity |
| Hierarchy - interface parent | IEntityContainer |
| Hierarchy - interface children | IEntityContainer |
| Hierarchy - class implements | Entity |
| Hierarchy - interface implementors | IEntityContainer |
| Non-matching examples | Verify empty results don't crash |

## Verifying Results

A successful test run should:

1. **Complete without errors** - No Python exceptions or crashes
2. **Return results for known items** - Each search (except non-matching examples) should return at least one result
3. **Show "NO-MATCHES"** for the non-matching examples section
4. **End with "ALL TESTS COMPLETED"** message

## Example Verification

Check that key searches return expected results:

```cmd
REM Should find the Entity class
uv run search_code.py class declaration Entity

REM Should find Vector3D struct
uv run search_code.py struct declaration Vector3D

REM Should return count > 0
uv run search_code.py -c class usage Entity
```

## Troubleshooting

If tests fail:

1. **Preparation not complete** - Run `.\Prepare.bat` first
2. **Index not built** - Check that `CodeIndex/` folder exists and contains `.csv` files
3. **Decompiled folder missing** - Verify `Decompiled/` folder has `.cs` files
4. **Python environment issues** - Try `uv sync` to reinstall dependencies

As a last resort, you can force repeating the whole preparation process by running `.\Clean.bat`, then `.\Prepare.bat`.
Notify the user if you do this, because the preparation may take 5-15 minutes to complete depending on the hardware.
