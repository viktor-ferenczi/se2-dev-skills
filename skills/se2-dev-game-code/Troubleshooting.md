# Troubleshooting Guide

This guide helps you resolve common issues when searching game code.

## NO-MATCHES Results

### Common Causes

1. **Wrong skill**: 
   - Game classes like `CubeGridComponent` → use `se2-dev-game-code` ✅
   - Mod code → use `se2-dev-mod`
   - Plugin code → use `se2-dev-plugin`
   - Script code → use `se2-dev-script`

2. **Exact name mismatch**: Try using regex patterns:
   ```bash
   # Instead of exact match
   uv run search_code.py class declaration "MyGameLogic"
   
   # Try broader pattern
   uv run search_code.py class declaration "re:.*GameLogic.*"
   ```

3. **Searching declarations instead of usages** (or vice versa):
   ```bash
   # Try both
   uv run search_code.py class declaration MyClass
   uv run search_code.py class usage MyClass
   ```

4. **Index not built yet**:
   - Check if `CodeIndex/` directory exists in the skill folder
   - If missing, preparation didn't complete successfully
   - Re-run `./Prepare.bat` from the skill directory

### Debugging Strategy

```bash
# Step 1: Count first to see if anything matches
uv run search_code.py class usage Entity --count

# Step 2: If 0, try broader search with regex
uv run search_code.py class usage "re:.*Entity.*" --count

# Step 3: Check what files are available
ls Decompiled/Game2.Simulation/Keen/Game2/Simulation/WorldObjects/CubeGrids/*.cs | head -10

# Step 4: Try direct file search as fallback
grep -r "class.*Component" Decompiled/Game2.Simulation/Keen/Game2/Simulation/WorldObjects/CubeGrids/ | head -5
```

## Too Many Results

When searches return hundreds or thousands of matches:

### 1. Count First
Always check how many results you'll get:

```bash
uv run search_code.py class usage CubeGridComponent --count
```

### 2. Use Limit to Preview
View just the first few results:

```bash
# Show first 20 matches
uv run search_code.py class usage CubeGridComponent --limit 20
```

### 3. Refine Your Search
Make your pattern more specific:

```bash
# Too broad (returns 861 results)
uv run search_code.py struct usage Vector3D --count

# More specific - only in Keen.Game2 namespace
uv run search_code.py struct usage Vector3D -n Keen.Game2 --count

# Even more specific - use regex for exact context
uv run search_code.py struct usage "Vector3D" -n Keen.Game2.Simulation.WorldObjects
```

### 4. Paginate Through Results
Use offset to view results in batches:

```bash
# First 100
uv run search_code.py class usage CubeGridComponent --limit 10 --offset 0

# Next 100
uv run search_code.py class usage CubeGridComponent --limit 10 --offset 10

# Third 100
uv run search_code.py class usage CubeGridComponent --limit 10 --offset 20
```

## Index Issues

### Re-indexing

If searches return unexpected results or after game updates:

```bash
# Delete old index
rm -rf CodeIndex/

# Re-run preparation (this will rebuild the index)
./Prepare.bat
```

### Checking Index Status

```bash
# Check if index exists
test -d CodeIndex && echo "Index exists" || echo "Index missing"

# Count indexed entries
wc -l CodeIndex/*.csv

# See what's indexed
ls -lh CodeIndex/
```

## Wrong Skill Selection

Each skill searches different code:

| What you need | Skill to use |
|---------------|--------------|
| Base game classes (CubeGridComponent, CharacterComponent, GameComponent, etc.) | `se2-dev-game-code` |
| Mod code examples from Steam Workshop | `se2-dev-mod` |
| Plugin code from PluginHub | `se2-dev-plugin` |
| PB script examples from Workshop | `se2-dev-script` |

If you're looking for examples of how others use game APIs, use `se2-dev-mod` or `se2-dev-script`.
If you need to understand the game's internal implementation, use `se2-dev-game-code`.

## Search Tips

### 1. Start Broad, Then Narrow

```bash
# Start with count only
uv run search_code.py class declaration "re:.*Physics.*" --count

# If too many, add namespace filter
uv run search_code.py class declaration "re:.*Physics.*" -n Keen.VRage --count

# View limited results
uv run search_code.py class declaration "re:.*Physics.*" -n Keen.VRage --limit 10
```

### 2. Use Case-Insensitive Search

```bash
# Case-sensitive (default)
uv run search_code.py class declaration "cubegridcomponent"  # Won't match CubeGridComponent

# Case-insensitive
uv run search_code.py class declaration "cubegridcomponent" -i  # Matches CubeGridComponent
```

### 3. Search Multiple Patterns

```bash
# Find methods containing both "Get" and "Position"
uv run search_code.py method declaration "Get" "Position"
```

### 4. Hierarchy Searches

When looking for inheritance:

```bash
# Find what CubeGridComponent inherits from
uv run search_code.py class parent CubeGridComponent

# Find what inherits from GameComponent
uv run search_code.py class children GameComponent

# Find interfaces implemented by a class
uv run search_code.py class implements CubeGridComponent

# Find classes implementing an interface
uv run search_code.py interface implementors IInSceneListener
```

## Still Having Issues?

If you're still getting NO-MATCHES or unexpected results:

1. **Verify preparation completed**:
   ```bash
   test -f Prepare.DONE && echo "OK" || echo "Preparation incomplete"
   ```

2. **Check decompiled code exists**:
   ```bash
   ls Decompiled/ | head -5
   ```

3. **Manually search to verify**:
   ```bash
   grep -r "CubeGridComponent" Decompiled/Game2.Simulation/ | head -3
   ```

4. **Check the logs**:
   ```bash
   tail -20 Prepare.log
   ```
