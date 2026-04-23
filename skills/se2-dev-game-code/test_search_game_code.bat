@echo off
setlocal
cd /d "%~dp0"

echo ============================================================
echo CLASS DECLARATION
echo ============================================================
echo --- Entity class declaration ---
uv run search_game_code.py class declaration Entity
echo.
echo --- GameApp class declaration ---
uv run search_game_code.py class declaration GameApp
echo.

echo ============================================================
echo CLASS USAGE
echo ============================================================
echo --- Entity class usage (limit 5) ---
uv run search_game_code.py -l 5 class usage Entity
echo.
echo --- GameApp class usage (limit 5) ---
uv run search_game_code.py -l 5 class usage GameApp
echo.

echo ============================================================
echo STRUCT DECLARATION
echo ============================================================
echo --- Vector3D struct declaration ---
uv run search_game_code.py struct declaration Vector3D
echo.
echo --- ColorHSV struct declaration ---
uv run search_game_code.py struct declaration "re:^ColorHSV$"
echo.

echo ============================================================
echo STRUCT USAGE
echo ============================================================
echo --- Vector3D struct usage (limit 5) ---
uv run search_game_code.py -l 5 struct usage Vector3D
echo.
echo --- ColorHSV struct usage (limit 5) ---
uv run search_game_code.py -l 5 struct usage "re:^ColorHSV$"
echo.

echo ============================================================
echo METHOD DECLARATION
echo ============================================================
echo --- Init method declaration (limit 5) ---
uv run search_game_code.py -l 5 method declaration Init
echo.
echo --- Update method declaration (limit 5) ---
uv run search_game_code.py -l 5 method declaration "re:^Update$"
echo.

echo ============================================================
echo METHOD USAGE
echo ============================================================
echo --- Init method usage (limit 5) ---
uv run search_game_code.py -l 5 method usage Init
echo.
echo --- Dispose method usage (limit 5) ---
uv run search_game_code.py -l 5 method usage Dispose
echo.

echo ============================================================
echo FIELD DECLARATION
echo ============================================================
echo --- Position field declaration ---
uv run search_game_code.py field declaration Position
echo.
echo --- Forward field declaration (limit 5) ---
uv run search_game_code.py -l 5 field declaration "re:^Forward$"
echo.

echo ============================================================
echo FIELD USAGE
echo ============================================================
echo --- Field usage in Update methods (limit 5) ---
uv run search_game_code.py -l 5 field usage "re:^Update$"
echo.
echo --- Position field usage (limit 5) ---
uv run search_game_code.py -l 5 field usage Position
echo.

echo ============================================================
echo INTERFACE DECLARATION
echo ============================================================
echo --- IEntityContainer interface declaration ---
uv run search_game_code.py interface declaration IEntityContainer
echo.
echo --- IEntityLifetime interface declaration ---
uv run search_game_code.py interface declaration IEntityLifetime
echo.

echo ============================================================
echo INTERFACE USAGE
echo ============================================================
echo --- IEntityContainer interface usage (limit 5) ---
uv run search_game_code.py -l 5 interface usage IEntityContainer
echo.

echo ============================================================
echo ENUM DECLARATION
echo ============================================================
echo --- enum declarations matching "Type" (limit 5) ---
uv run search_game_code.py -l 5 enum declaration Type
echo.

echo ============================================================
echo ENUM USAGE
echo ============================================================
echo --- enum usages matching "Type" (limit 5) ---
uv run search_game_code.py -l 5 enum usage Type
echo.

echo ============================================================
echo NAMESPACE FILTERING
echo ============================================================
echo --- Classes in Keen.Game2 namespace (limit 5) ---
uv run search_game_code.py -n Keen.Game2 -l 5 class declaration ""
echo.
echo --- Methods in Keen.Game2 namespace containing "Update" (limit 5) ---
uv run search_game_code.py -n Keen.Game2 -l 5 method declaration Update
echo.

echo ============================================================
echo PAGINATION (LIMIT AND OFFSET)
echo ============================================================
echo --- First 3 class declarations ---
uv run search_game_code.py -l 3 class declaration ""
echo.
echo --- Next 3 class declarations (offset 3) ---
uv run search_game_code.py -l 3 -o 3 class declaration ""
echo.
echo --- Skip 6, show 3 ---
uv run search_game_code.py -l 3 -o 6 class declaration ""
echo.

echo ============================================================
echo COUNT MODE
echo ============================================================
echo --- Count of Entity usages ---
uv run search_game_code.py -c class usage Entity
echo.
echo --- Count of Vector3D usages ---
uv run search_game_code.py -c struct usage Vector3D
echo.
echo --- Count of Init method declarations ---
uv run search_game_code.py -c method declaration Init
echo.

echo ============================================================
echo REGEX PATTERNS
echo ============================================================
echo --- Classes starting with "Grid" (limit 5) ---
uv run search_game_code.py -l 5 class declaration "re:^Grid"
echo.
echo --- Methods ending with "Position" (limit 5) ---
uv run search_game_code.py -l 5 method declaration "re:Position$"
echo.
echo --- Structs matching "Vector[23]D" ---
uv run search_game_code.py struct declaration "re:^Vector[23]D$"
echo.

echo ============================================================
echo MULTIPLE PATTERNS (AND logic)
echo ============================================================
echo --- Methods containing both "Get" and "Position" ---
uv run search_game_code.py -l 5 method declaration Get Position
echo.

echo ============================================================
echo METHOD SIGNATURE SEARCH
echo ============================================================
echo --- Init method signature (limit 5) ---
uv run search_game_code.py -l 5 method signature Init
echo.
echo --- Update method signature (limit 5) ---
uv run search_game_code.py -l 5 method signature "re:^Update$"
echo.
echo --- Count of GetPosition method signatures ---
uv run search_game_code.py -c method signature GetPosition
echo.
echo --- Signature containing both "Get" and "Position" ---
uv run search_game_code.py -l 5 method signature Get Position
echo.

echo ============================================================
echo NON-MATCHING EXAMPLES
echo ============================================================
echo --- Non-existent class ---
uv run search_game_code.py class declaration ThisClassDoesNotExist12345
echo.
echo --- Non-existent method ---
uv run search_game_code.py method declaration ZzzNonExistentMethod999
echo.
echo --- Non-matching regex ---
uv run search_game_code.py struct declaration "re:^ZZZZZ.*XXXXX$"
echo.

echo ============================================================
echo HIERARCHY SEARCH - CLASS PARENT
echo ============================================================
echo --- Find parent of Entity ---
uv run search_game_code.py -l 5 class parent Entity
echo.

echo ============================================================
echo HIERARCHY SEARCH - CLASS CHILDREN
echo ============================================================
echo --- Find children of Entity (limit 5) ---
uv run search_game_code.py -l 5 class children Entity
echo.

echo ============================================================
echo HIERARCHY SEARCH - INTERFACE PARENT
echo ============================================================
echo --- Find parent of IEntityContainer ---
uv run search_game_code.py interface parent IEntityContainer
echo.

echo ============================================================
echo HIERARCHY SEARCH - INTERFACE CHILDREN
echo ============================================================
echo --- Find children of IEntityContainer (limit 5) ---
uv run search_game_code.py -l 5 interface children IEntityContainer
echo.

echo ============================================================
echo HIERARCHY SEARCH - CLASS IMPLEMENTS
echo ============================================================
echo --- Find interfaces implemented by Entity (limit 5) ---
uv run search_game_code.py -l 5 class implements Entity
echo.

echo ============================================================
echo HIERARCHY SEARCH - INTERFACE IMPLEMENTORS
echo ============================================================
echo --- Find implementors of IEntityContainer (limit 5) ---
uv run search_game_code.py -l 5 interface implementors IEntityContainer
echo.

echo ============================================================
echo HIERARCHY SEARCH - COUNT MODE
echo ============================================================
echo --- Count children of Entity ---
uv run search_game_code.py -c class children Entity
echo.
echo --- Count implementors of IEntityContainer ---
uv run search_game_code.py -c interface implementors IEntityContainer
echo.

echo ============================================================
echo HIERARCHY SEARCH - WITH NAMESPACE FILTER
echo ============================================================
echo --- Find children of Entity in Keen.Game2 namespace (limit 5) ---
uv run search_game_code.py -n Keen.Game2 -l 5 class children Entity
echo.

echo ============================================================
echo ALL TESTS COMPLETED
echo ============================================================
