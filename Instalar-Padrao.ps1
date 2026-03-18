# ============================================================
# INSTALADOR PADRÃO DE SOFTWARES - WINDOWS
# Requer: PowerShell como Administrador
# Usa: WinGet
# Log: C:\Temp\Instalador-Padrao.log
# ============================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = 'Stop'

$LogDir  = "C:\Temp"
$LogFile = Join-Path $LogDir "Instalador-Padrao.log"

function Initialize-Log {
    if (-not (Test-Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
    }

    if (-not (Test-Path $LogFile)) {
        New-Item -Path $LogFile -ItemType File -Force | Out-Null
    }
}

function Write-Log {
    param(
        [string]$Message
    )

    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$timeStamp] $Message"
}

function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Winget {
    return $null -ne (Get-Command winget -ErrorAction SilentlyContinue)
}

function Pause-Script {
    Write-Host ""
    Read-Host "Pressione ENTER para continuar"
}

function Install-App {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $true)]
        [string]$Nome
    )

    try {
        Write-Host ""
        Write-Host "==================================================" -ForegroundColor DarkCyan
        Write-Host "Instalando: $Nome" -ForegroundColor Cyan
        Write-Host "Pacote: $Id"
        Write-Host "==================================================" -ForegroundColor DarkCyan

        Write-Log "Iniciando instalação de: $Nome ($Id)"

        $wingetArgs = @(
            "install"
            "--id", $Id
            "--exact"
            "--silent"
            "--accept-package-agreements"
            "--accept-source-agreements"
            "--disable-interactivity"
        )

        $process = Start-Process -FilePath "winget.exe" -ArgumentList $wingetArgs -Wait -PassThru -NoNewWindow

        if ($process.ExitCode -eq 0) {
            Write-Host "[OK] $Nome instalado com sucesso." -ForegroundColor Green
            Write-Log "[OK] $Nome instalado com sucesso."
        }
        else {
            Write-Host "[ERRO] Falha ao instalar $Nome. Código: $($process.ExitCode)" -ForegroundColor Red
            Write-Log "[ERRO] Falha ao instalar $Nome. Código: $($process.ExitCode)"
        }
    }
    catch {
        $erro = $_.Exception.Message
        Write-Host ("[ERRO] Falha ao instalar {0}: {1}" -f $Nome, $erro) -ForegroundColor Red
        Write-Log ("[ERRO] Falha ao instalar {0}: {1}" -f $Nome, $erro)
    }
}

function Show-Menu {
    Clear-Host
    Write-Host "==============================================" -ForegroundColor Yellow
    Write-Host "   INSTALADOR PADRÃO DE SOFTWARES - WINDOWS   " -ForegroundColor Yellow
    Write-Host "==============================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1 - Instalar Google Chrome"
    Write-Host "2 - Instalar Adobe Acrobat Reader"
    Write-Host "3 - Instalar WinRAR"
    Write-Host "4 - Instalar 7-Zip"
    Write-Host "5 - Instalar TODOS"
    Write-Host "6 - Sair"
    Write-Host ""
    Write-Host "Log atual: $LogFile" -ForegroundColor DarkGray
    Write-Host ""
}

# Catálogo de aplicativos
$apps = @{
    "1" = @{ Nome = "Google Chrome";        Id = "Google.Chrome" }
    "2" = @{ Nome = "Adobe Acrobat Reader"; Id = "Adobe.Acrobat.Reader.64-bit" }
    "3" = @{ Nome = "WinRAR";               Id = "RARLab.WinRAR" }
    "4" = @{ Nome = "7-Zip";                Id = "7zip.7zip" }
}

try {
    Initialize-Log
    Write-Log "=================================================="
    Write-Log "Execução do script iniciada."

    if (-not (Test-Admin)) {
        Write-Host "Este script precisa ser executado como Administrador." -ForegroundColor Red
        Write-Host "Feche esta janela, abra o PowerShell como administrador e execute novamente." -ForegroundColor Yellow
        Write-Log "[ERRO] Script executado sem privilégios administrativos."
        Pause-Script
        exit 1
    }

    if (-not (Test-Winget)) {
        Write-Host "WinGet não foi encontrado neste Windows." -ForegroundColor Red
        Write-Host "Atualize o App Installer pela Microsoft Store ou valide se o winget está disponível nesta imagem." -ForegroundColor Yellow
        Write-Log "[ERRO] WinGet não encontrado."
        Pause-Script
        exit 1
    }

    do {
        Show-Menu
        $opcao = Read-Host "Escolha uma opção"

        switch ($opcao) {
            "1" {
                Install-App -Id $apps["1"].Id -Nome $apps["1"].Nome
                Pause-Script
            }
            "2" {
                Install-App -Id $apps["2"].Id -Nome $apps["2"].Nome
                Pause-Script
            }
            "3" {
                Install-App -Id $apps["3"].Id -Nome $apps["3"].Nome
                Pause-Script
            }
            "4" {
                Install-App -Id $apps["4"].Id -Nome $apps["4"].Nome
                Pause-Script
            }
            "5" {
                foreach ($key in @("1","2","3","4")) {
                    Install-App -Id $apps[$key].Id -Nome $apps[$key].Nome
                }
                Pause-Script
            }
            "6" {
                Write-Host "Encerrando..." -ForegroundColor Yellow
                Write-Log "Script encerrado pelo usuário."
            }
            default {
                Write-Host "Opção inválida." -ForegroundColor Red
                Write-Log "[AVISO] Opção inválida informada: $opcao"
                Start-Sleep -Seconds 1
            }
        }
    } until ($opcao -eq "6")
}
catch {
    $erroFinal = $_.Exception.Message
    Write-Host ("[ERRO FATAL] {0}" -f $erroFinal) -ForegroundColor Red
    Write-Log ("[ERRO FATAL] {0}" -f $erroFinal)
    Pause-Script
    exit 1
}
