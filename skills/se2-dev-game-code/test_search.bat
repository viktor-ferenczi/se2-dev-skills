@echo off
setlocal
cd /d "%~dp0"

echo ============================================================
echo CLASS DECLARATION
echo ============================================================
echo --- MyEntity class declaration ---
uv run search_code.py class declaration MyEntity
echo.
echo --- MyPhysicsBody class declaration ---
uv run search_code.py class declaration MyPhysicsBody
echo.

echo ============================================================
echo CLASS USAGE
echo ============================================================
echo --- MyEntity class usage (limit 5) ---
uv run search_code.py -l 5 class usage MyEntity
echo.
echo --- MyPhysicsBody class usage (limit 5) ---
uv run search_code.py -l 5 class usage MyPhysicsBody
echo.

echo ============================================================
echo STRUCT DECLARATION
echo ============================================================
echo --- Vector3D struct declaration ---
uv run search_code.py struct declaration Vector3D
echo.
echo --- Color struct declaration ---
uv run search_code.py struct declaration "re:^Color$"
echo.

echo ============================================================
echo STRUCT USAGE
echo ============================================================
echo --- Vector3D struct usage (limit 5) ---
uv run search_code.py -l 5 struct usage Vector3D
echo.
echo --- Color struct usage (limit 5) ---
uv run search_code.py -l 5 struct usage "re:^Color$"
echo.

echo ============================================================
echo METHOD DECLARATION
echo ============================================================
echo --- Init method declaration (limit 5) ---
uv run search_code.py -l 5 method declaration Init
echo.
echo --- Update method declaration (limit 5) ---
uv run search_code.py -l 5 method declaration "re:^Update$"
echo.

echo ============================================================
echo METHOD USAGE
echo ============================================================
echo --- Init method usage (limit 5) ---
uv run search_code.py -l 5 method usage Init
echo.
echo --- Dispose method usage (limit 5) ---
uv run search_code.py -l 5 method usage Dispose
echo.

echo ============================================================
echo FIELD DECLARATION
echo ============================================================
echo --- Position field declaration ---
uv run search_code.py field declaration Position
echo.
echo --- Forward field declaration (limit 5) ---
uv run search_code.py -l 5 field declaration "re:^Forward$"
echo.

echo ============================================================
echo FIELD USAGE
echo ============================================================
echo --- Forward field usage (limit 5) ---
uv run search_code.py -l 5 field usage "re:^Forward$"
echo.
echo --- Position field usage (limit 5) ---
uv run search_code.py -l 5 field usage Position
echo.

echo ============================================================
echo INTERFACE DECLARATION
echo ============================================================
echo --- IMyEntity interface declaration ---
uv run search_code.py interface declaration IMyEntity
echo.
echo --- IDisposable interface declaration ---
uv run search_code.py interface declaration IDisposable
echo.

echo ============================================================
echo INTERFACE USAGE
echo ============================================================
echo --- IMyEntity interface usage (limit 5) ---
uv run search_code.py -l 5 interface usage IMyEntity
echo.

echo ============================================================
echo ENUM DECLARATION
echo ============================================================
echo --- enum declarations matching "Type" (limit 5) ---
uv run search_code.py -l 5 enum declaration Type
echo.

echo ============================================================
echo ENUM USAGE
echo ============================================================
echo --- enum usages matching "Type" (limit 5) ---
uv run search_code.py -l 5 enum usage Type
echo.

echo ============================================================
echo NAMESPACE FILTERING
echo ============================================================
echo --- Classes in VRage.Core namespace (limit 5) ---
uv run search_code.py -n VRage.Core -l 5 class declaration ""
echo.
echo --- Methods in VRage namespace containing "Get" (limit 5) ---
uv run search_code.py -n VRage -l 5 method declaration Get
echo.

echo ============================================================
echo PAGINATION (LIMIT AND OFFSET)
echo ============================================================
echo --- First 3 class declarations ---
uv run search_code.py -l 3 class declaration ""
echo.
echo --- Next 3 class declarations (offset 3) ---
uv run search_code.py -l 3 -o 3 class declaration ""
echo.
echo --- Skip 6, show 3 ---
uv run search_code.py -l 3 -o 6 class declaration ""
echo.

echo ============================================================
echo COUNT MODE
echo ============================================================
echo --- Count of MyEntity usages ---
uv run search_code.py -c class usage MyEntity
echo.
echo --- Count of Vector3D usages ---
uv run search_code.py -c struct usage Vector3D
echo.
echo --- Count of Init method declarations ---
uv run search_code.py -c method declaration Init
echo.

echo ============================================================
echo REGEX PATTERNS
echo ============================================================
echo --- Classes starting with "My" (limit 5) ---
uv run search_code.py -l 5 class declaration "re:^My"
echo.
echo --- Methods ending with "Position" (limit 5) ---
uv run search_code.py -l 5 method declaration "re:Position$"
echo.
echo --- Structs matching "Vector[23]D" ---
uv run search_code.py struct declaration "re:^Vector[23]D$"
echo.

echo ============================================================
echo MULTIPLE PATTERNS (AND logic)
echo ============================================================
echo --- Methods containing both "Get" and "Position" ---
uv run search_code.py -l 5 method declaration Get Position
echo.

echo ============================================================
echo METHOD SIGNATURE SEARCH
echo ============================================================
echo --- Init method signature (limit 5) ---
uv run search_code.py -l 5 method signature Init
echo.
echo --- Update method signature (limit 5) ---
uv run search_code.py -l 5 method signature "re:^Update$"
echo.
echo --- Count of GetPosition method signatures ---
uv run search_code.py -c method signature GetPosition
echo.
echo --- Signature containing both "Get" and "Position" ---
uv run search_code.py -l 5 method signature Get Position
echo.

echo ============================================================
echo NON-MATCHING EXAMPLES
echo ============================================================
echo --- Non-existent class ---
uv run search_code.py class declaration ThisClassDoesNotExist12345
echo.
echo --- Non-existent method ---
uv run search_code.py method declaration ZzzNonExistentMethod999
echo.
echo --- Non-matching regex ---
uv run search_code.py struct declaration "re:^ZZZZZ.*XXXXX$"
echo.

echo ============================================================
echo HIERARCHY SEARCH - CLASS PARENT
echo ============================================================
echo --- Find parent of MyEntity ---
uv run search_code.py class parent MyEntity
echo.

echo ============================================================
echo HIERARCHY SEARCH - CLASS CHILDREN
echo ============================================================
echo --- Find children of MyEntity (limit 5) ---
uv run search_code.py -l 5 class children MyEntity
echo.

echo ============================================================
echo HIERARCHY SEARCH - INTERFACE PARENT
echo ============================================================
echo --- Find parent of IMyEntity ---
uv run search_code.py interface parent IMyEntity
echo.

echo ============================================================
echo HIERARCHY SEARCH - INTERFACE CHILDREN
echo ============================================================
echo --- Find children of IMyEntity (limit 5) ---
uv run search_code.py -l 5 interface children IMyEntity
echo.

echo ============================================================
echo HIERARCHY SEARCH - CLASS IMPLEMENTS
echo ============================================================
echo --- Find interfaces implemented by MyEntity ---
uv run search_code.py class implements MyEntity
echo.

echo ============================================================
echo HIERARCHY SEARCH - INTERFACE IMPLEMENTORS
echo ============================================================
echo --- Find implementors of IMyEntity (limit 5) ---
uv run search_code.py -l 5 interface implementors IMyEntity
echo.

echo ============================================================
echo HIERARCHY SEARCH - COUNT MODE
echo ============================================================
echo --- Count children of MyEntity ---
uv run search_code.py -c class children MyEntity
echo.
echo --- Count implementors of IMyEntity ---
uv run search_code.py -c interface implementors IMyEntity
echo.

echo ============================================================
echo HIERARCHY SEARCH - WITH NAMESPACE FILTER
echo ============================================================
echo --- Find children of MyEntity in VRage namespace (limit 5) ---
uv run search_code.py -n VRage -l 5 class children MyEntity
echo.

echo ============================================================
echo ALL TESTS COMPLETED
echo ============================================================
