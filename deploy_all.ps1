# =============================================================================
# EarningMiniApp - Full Deployment & APK Creation Script
# =============================================================================
# Ye script step-by-step guide karega:
# 1. MongoDB Atlas database setup
# 2. Render.com deployment
# 3. APK creation
# Har step pe rukega aur samjhayega kya ho rha hai
# =============================================================================

param(
    [switch]$SkipMongoDB,
    [switch]$SkipRender,
    [switch]$SkipAPK,
    [switch]$AutoMode
)

$ErrorActionPreference = "Stop"

function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "=============================================================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "=============================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Number, [string]$Title, [string]$Description)
    Write-Host "[STEP $Number] $Title" -ForegroundColor Yellow
    Write-Host "         $Description" -ForegroundColor Gray
    Write-Host ""
}

function Write-Info {
    param([string]$Text)
    Write-Host "  [INFO] $Text" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Text)
    Write-Host "  [WARN] $Text" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Text)
    Write-Host "  [ERROR] $Text" -ForegroundColor Red
}

function Read-UserChoice {
    param([string]$Question, [string]$Default = "Y")
    Write-Host "  $Question" -ForegroundColor White -NoNewline
    Write-Host " [Y/N] (Default: $Default): " -ForegroundColor Gray -NoNewline
    $choice = Read-Host
    if ([string]::IsNullOrEmpty($choice)) { $choice = $Default }
    return $choice -match '^[Yy]'
}

function Open-Browser {
    param([string]$Url)
    Write-Info "Browser khol raha hai: $Url"
    Start-Process $Url
    Start-Sleep -Seconds 2
}

function Wait-ForUser {
    param([string]$Message = "Press Enter to continue...")
    Write-Host ""
    Write-Host "  $Message" -ForegroundColor Cyan
    Read-Host | Out-Null
}

# =============================================================================
# MAIN SCRIPT
# =============================================================================

Clear-Host
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "  ║                                                                  ║" -ForegroundColor Magenta
Write-Host "  ║      🚀 EarningMiniApp - Deployment & APK Creation Wizard       ║" -ForegroundColor Magenta
Write-Host "  ║                                                                  ║" -ForegroundColor Magenta
Write-Host "  ║  Ye script tumhe step-by-step guide karega:                    ║" -ForegroundColor Magenta
Write-Host "  ║  1. MongoDB Atlas Database Setup                               ║" -ForegroundColor Magenta
Write-Host "  ║  2. Render.com pe App Deploy                                    ║" -ForegroundColor Magenta
Write-Host "  ║  3. APK File Generate karega                                    ║" -ForegroundColor Magenta
Write-Host "  ║                                                                  ║" -ForegroundColor Magenta
Write-Host "  ╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

if (-not $AutoMode) {
    $continue = Read-UserChoice "Kya aap chahte hain ki ye script aapko step-by-step guide kare?"
    if (-not $continue) {
        Write-Info "Script band ho rhi hai. Phir se run karo jab ready ho!"
        exit 0
    }
}

# =============================================================================
# STEP 1: MongoDB Atlas Database Setup
# =============================================================================

if (-not $SkipMongoDB) {
    Write-Header "STEP 1: MongoDB Atlas Database Setup"
    
    Write-Step -Number "1.1" -Title "MongoDB Atlas Account" -Description "Free cloud database banayenge jahan app ka data save hoga"
    
    Write-Info "MongoDB Atlas ek free cloud database hai."
    Write-Info "Ismein humara app ka saara data (users, coins, transactions) save hoga."
    Write-Host ""
    Write-Host "  Abhi kya karna hai:" -ForegroundColor White
    Write-Host "  1. Browser mein MongoDB Atlas website khol jayegi" -ForegroundColor Gray
    Write-Host "  2. Wahan 'Sign Up' karo (Google account se bhi kar sakte ho)" -ForegroundColor Gray
    Write-Host "  3. Free tier select karo" -ForegroundColor Gray
    Write-Host ""
    
    Wait-ForUser "Ready ho to Enter daba..."
    
    Open-Browser "https://cloud.mongodb.com/register"
    
    Write-Host ""
    $accountCreated = Read-UserChoice "Kya aapne MongoDB Atlas account banaya hai?"
    if (-not $accountCreated) {
        Write-Warning "Pehle account banayo, phir Enter daba..."
        Wait-ForUser
    }
    
    Write-Step -Number "1.2" -Title "Database Cluster Create" -Description "Free database cluster banayenge"
    
    Write-Info "Ab humein ek database cluster banana hai."
    Write-Info "Ye humara actual database hai jahan saara data save hoga."
    Write-Host ""
    Write-Host "  Steps:" -ForegroundColor White
    Write-Host "  1. 'Build a Database' pe click karo" -ForegroundColor Gray
    Write-Host "  2. 'M0 Free' plan select karo" -ForegroundColor Gray
    Write-Host "  3. Provider: AWS, Region: closest to you" -ForegroundColor Gray
    Write-Host "  4. Cluster Name: 'earning-app-cluster' rakho" -ForegroundColor Gray
    Write-Host "  5. 'Create Cluster' pe click karo" -ForegroundColor Gray
    Write-Host ""
    
    Wait-ForUser "Ready ho to Enter daba..."
    
    Open-Browser "https://cloud.mongodb.com/"
    
    Write-Host ""
    $clusterCreated = Read-UserChoice "Kya cluster create ho gaya?"
    if (-not $clusterCreated) {
        Write-Warning "Pehle cluster banayo, phir Enter daba..."
        Wait-ForUser
    }
    
    Write-Step -Number "1.3" -Title "Database User Create" -Description "Username aur password banayenge database access ke liye"
    
    Write-Info "Ab humein database user banana hai."
    Write-Info "Ye username/password humein baad mein app mein use karna hoga."
    Write-Host ""
    Write-Host "  Steps:" -ForegroundColor White
    Write-Host "  1. 'Database Access' pe click karo (left sidebar)" -ForegroundColor Gray
    Write-Host "  2. 'Add New Database User' pe click karo" -ForegroundColor Gray
    Write-Host "  3. Username: 'appadmin' rakho" -ForegroundColor Gray
    Write-Host "  4. Password: strong password set karo (save kar lo!)" -ForegroundColor Gray
    Write-Host "  5. 'Add User' pe click karo" -ForegroundColor Gray
    Write-Host ""
    
    Wait-ForUser "Ready ho to Enter daba..."
    
    Open-Browser "https://cloud.mongodb.com/"
    
    Write-Host ""
    $userCreated = Read-UserChoice "Kya database user create ho gaya?"
    if (-not $userCreated) {
        Write-Warning "Pehle user banayo, phir Enter daba..."
        Wait-ForUser
    }
    
    Write-Step -Number "1.4" -Title "IP Whitelist" -Description "Allowed IP addresses set karenge"
    
    Write-Info "Ab humein allow karna hai kon kon se IP addresses se database access le sakte hain."
    Write-Info "Production ke liye hum sab IPs allow karenge."
    Write-Host ""
    Write-Host "  Steps:" -ForegroundColor White
    Write-Host "  1. 'Network Access' pe click karo (left sidebar)" -ForegroundColor Gray
    Write-Host "  2. 'Add IP Address' pe click karo" -ForegroundColor Gray
    Write-Host "  3. '0.0.0.0/0' type karo (sab IPs allow)" -ForegroundColor Gray
    Write-Host "  4. Description: 'Allow all for app'" -ForegroundColor Gray
    Write-Host "  5. 'Confirm' pe click karo" -ForegroundColor Gray
    Write-Host ""
    
    Wait-ForUser "Ready ho to Enter daba..."
    
    Open-Browser "https://cloud.mongodb.com/"
    
    Write-Host ""
    $ipAdded = Read-UserChoice "Kya IP whitelist add ho gaya?"
    if (-not $ipAdded) {
        Write-Warning "Pehle IP add karo, phir Enter daba..."
        Wait-ForUser
    }
    
    Write-Step -Number "1.5" -Title "Connection String" -Description "Database connection string copy karenge"
    
    Write-Info "Ab humein connection string copy karna hai."
    Write-Info "Ye string humein Render pe deploy karte waqt use karni hogi."
    Write-Host ""
    Write-Host "  Steps:" -ForegroundColor White
    Write-Host "  1. 'Database' pe click karo (left sidebar)" -ForegroundColor Gray
    Write-Host "  2. Apne cluster pe click karo" -ForegroundColor Gray
    Write-Host "  3. 'Connect' button pe click karo" -ForegroundColor Gray
    Write-Host "  4. 'Connect your application' select karo" -ForegroundColor Gray
    Write-Host "  5. Driver: Python, Version: 3.12+" -ForegroundColor Gray
    Write-Host "  6. Connection string copy karo" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Example connection string:" -ForegroundColor Cyan
    Write-Host "  mongodb+srv://appadmin:YOUR_PASSWORD@earning-app-cluster.xxxxx.mongodb.net/earningapp" -ForegroundColor White
    Write-Host ""
    
    Wait-ForUser "Connection string copy kar lo, phir Enter daba..."
    
    Write-Host ""
    $connectionString = Read-Host "Apna connection string yahan paste karo (ya Enter daba agar saved hai)"
    
    if (-not [string]::IsNullOrEmpty($connectionString)) {
        $env:MONGO_URI = $connectionString
        Write-Info "Connection string saved hai memory mein. Baad mein use karenge."
    }
    
    Write-Info "MongoDB Atlas setup COMPLETE!"
}

# =============================================================================
# STEP 2: Render.com Deployment
# =============================================================================

if (-not $SkipRender) {
    Write-Header "STEP 2: Render.com pe App Deploy"
    
    Write-Step -Number "2.1" -Title "Render Account" -Description "Free hosting account banayenge"
    
    Write-Info "Render.com ek free hosting platform hai jahan humara app live chalega."
    Write-Info "Ye 24/7 online rahega kisi bhi device se access ho sake."
    Write-Host ""
    Write-Host "  Abhi kya karna hai:" -ForegroundColor White
    Write-Host "  1. Browser mein Render website khol jayegi" -ForegroundColor Gray
    Write-Host "  2. 'Sign Up' karo (GitHub account se bhi kar sakte ho)" -ForegroundColor Gray
    Write-Host "  3. Free plan select karo" -ForegroundColor Gray
    Write-Host ""
    
    Wait-ForUser "Ready ho to Enter daba..."
    
    Open-Browser "https://render.com/register"
    
    Write-Host ""
    $renderAccount = Read-UserChoice "Kya aapne Render account banaya hai?"
    if (-not $renderAccount) {
        Write-Warning "Pehle account banayo, phir Enter daba..."
        Wait-ForUser
    }
    
    Write-Step -Number "2.2" -Title "GitHub Connect" -Description "Apne GitHub repo ko connect karo"
    
    Write-Info "Ab humein apna GitHub repo connect karna hai."
    Write-Info "Tumhara code already GitHub pe hai: https://github.com/dhiresh12/-EarningMiniApp"
    Write-Host ""
    Write-Host "  Steps:" -ForegroundColor White
    Write-Host "  1. Render dashboard pe jao" -ForegroundColor Gray
    Write-Host "  2. 'New +' → 'Web Service' pe click karo" -ForegroundColor Gray
    Write-Host "  3. 'Build and deploy from a Git repository' select karo" -ForegroundColor Gray
    Write-Host "  4. GitHub authorize karo agar manga jaye" -ForegroundColor Gray
    Write-Host "  5. Repo: 'dhiresh12/-EarningMiniApp' select karo" -ForegroundColor Gray
    Write-Host ""
    
    Wait-ForUser "Ready ho to Enter daba..."
    
    Open-Browser "https://dashboard.render.com/"
    
    Write-Host ""
    $repoConnected = Read-UserChoice "Kya GitHub repo connect ho gaya?"
    if (-not $repoConnected) {
        Write-Warning "Pehle repo connect karo, phir Enter daba..."
        Wait-ForUser
    }
    
    Write-Step -Number "2.3" -Title "Service Configuration" -Description "App settings configure karo"
    
    Write-Info "Ab humein apne app ke settings set karne hain."
    Write-Info "Ye settings batate hain Render ko app kaise run karna hai."
    Write-Host ""
    Write-Host "  Settings jo set karne hain:" -ForegroundColor White
    Write-Host "  - Name: earning-mini-app" -ForegroundColor Gray
    Write-Host "  - Runtime: Python 3" -ForegroundColor Gray
    Write-Host "  - Build Command: pip install -r requirements.txt" -ForegroundColor Gray
    Write-Host "  - Start Command: gunicorn app.mini_app:app" -ForegroundColor Gray
    Write-Host "  - Plan: Free" -ForegroundColor Gray
    Write-Host ""
    
    Wait-ForUser "Settings set kar lo, phir Enter daba..."
    
    Open-Browser "https://dashboard.render.com/"
    
    Write-Host ""
    $settingsDone = Read-UserChoice "Kya settings set ho gaye?"
    if (-not $settingsDone) {
        Write-Warning "Pehle settings set karo, phir Enter daba..."
        Wait-ForUser
    }
    
    Write-Step -Number "2.4" -Title "Environment Variables" -Description "App ke secrets set karo"
    
    Write-Info "Ab humein environment variables set karne hain."
    Write-Info "Ye secret keys hain jo app ko chahiye for safe operation."
    Write-Host ""
    Write-Host "  Ye variables add karna hain:" -ForegroundColor White
    Write-Host ""
    Write-Host "  SECRET_KEY = koi strong random string (jaise: my-super-secret-key-12345)" -ForegroundColor Cyan
    Write-Host "  ADMIN_KEY = apna admin password (jaise: admin123)" -ForegroundColor Cyan
    Write-Host "  MONGO_URI = apna MongoDB connection string" -ForegroundColor Cyan
    Write-Host "  TELEGRAM_BOT_TOKEN = BotFather se jo token liya tha" -ForegroundColor Cyan
    Write-Host "  APP_NAME = Xio PayPlus" -ForegroundColor Cyan
    Write-Host "  APP_ENV = production" -ForegroundColor Cyan
    Write-Host "  MINI_APP_URL = https://earning-mini-app.onrender.com" -ForegroundColor Cyan
    Write-Host ""
    
    if (-not [string]::IsNullOrEmpty($env:MONGO_URI)) {
        Write-Info "MongoDB connection string pehle se saved hai memory mein."
        Write-Info "Use kar sakte ho: $env:MONGO_URI"
    }
    
    Wait-ForUser "Variables add kar lo, phir Enter daba..."
    
    Open-Browser "https://dashboard.render.com/"
    
    Write-Host ""
    $envAdded = Read-UserChoice "Kya saare environment variables add ho gaye?"
    if (-not $envAdded) {
        Write-Warning "Pehle variables add karo, phir Enter daba..."
        Wait-ForUser
    }
    
    Write-Step -Number "2.5" -Title "Deploy!" -Description "App ko live launch karo"
    
    Write-Info "Ab sab kuch ready hai! App ko deploy kar rahe hain."
    Write-Info "Ye 2-3 minutes mein complete ho jayega."
    Write-Host ""
    Write-Host "  Steps:" -ForegroundColor White
    Write-Host "  1. 'Create Web Service' pe click karo" -ForegroundColor Gray
    Write-Host "  2. Render automatically code clone karega" -ForegroundColor Gray
    Write-Host "  3. Dependencies install karega" -ForegroundColor Gray
    Write-Host "  4. App ko start karega" -ForegroundColor Gray
    Write-Host "  5. Live URL dega (jaise: https://earning-mini-app.onrender.com)" -ForegroundColor Gray
    Write-Host ""
    
    Wait-ForUser "Deploy button click karne ke liye Enter daba..."
    
    Open-Browser "https://dashboard.render.com/"
    
    Write-Host ""
    $deployed = Read-UserChoice "Kya app deploy ho gaya? Live URL mil gaya?"
    if (-not $deployed) {
        Write-Warning "Pehle deploy karo, phir Enter daba..."
        Wait-ForUser
    }
    
    Write-Host ""
    $liveUrl = Read-Host "Apna Live URL yahan paste karo (jaise: https://earning-mini-app.onrender.com)"
    if (-not [string]::IsNullOrEmpty($liveUrl)) {
        $env:APP_URL = $liveUrl
        Write-Info "Live URL saved hai: $liveUrl"
    }
    
    Write-Info "Render Deployment COMPLETE!"
}

# =============================================================================
# STEP 3: APK Creation
# =============================================================================

if (-not $SkipAPK) {
    Write-Header "STEP 3: APK File Banaye (Play Store ke liye)"
    
    Write-Step -Number "3.1" -Title "PWA Check" -Description "Check karenge ki app PWA-ready hai"
    
    Write-Info "APK banane se pehle check karenge ki app PWA-ready hai ya nahi."
    Write-Info "PWA = Progressive Web App, jise Play Store pe publish kar sakte hain."
    Write-Host ""
    
    if (-not [string]::IsNullOrEmpty($env:APP_URL)) {
        $url = $env:APP_URL
    } else {
        $url = Read-Host "Apna deployed app URL yahan daalo"
    }
    
    Write-Info "Checking PWA readiness for: $url"
    Write-Host ""
    
    try {
        $response = Invoke-WebRequest -Uri "$url/manifest.json" -UseBasicParsing -ErrorAction Stop
        Write-Info "Manifest found! App PWA-ready hai."
    } catch {
        Write-Warning "Manifest nahi mila. APK ke liye thodi adjustments chahiye."
    }
    
    Write-Step -Number "3.2" -Title "APK Generation Method" -Description "Kaun sa method use karein APK banane ke liye"
    
    Write-Host ""
    Write-Host "  APK banane ke 3 tarike hain:" -ForegroundColor White
    Write-Host ""
    Write-Host "  Method 1: PWABuilder (SABSE AASAN - 5 minutes)" -ForegroundColor Green
    Write-Host "    - Website pe URL daalo, APK download kar lo" -ForegroundColor Gray
    Write-Host "    - No coding required" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Method 2: Bubblewrap CLI (Thoda technical)" -ForegroundColor Yellow
    Write-Host "    - Command line se APK build" -ForegroundColor Gray
    Write-Host "    - Node.js required" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Method 3: Android Studio (Full control)" -ForegroundColor Cyan
    Write-Host "    - Professional Android project" -ForegroundColor Gray
    Write-Host "    - Java/Kotlin knowledge required" -ForegroundColor Gray
    Write-Host ""
    
    $method = Read-Host "Kaun sa method use karna chahte ho? (1/2/3)"
    
    switch ($method) {
        "1" {
            Write-Step -Number "3.3" -Title "PWABuilder Method" -Description "Website se APK generate karein"
            
            Write-Info "PWABuilder use kar rahe hain. Ye sabse aasaan tarika hai."
            Write-Host ""
            Write-Host "  Steps:" -ForegroundColor White
            Write-Host "  1. Browser mein PWABuilder khol jayegi" -ForegroundColor Gray
            Write-Host "  2. Apna app URL daalo" -ForegroundColor Gray
            Write-Host "  3. 'Package for stores' → 'Android' select karo" -ForegroundColor Gray
            Write-Host "  4. App details bharo (name, package name)" -ForegroundColor Gray
            Write-Host "  5. 'Generate' pe click karo" -ForegroundColor Gray
            Write-Host "  6. APK download ho jayega" -ForegroundColor Gray
            Write-Host ""
            
            Wait-ForUser "Ready ho to Enter daba..."
            
            Open-Browser "https://www.pwabuilder.com/"
            
            Write-Host ""
            Write-Info "PWABuilder khol gaya hai. Ab instructions follow karo."
            Write-Info "APK download hone ke baad, Play Store pe publish kar sakte ho."
        }
        "2" {
            Write-Step -Number "3.3" -Title "Bubblewrap Method" -Description "CLI se APK build karein"
            
            Write-Info "Bubblewrap use kar rahe hain. Ye Node.js based tool hai."
            Write-Host ""
            Write-Host "  Pehle ye install karo:" -ForegroundColor White
            Write-Host "  npm install -g @angular/serviceworker @bubblewrap/core" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "  Phir ye commands run karo:" -ForegroundColor White
            Write-Host "  bubblewrap init --manifest $url/manifest.json" -ForegroundColor Cyan
            Write-Host "  bubblewrap build" -ForegroundColor Cyan
            Write-Host ""
            
            $installBubblewrap = Read-UserChoice "Kya Bubblewrap already installed hai?"
            if (-not $installBubblewrap) {
                Write-Info "Installing Bubblewrap..."
                npm install -g @angular/serviceworker @bubblewrap/core
            }
            
            Write-Info "Bubblewrap initialized kar rahe hain..."
            bubblewrap init --manifest "$url/manifest.json"
            
            Write-Info "APK build kar rahe hain..."
            bubblewrap build
        }
        "3" {
            Write-Step -Number "3.3" -Title "Android Studio Method" -Description "Professional Android app banaye"
            
            Write-Info "Android Studio use kar rahe hain. Ye professional tarika hai."
            Write-Host ""
            Write-Host "  Steps:" -ForegroundColor White
            Write-Host "  1. Android Studio install karo" -ForegroundColor Gray
            Write-Host "  2. New Project → 'Empty Activity' select karo" -ForegroundColor Gray
            Write-Host "  3. Package name: 'com.yourname.earningminiapp'" -ForegroundColor Gray
            Write-Host "  4. MainActivity.xml mein WebView add karo" -ForegroundColor Gray
            Write-Host "  5. WebView mein URL load karo: $url" -ForegroundColor Gray
            Write-Host "  6. Build → Generate Signed Bundle/APK" -ForegroundColor Gray
            Write-Host ""
            
            Open-Browser "https://developer.android.com/studio"
            
            Wait-ForUser "Android Studio install karne ke liye Enter daba..."
        }
        default {
            Write-Warning "Invalid choice. PWABuilder method use karenge."
            Open-Browser "https://www.pwabuilder.com/"
        }
    }
    
    Write-Info "APK Creation process COMPLETE!"
}

# =============================================================================
# FINAL SUMMARY
# =============================================================================

Write-Header "🎉 DEPLOYMENT COMPLETE!"

Write-Host "  Ab aapka app live hai aur Play Store ke liye ready!" -ForegroundColor Green
Write-Host ""
Write-Host "  Summary:" -ForegroundColor Yellow
Write-Host "  ---------" -ForegroundColor Yellow

if (-not $SkipMongoDB) {
    Write-Host "  Database: MongoDB Atlas (Free tier)" -ForegroundColor Green
    Write-Host "  Connection: $env:MONGO_URI" -ForegroundColor Gray
}

if (-not $SkipRender) {
    Write-Host "  Hosting: Render.com (Free tier)" -ForegroundColor Green
    Write-Host "  Live URL: $env:APP_URL" -ForegroundColor Gray
}

if (-not $SkipAPK) {
    Write-Host "  APK: Generated using selected method" -ForegroundColor Green
}

Write-Host ""
Write-Host "  Next Steps:" -ForegroundColor Yellow
Write-Host "  ------------" -ForegroundColor Yellow
Write-Host "  1. App ko test karo live URL pe" -ForegroundColor White
Write-Host "  2. Telegram bot connect karo" -ForegroundColor White
Write-Host "  3. Play Store pe publish karo" -ForegroundColor White
Write-Host "  4. Users ko invite karo" -ForegroundColor White
Write-Host ""
Write-Host "  Help chahiye to bolo!" -ForegroundColor Cyan
Write-Host ""

# Save configuration
$config = @{
    mongo_uri = $env:MONGO_URI
    app_url = $env:APP_URL
    deployed_at = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
} | ConvertTo-Json

if (-not (Test-Path "deployment-config.json")) {
    $config | Out-File -FilePath "deployment-config.json" -Encoding UTF8
    Write-Info "Configuration saved to: deployment-config.json"
}

Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host "  Script complete! Allah hafiz! 👋" -ForegroundColor Magenta
Write-Host "=============================================================================" -ForegroundColor Cyan
Write-Host ""
