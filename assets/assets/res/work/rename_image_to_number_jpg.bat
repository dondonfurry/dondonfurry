@echo off
setlocal enabledelayedexpansion

echo 1단계: 임시 파일명(a, aa, aaa...)으로 변경 중...
set count=0
set prefix=

for %%f in (*.jpg *.jpeg *.png *.JPG *.JPEG *.PNG *.webp) do (
    set prefix=!prefix!a
    ren "%%f" "!prefix!%%~xf"
)

echo 2단계: 최종 파일명(1, 2, 3...)으로 변경 중...
set count=1

for %%f in (a*.jpg a*.jpeg a*.png a*.JPG a*.JPEG a*.PNG a*.webp) do (
    ren "%%f" "!count!.webp"
    set /a count+=1
)

echo 파일명 변경 완료! 1.webp부터 시작합니다.
pause