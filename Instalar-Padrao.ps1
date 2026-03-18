# ============================================================
#  INSTALADOR PADRÃO DE SOFTWARES - WINDOWS
#  Criado por: José Carlos (Analista TI)
#  Requer: PowerShell como Administrador
#  Usa: WinGet
#  Log: C:\Temp\Instalador-Padrao.log
# ============================================================
#
#  EXECUÇÃO RÁPIDA VIA URL CURTA (Git):
#  irm https://SEU_LINK_CURTO | iex
#
#  Exemplo com GitHub raw:
#  irm https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPO/main/Instalador-Padrao.ps1 | iex
#
#  Para encurtar o link, use:
#  - https://git.io  (GitHub)
#  - https://tinyurl.com
#  - https://rb.gy
# ============================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = 'Stop'

$LogDir  = "C:\Temp"
$LogFile = Join-Path $LogDir "Instalador-Padrao.log"

# ─── Cores globais ───────────────────────────────────────────
$corFundo     = "Black"
$corTexto     = "Blue"
$corDestaque  = "Cyan"
$corNumero    = "White"
$corOK        = "Green"
$corErro      = "Red"
$corAviso     = "Yellow"
$corTitulo    = "DarkCyan"

# ─── Fundo azul escuro para toda a sessão ───────────────────
$host.UI.RawUI.BackgroundColor = $corFundo
$host.UI.RawUI.ForegroundColor = $corTexto
Clear-Host

# ─── Autenticação ────────────────────────────────────────────
$senhaMestra = "suroh"
$tentativas  = 0
$maxTentativas = 3

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor DarkBlue
Write-Host "  ║     ACESSO RESTRITO — HTi Soluções TI    ║" -ForegroundColor Blue
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor DarkBlue
Write-Host ""

do {
    $tentativas++
    $senhaSegura = Read-Host "  Senha de acesso" -AsSecureString
    $senhaTexto  = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                       [Runtime.InteropServices.Marshal]::SecureStringToBSTR($senhaSegura))

    if ($senhaTexto -eq $senhaMestra) {
        Write-Host ""
        Write-Host "  Acesso autorizado." -ForegroundColor Green
        Write-Host ""
        Start-Sleep -Seconds 1
        break
    }
    else {
        Write-Host "  Senha incorreta. Tentativa $tentativas de $maxTentativas." -ForegroundColor Red
        if ($tentativas -ge $maxTentativas) {
            Write-Host "  Número máximo de tentativas atingido. Encerrando." -ForegroundColor Red
            Start-Sleep -Seconds 2
            exit 1
        }
    }
} while ($tentativas -lt $maxTentativas)

# ─── Funções auxiliares ──────────────────────────────────────

function Initialize-Log {
    if (-not (Test-Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
    }
    if (-not (Test-Path $LogFile)) {
        New-Item -Path $LogFile -ItemType File -Force | Out-Null
    }
}

function Write-Log {
    param([string]$Message)
    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$timeStamp] $Message"
}

function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Winget {
    return $null -ne (Get-Command winget -ErrorAction SilentlyContinue)
}

function Pause-Script {
    Write-Host ""
    Read-Host "  Pressione ENTER para continuar"
}

function Write-Header {
    param([string]$Titulo)
    Write-Host ""
    Write-Host "  ══════════════════════════════════════════════" -ForegroundColor $corTitulo
    Write-Host "   $Titulo" -ForegroundColor $corDestaque
    Write-Host "  ══════════════════════════════════════════════" -ForegroundColor $corTitulo
}

# ─── Instalação de aplicativos ──────────────────────────────

function Install-App {
    param(
        [Parameter(Mandatory = $true)] [string]$Id,
        [Parameter(Mandatory = $true)] [string]$Nome
    )

    Write-Header "Instalando: $Nome"
    Write-Host "  Pacote : $Id" -ForegroundColor $corTexto
    Write-Log "Iniciando instalação de: $Nome ($Id)"

    try {
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
            Write-Host "  [OK] $Nome instalado com sucesso." -ForegroundColor $corOK
            Write-Log "[OK] $Nome instalado com sucesso."
        }
        else {
            Write-Host "  [ERRO] Falha ao instalar $Nome. Código: $($process.ExitCode)" -ForegroundColor $corErro
            Write-Log "[ERRO] Falha ao instalar $Nome. Código: $($process.ExitCode)"
        }
    }
    catch {
        $erro = $_.Exception.Message
        Write-Host ("  [ERRO] Falha ao instalar {0}: {1}" -f $Nome, $erro) -ForegroundColor $corErro
        Write-Log ("[ERRO] Falha ao instalar {0}: {1}" -f $Nome, $erro)
    }
}

# ─── Ativação Office / Windows ──────────────────────────────

function Show-ActivationTools {
    Write-Header "ATIVAÇÃO WINDOWS / OFFICE — Microsoft Activation Scripts"

    Write-Host "  Iniciando Microsoft Activation Scripts (MAS)..." -ForegroundColor $corTexto
    Write-Host "  Fonte: https://get.activated.win" -ForegroundColor DarkGray
    Write-Host ""

    try {
        Write-Log "Iniciando Microsoft Activation Scripts via get.activated.win"

        # Executa diretamente na mesma janela, sem abrir nova janela
        Invoke-Expression (Invoke-RestMethod -Uri "https://get.activated.win")

        Write-Log "[OK] MAS concluído."
    }
    catch {
        $erro = $_.Exception.Message
        Write-Host ("  [ERRO] Falha ao executar o ativador: {0}" -f $erro) -ForegroundColor $corErro
        Write-Host "  Tente executar manualmente: irm https://get.activated.win | iex" -ForegroundColor $corAviso
        Write-Log ("[ERRO] Falha ao executar MAS: {0}" -f $erro)
    }
}

# ─── Correções e manutenção do Windows ──────────────────────

function Show-MaintenanceMenu {
    do {
        Clear-Host
        Show-Banner
        Write-Header "MANUTENÇÃO E CORREÇÃO DO WINDOWS"
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "A" -ForegroundColor $corNumero -NoNewline; Write-Host " - Limpeza de Disco (cleanmgr)" -ForegroundColor $corTexto
        Write-Host "  " -NoNewline; Write-Host "B" -ForegroundColor $corNumero -NoNewline; Write-Host " - Verificar e reparar arquivos do sistema (SFC /scannow)" -ForegroundColor $corTexto
        Write-Host "  " -NoNewline; Write-Host "C" -ForegroundColor $corNumero -NoNewline; Write-Host " - Reparar imagem do Windows (DISM)" -ForegroundColor $corTexto
        Write-Host "  " -NoNewline; Write-Host "D" -ForegroundColor $corNumero -NoNewline; Write-Host " - Limpar pasta TEMP do usuário" -ForegroundColor $corTexto
        Write-Host "  " -NoNewline; Write-Host "E" -ForegroundColor $corNumero -NoNewline; Write-Host " - Liberar cache DNS" -ForegroundColor $corTexto
        Write-Host "  " -NoNewline; Write-Host "F" -ForegroundColor $corNumero -NoNewline; Write-Host " - Verificar e reparar disco (CHKDSK - requer reinício)" -ForegroundColor $corTexto
        Write-Host "  " -NoNewline; Write-Host "0" -ForegroundColor $corNumero -NoNewline; Write-Host " - Voltar ao menu principal" -ForegroundColor $corTexto
        Write-Host ""

        $sub = Read-Host "  Escolha uma opção"

        switch ($sub.ToUpper()) {
            "A" {
                Write-Header "Limpeza de Disco"
                Write-Host "  Iniciando o Limpador de Disco..." -ForegroundColor $corTexto
                Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
                Write-Log "Limpeza de disco executada."
                Pause-Script
            }
            "B" {
                Write-Header "Verificação de Arquivos do Sistema (SFC)"
                Write-Host "  Executando sfc /scannow — pode levar alguns minutos..." -ForegroundColor $corTexto
                Write-Log "Iniciando SFC /scannow."
                sfc /scannow
                Write-Log "SFC /scannow concluído."
                Pause-Script
            }
            "C" {
                Write-Header "Reparação de Imagem do Windows (DISM)"
                Write-Host "  Etapa 1/3 - CheckHealth..." -ForegroundColor $corTexto
                DISM /Online /Cleanup-Image /CheckHealth
                Write-Host "  Etapa 2/3 - ScanHealth..." -ForegroundColor $corTexto
                DISM /Online /Cleanup-Image /ScanHealth
                Write-Host "  Etapa 3/3 - RestoreHealth..." -ForegroundColor $corTexto
                DISM /Online /Cleanup-Image /RestoreHealth
                Write-Log "DISM RestoreHealth concluído."
                Pause-Script
            }
            "D" {
                Write-Header "Limpeza da Pasta TEMP"
                $tempPath = $env:TEMP
                Write-Host "  Limpando: $tempPath" -ForegroundColor $corTexto
                try {
                    Get-ChildItem -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue |
                        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Host "  [OK] Pasta TEMP limpa com sucesso." -ForegroundColor $corOK
                    Write-Log "Pasta TEMP limpa: $tempPath"
                }
                catch {
                    Write-Host "  [AVISO] Alguns arquivos estavam em uso e foram ignorados." -ForegroundColor $corAviso
                    Write-Log "Limpeza TEMP parcial (arquivos em uso ignorados)."
                }
                Pause-Script
            }
            "E" {
                Write-Header "Limpeza de Cache DNS"
                ipconfig /flushdns
                Write-Host "  [OK] Cache DNS liberado com sucesso." -ForegroundColor $corOK
                Write-Log "Cache DNS liberado."
                Pause-Script
            }
            "F" {
                Write-Header "Verificação de Disco (CHKDSK)"
                Write-Host "  O CHKDSK será agendado para o próximo reinício do sistema." -ForegroundColor $corAviso
                Write-Host "  (Isso não reiniciará o computador agora)" -ForegroundColor $corTexto
                $confirm = Read-Host "  Confirmar agendamento? (S/N)"
                if ($confirm -eq "S" -or $confirm -eq "s") {
                    chkdsk C: /f /r /x
                    Write-Log "CHKDSK agendado para C:."
                }
                Pause-Script
            }
            "0" { break }
            default {
                Write-Host "  Opção inválida." -ForegroundColor $corErro
                Start-Sleep -Seconds 1
            }
        }
    } until ($sub -eq "0")
}

# ─── Spooler de Impressão ────────────────────────────────────

function Restart-PrintSpooler {
    Write-Header "REINICIAR SPOOLER DE IMPRESSÃO"

    try {
        Write-Host "  Parando o serviço Spooler..." -ForegroundColor $corTexto
        Stop-Service -Name Spooler -Force -ErrorAction Stop
        Write-Log "Serviço Spooler parado."

        Write-Host "  Limpando fila de impressão..." -ForegroundColor $corTexto
        $spoolPath = "$env:SystemRoot\System32\spool\PRINTERS"
        if (Test-Path $spoolPath) {
            Get-ChildItem -Path $spoolPath -File -Force -ErrorAction SilentlyContinue |
                Remove-Item -Force -ErrorAction SilentlyContinue
            Write-Log "Fila de impressão limpa: $spoolPath"
        }

        Write-Host "  Iniciando o serviço Spooler..." -ForegroundColor $corTexto
        Start-Service -Name Spooler -ErrorAction Stop
        Write-Log "Serviço Spooler reiniciado com sucesso."

        $status = (Get-Service -Name Spooler).Status
        Write-Host "  [OK] Spooler reiniciado. Status atual: $status" -ForegroundColor $corOK
    }
    catch {
        $erro = $_.Exception.Message
        Write-Host ("  [ERRO] Falha ao reiniciar Spooler: {0}" -f $erro) -ForegroundColor $corErro
        Write-Log ("[ERRO] Falha ao reiniciar Spooler: {0}" -f $erro)
    }
}

# ─── Criar novo usuário local ────────────────────────────────

function New-LocalUserAccount {
    Write-Header "CRIAR NOVO USUÁRIO LOCAL"

    Write-Host "  Informe o nome do usuário ou pressione 0 para cancelar." -ForegroundColor $corTexto
    Write-Host "  A senha será definida como em branco e criada no primeiro acesso." -ForegroundColor $corTexto
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Host "0" -ForegroundColor $corNumero -NoNewline
    Write-Host " - Cancelar e voltar ao menu principal" -ForegroundColor $corAviso
    Write-Host ""

    $nomeUsuario = Read-Host "  Nome do usuário (sem espaços) ou 0 para cancelar"

    if ($nomeUsuario -eq "0") {
        Write-Host ""
        Write-Host "  Criação de usuário cancelada." -ForegroundColor $corAviso
        Write-Log "Criação de usuário cancelada pelo operador."
        return
    }

    if ([string]::IsNullOrWhiteSpace($nomeUsuario)) {
        Write-Host "  [ERRO] Nome de usuário não pode ser vazio." -ForegroundColor $corErro
        Write-Log "[ERRO] Tentativa de criar usuário com nome vazio."
        Pause-Script
        return
    }

    # Remove espaços e caracteres inválidos
    $nomeUsuario = $nomeUsuario -replace '\s+', '_'
    $nomeUsuario = $nomeUsuario -replace '[^\w\-]', ''

    if (Get-LocalUser -Name $nomeUsuario -ErrorAction SilentlyContinue) {
        Write-Host "  [AVISO] Usuário '$nomeUsuario' já existe no sistema." -ForegroundColor $corAviso
        Write-Log "[AVISO] Usuário '$nomeUsuario' já existe."
        Pause-Script
        return
    }

    try {
        # Cria o usuário com senha em branco e exige troca no primeiro logon
        $senhaVazia = [System.Security.SecureString]::new()
        New-LocalUser `
            -Name $nomeUsuario `
            -Password $senhaVazia `
            -FullName $nomeUsuario `
            -Description "Criado via Instalador Padrão - José Carlos (TI)" `
            -PasswordNeverExpires:$false `
            -UserMayNotChangePassword:$false `
            -AccountNeverExpires `
            -ErrorAction Stop

        # Adiciona ao grupo Usuários locais
        Add-LocalGroupMember -Group "Usuarios" -Member $nomeUsuario -ErrorAction SilentlyContinue
        Add-LocalGroupMember -Group "Users"    -Member $nomeUsuario -ErrorAction SilentlyContinue

        Write-Host ""
        Write-Host "  [OK] Usuário '$nomeUsuario' criado com sucesso." -ForegroundColor $corOK
        Write-Host "  O usuário deve definir uma senha no primeiro acesso." -ForegroundColor $corAviso
        Write-Log "[OK] Usuário '$nomeUsuario' criado com sucesso."
    }
    catch {
        $erro = $_.Exception.Message
        Write-Host ("  [ERRO] Falha ao criar usuário: {0}" -f $erro) -ForegroundColor $corErro
        Write-Log ("[ERRO] Falha ao criar usuário '$nomeUsuario': {0}" -f $erro)
    }
}

# ─── Banner / Cabeçalho ──────────────────────────────────────

function Show-Banner {
    Clear-Host
    $host.UI.RawUI.BackgroundColor = "Black"
    $host.UI.RawUI.ForegroundColor = "Gray"

    Write-Host ""

    # ── HTi em letras grandes ASCII ──────────────────────────
    #   H = DarkGray | t = DarkGray | i = Yellow (laranja)

    Write-Host "   " -NoNewline
    Write-Host "██   ██" -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host "██████" -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host " ██ " -ForegroundColor Yellow

    Write-Host "   " -NoNewline
    Write-Host "██   ██" -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host "  ██  " -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host "    " -ForegroundColor Yellow

    Write-Host "   " -NoNewline
    Write-Host "███████" -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host "  ██  " -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host " ██ " -ForegroundColor Yellow

    Write-Host "   " -NoNewline
    Write-Host "██   ██" -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host "  ██  " -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host " ██ " -ForegroundColor Yellow

    Write-Host "   " -NoNewline
    Write-Host "██   ██" -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host "██████" -ForegroundColor DarkGray -NoNewline
    Write-Host "   " -NoNewline
    Write-Host " ██ " -ForegroundColor Yellow

    Write-Host ""
    Write-Host "          " -NoNewline
    Write-Host "Solucoes em TI" -ForegroundColor Blue
    Write-Host ""

    # ── Título principal ─────────────────────────────────────
    Write-Host "  ╔════════════════════════════════════════════════╗" -ForegroundColor DarkBlue
    Write-Host "  ║" -ForegroundColor DarkBlue -NoNewline
    Write-Host "   INSTALADOR PADRÃO DE SOFTWARES - WINDOWS    " -ForegroundColor Blue -NoNewline
    Write-Host "  ║" -ForegroundColor DarkBlue
    Write-Host "  ║" -ForegroundColor DarkBlue -NoNewline
    Write-Host "       Criado por: José Carlos (Analista TI)    " -ForegroundColor Cyan -NoNewline
    Write-Host "  ║" -ForegroundColor DarkBlue
    Write-Host "  ╚════════════════════════════════════════════════╝" -ForegroundColor DarkBlue
    Write-Host ""
}

# ─── Menu principal ──────────────────────────────────────────

$apps = @{
    "1" = @{ Nome = "Google Chrome";        Id = "Google.Chrome" }
    "2" = @{ Nome = "Adobe Acrobat Reader"; Id = "Adobe.Acrobat.Reader.64-bit" }
    "3" = @{ Nome = "WinRAR";               Id = "RARLab.WinRAR" }
    "4" = @{ Nome = "7-Zip";                Id = "7zip.7zip" }
}

function Show-Menu {
    Clear-Host
    $host.UI.RawUI.BackgroundColor = $corFundo
    $host.UI.RawUI.ForegroundColor = $corTexto

    Show-Banner

    Write-Host "  ── INSTALAÇÃO DE SOFTWARES ──────────────────" -ForegroundColor $corTitulo
    Write-Host "  " -NoNewline; Write-Host "1" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar Google Chrome"        -ForegroundColor $corTexto
    Write-Host "  " -NoNewline; Write-Host "2" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar Adobe Acrobat Reader" -ForegroundColor $corTexto
    Write-Host "  " -NoNewline; Write-Host "3" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar WinRAR"               -ForegroundColor $corTexto
    Write-Host "  " -NoNewline; Write-Host "4" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar 7-Zip"                -ForegroundColor $corTexto
    Write-Host "  " -NoNewline; Write-Host "5" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar TODOS"                -ForegroundColor $corTexto
    Write-Host ""
    Write-Host "  ── SISTEMA ──────────────────────────────────" -ForegroundColor $corTitulo
    Write-Host "  " -NoNewline; Write-Host "6" -ForegroundColor $corNumero -NoNewline; Write-Host " - Ativação Office / Windows (oficial)"    -ForegroundColor $corTexto
    Write-Host "  " -NoNewline; Write-Host "7" -ForegroundColor $corNumero -NoNewline; Write-Host " - Manutenção e Correção do Windows"        -ForegroundColor $corTexto
    Write-Host "  " -NoNewline; Write-Host "8" -ForegroundColor $corNumero -NoNewline; Write-Host " - Reiniciar Spooler de Impressão"          -ForegroundColor $corTexto
    Write-Host "  " -NoNewline; Write-Host "9" -ForegroundColor $corNumero -NoNewline; Write-Host " - Criar Novo Usuário Local"                -ForegroundColor $corTexto
    Write-Host ""
    Write-Host "  ── SAIR ─────────────────────────────────────" -ForegroundColor $corTitulo
    Write-Host "  " -NoNewline; Write-Host "0" -ForegroundColor $corNumero -NoNewline; Write-Host " - Sair"                                    -ForegroundColor $corTexto
    Write-Host ""
    Write-Host "  Log: $LogFile" -ForegroundColor DarkGray
    Write-Host ""
}

# ─── Execução principal ──────────────────────────────────────

try {
    Initialize-Log
    Write-Log "=================================================="
    Write-Log "Execução do script iniciada."

    if (-not (Test-Admin)) {
        Write-Host "  Este script precisa ser executado como Administrador." -ForegroundColor $corErro
        Write-Host "  Feche e abra o PowerShell como Administrador." -ForegroundColor $corAviso
        Write-Log "[ERRO] Script executado sem privilégios administrativos."
        Pause-Script
        exit 1
    }

    if (-not (Test-Winget)) {
        Write-Host "  WinGet não foi encontrado neste Windows." -ForegroundColor $corErro
        Write-Host "  Atualize o App Installer pela Microsoft Store." -ForegroundColor $corAviso
        Write-Log "[ERRO] WinGet não encontrado."
        Pause-Script
        exit 1
    }

    do {
        Show-Menu
        $opcao = Read-Host "  Escolha uma opção"

        switch ($opcao) {
            "1" { Install-App -Id $apps["1"].Id -Nome $apps["1"].Nome; Pause-Script }
            "2" { Install-App -Id $apps["2"].Id -Nome $apps["2"].Nome; Pause-Script }
            "3" { Install-App -Id $apps["3"].Id -Nome $apps["3"].Nome; Pause-Script }
            "4" { Install-App -Id $apps["4"].Id -Nome $apps["4"].Nome; Pause-Script }
            "5" {
                foreach ($key in @("1","2","3","4")) {
                    Install-App -Id $apps[$key].Id -Nome $apps[$key].Nome
                }
                Pause-Script
            }
            "6" { Show-ActivationTools; Pause-Script }
            "7" { Show-MaintenanceMenu }
            "8" { Restart-PrintSpooler; Pause-Script }
            "9" { New-LocalUserAccount; Pause-Script }
            "0" {
                Write-Host ""
                Write-Host "  Encerrando e limpando histórico..." -ForegroundColor $corAviso
                Write-Log "Script encerrado pelo usuário."

                # Limpa o histórico da sessão PowerShell
                try {
                    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
                } catch {}
                try {
                    Clear-History -ErrorAction SilentlyContinue
                } catch {}

                # Apaga o arquivo de histórico permanente do PSReadLine
                $histFile = (Get-PSReadLineOption).HistorySavePath
                if ($histFile -and (Test-Path $histFile)) {
                    Clear-Content -Path $histFile -ErrorAction SilentlyContinue
                }

                # Restaura cores e limpa tela
                $host.UI.RawUI.BackgroundColor = "Black"
                $host.UI.RawUI.ForegroundColor = "Gray"
                Clear-Host
            }
            default {
                Write-Host "  Opção inválida." -ForegroundColor $corErro
                Write-Log "[AVISO] Opção inválida: $opcao"
                Start-Sleep -Seconds 1
            }
        }
    } until ($opcao -eq "0")
}
catch {
    $erroFinal = $_.Exception.Message
    Write-Host ("  [ERRO FATAL] {0}" -f $erroFinal) -ForegroundColor $corErro
    Write-Log ("[ERRO FATAL] {0}" -f $erroFinal)
    Pause-Script
    exit 1
}
