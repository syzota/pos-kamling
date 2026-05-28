Write-Host "Building APK..." -ForegroundColor Cyan
cd android
.\gradlew.bat assembleDebug --no-daemon
cd ..

if (Test-Path "android/app/build/outputs/apk/debug/app-debug.apk") {
    Write-Host "Installing to device..." -ForegroundColor Green
    flutter install --use-application-binary="android/app/build/outputs/apk/debug/app-debug.apk"
    Write-Host "Done!" -ForegroundColor Green
} else {
    Write-Host "Build failed!" -ForegroundColor Red
}