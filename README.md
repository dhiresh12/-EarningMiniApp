# EarningMiniApp

Cross-platform earning app. Use it on **Windows PC** and **Mobile**.

- Backend: Flask API
- Desktop: Electron wrapper
- Mobile: PWA / APK ready

## Quick Start

### 1. Backend
```powershell
cd C:\Users\dhiresh\OneDrive\Desktop\EarningMiniApp
.\.venv\Scripts\Activate.ps1
python -m flask --app app.mini_app run --port 5000
```

### 2. Desktop App
```powershell
cd electron-app
npm install
npm start
```

### 3. Mobile
Open `http://localhost:5000` on mobile browser or build APK with PWABuilder.

## Build Windows EXE
```powershell
cd electron-app
npm run build-win
```

## Environment
Copy `.env.example` to `.env` and set:
- `SECRET_KEY`
- `ADMIN_KEY`
- `MONGO_URI`
- `APP_NAME`

## License
Private
