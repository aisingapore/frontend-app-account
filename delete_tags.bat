@echo off
setlocal enabledelayedexpansion

:: Fetch all tags from remote
git fetch --tags

:: List all tags and delete the ones that are not "open-release/palm.4"
for /f "tokens=*" %%a in ('git tag') do (
    if "%%a" neq "open-release/palm.4" (
        echo Deleting local tag %%a
        git tag -d %%a
    )
)

:: Push deletions to remote
for /f "tokens=*" %%a in ('git ls-remote --tags origin ^| findstr /v "refs/tags/open-release/palm.4"') do (
    set "line=%%a"
    for /f "tokens=*" %%b in ("!line!") do (
        set "tag=!line:refs/tags/=!"
        echo Deleting remote tag !tag!
        git push origin --delete tag !tag!
    )
)

endlocal
