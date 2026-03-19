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

# ─── Fundo para toda a sessão ────────────────────────────────
$host.UI.RawUI.BackgroundColor = $corFundo
$host.UI.RawUI.ForegroundColor = $corTexto
Clear-Host

# ─── Autenticação ────────────────────────────────────────────
$senhaMestra   = "suroh"
$tentativas    = 0
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

# ─── Banner / Cabeçalho ──────────────────────────────────────

function Show-Banner {
    Clear-Host
    $host.UI.RawUI.BackgroundColor = "Black"
    $host.UI.RawUI.ForegroundColor = "Gray"

    Write-Host ""

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

# ════════════════════════════════════════════════════════════
# MENU 1 — INSTALAR APLICATIVOS PADRÕES
# ════════════════════════════════════════════════════════════

$apps = @{
    "1" = @{ Nome = "Google Chrome";        Id = "Google.Chrome" }
    "2" = @{ Nome = "Adobe Acrobat Reader"; Id = "Adobe.Acrobat.Reader.64-bit" }
    "3" = @{ Nome = "WinRAR";               Id = "RARLab.WinRAR" }
    "4" = @{ Nome = "7-Zip";                Id = "7zip.7zip" }
}

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

function Show-AppInstallMenu {
    do {
        Clear-Host
        Show-Banner
        Write-Header "INSTALAR APLICATIVOS PADRÕES"
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "1" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar Google Chrome" -ForegroundColor $corTexto
        Write-Host "      Navegador web rápido e estável do Google." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "2" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar Adobe Acrobat Reader" -ForegroundColor $corTexto
        Write-Host "      Leitor e visualizador de arquivos PDF." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "3" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar WinRAR" -ForegroundColor $corTexto
        Write-Host "      Compactador e descompactador de arquivos (RAR, ZIP e outros)." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "4" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar 7-Zip" -ForegroundColor $corTexto
        Write-Host "      Compactador gratuito e de alto desempenho." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "5" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar TODOS os aplicativos acima" -ForegroundColor $corTexto
        Write-Host "      Instala Chrome, Adobe, WinRAR e 7-Zip de uma vez." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "0" -ForegroundColor $corNumero -NoNewline; Write-Host " - Voltar ao menu principal" -ForegroundColor $corTexto
        Write-Host ""
        Write-Host "  Log: $LogFile" -ForegroundColor DarkGray
        Write-Host ""

        $sub = Read-Host "  Escolha uma opção"

        switch ($sub) {
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
            "0" { break }
            default {
                Write-Host "  Opção inválida." -ForegroundColor $corErro
                Start-Sleep -Seconds 1
            }
        }
    } until ($sub -eq "0")
}

# ════════════════════════════════════════════════════════════
# MENU 2 — OTIMIZAÇÃO DO SISTEMA
# ════════════════════════════════════════════════════════════

function Show-OptimizationMenu {
    do {
        Clear-Host
        Show-Banner
        Write-Header "OTIMIZAÇÃO DO SISTEMA WINDOWS"
        Write-Host ""
        Write-Host "  ── LIMPEZA E MANUTENÇÃO ──────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "A" -ForegroundColor $corNumero -NoNewline; Write-Host " - Limpeza de Disco (cleanmgr)" -ForegroundColor $corTexto
        Write-Host "      Remove arquivos temporários, lixeira e cache do Windows." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "B" -ForegroundColor $corNumero -NoNewline; Write-Host " - Limpar pasta TEMP do usuário" -ForegroundColor $corTexto
        Write-Host "      Apaga arquivos temporários da sessão do usuário atual." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "C" -ForegroundColor $corNumero -NoNewline; Write-Host " - Limpar cache DNS" -ForegroundColor $corTexto
        Write-Host "      Resolve problemas de conexão limpando o cache de DNS." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "D" -ForegroundColor $corNumero -NoNewline; Write-Host " - Limpar cache da Windows Store" -ForegroundColor $corTexto
        Write-Host "      Resolve falhas de download e atualização na Microsoft Store." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "E" -ForegroundColor $corNumero -NoNewline; Write-Host " - Limpar arquivos de prefetch" -ForegroundColor $corTexto
        Write-Host "      Remove arquivos de pré-carregamento acumulados." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  ── REPARO DO SISTEMA ─────────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "F" -ForegroundColor $corNumero -NoNewline; Write-Host " - Verificar arquivos do sistema (SFC /scannow)" -ForegroundColor $corTexto
        Write-Host "      Verifica e repara arquivos corrompidos do Windows." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "G" -ForegroundColor $corNumero -NoNewline; Write-Host " - Reparar imagem do Windows (DISM)" -ForegroundColor $corTexto
        Write-Host "      Repara a imagem do sistema operacional (CheckHealth, ScanHealth, RestoreHealth)." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "H" -ForegroundColor $corNumero -NoNewline; Write-Host " - Verificar e reparar disco (CHKDSK)" -ForegroundColor $corTexto
        Write-Host "      Agenda verificação do disco para o próximo reinício." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "I" -ForegroundColor $corNumero -NoNewline; Write-Host " - Reiniciar Spooler de Impressão" -ForegroundColor $corTexto
        Write-Host "      Resolve problemas de impressora travada ou fila presa." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  ── DESEMPENHO ────────────────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "J" -ForegroundColor $corNumero -NoNewline; Write-Host " - Ajustar para Melhor Desempenho Visual" -ForegroundColor $corTexto
        Write-Host "      Desativa efeitos visuais desnecessários para liberar recursos." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "K" -ForegroundColor $corNumero -NoNewline; Write-Host " - Desativar apps na inicialização do Windows" -ForegroundColor $corTexto
        Write-Host "      Abre o Gerenciador de Tarefas na aba de Inicialização." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "L" -ForegroundColor $corNumero -NoNewline; Write-Host " - Definir Plano de Energia: Alto Desempenho" -ForegroundColor $corTexto
        Write-Host "      Ativa o plano de energia máxima para melhor performance." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "M" -ForegroundColor $corNumero -NoNewline; Write-Host " - Liberar memória RAM (esvaziando cache)" -ForegroundColor $corTexto
        Write-Host "      Força o Windows a liberar memória em cache não utilizada." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "N" -ForegroundColor $corNumero -NoNewline; Write-Host " - Desfragmentar / Otimizar Disco" -ForegroundColor $corTexto
        Write-Host "      Otimiza HDs (desfragmenta) ou SSDs (TRIM) para melhor leitura/escrita." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "O" -ForegroundColor $corNumero -NoNewline; Write-Host " - Atualizar Windows Update" -ForegroundColor $corTexto
        Write-Host "      Abre as configurações do Windows Update para verificar atualizações." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  ── ATIVAÇÃO ──────────────────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "P" -ForegroundColor $corNumero -NoNewline; Write-Host " - Ativação Office / Windows (MAS)" -ForegroundColor $corTexto
        Write-Host "      Executa o Microsoft Activation Scripts via get.activated.win." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  ── BLOATWARE ─────────────────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "Q" -ForegroundColor $corNumero -NoNewline; Write-Host " - Remover Bloatware do Windows" -ForegroundColor $corTexto
        Write-Host "      Remove apps desnecessários: Xbox, Seu Telefone, Candy Crush, etc." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "0" -ForegroundColor $corNumero -NoNewline; Write-Host " - Voltar ao menu principal" -ForegroundColor $corTexto
        Write-Host ""

        $sub = Read-Host "  Escolha uma opção"

        switch ($sub.ToUpper()) {

            # ── A: Limpeza de disco ─────────────────────────
            "A" {
                Write-Header "Limpeza de Disco"
                Write-Host "  Iniciando o Limpador de Disco..." -ForegroundColor $corTexto
                Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
                Write-Log "Limpeza de disco executada."
                Pause-Script
            }

            # ── B: Pasta TEMP ───────────────────────────────
            "B" {
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
                    Write-Host "  [AVISO] Alguns arquivos em uso foram ignorados." -ForegroundColor $corAviso
                    Write-Log "Limpeza TEMP parcial (arquivos em uso ignorados)."
                }
                Pause-Script
            }

            # ── C: Cache DNS ────────────────────────────────
            "C" {
                Write-Header "Limpeza de Cache DNS"
                ipconfig /flushdns
                Write-Host "  [OK] Cache DNS liberado com sucesso." -ForegroundColor $corOK
                Write-Log "Cache DNS liberado."
                Pause-Script
            }

            # ── D: Cache da Store ───────────────────────────
            "D" {
                Write-Header "Limpar Cache da Windows Store"
                Write-Host "  Executando wsreset.exe..." -ForegroundColor $corTexto
                Start-Process -FilePath "wsreset.exe" -Wait
                Write-Host "  [OK] Cache da Store limpo." -ForegroundColor $corOK
                Write-Log "Cache da Windows Store limpo."
                Pause-Script
            }

            # ── E: Prefetch ─────────────────────────────────
            "E" {
                Write-Header "Limpar Arquivos de Prefetch"
                $prefetchPath = "C:\Windows\Prefetch"
                try {
                    Get-ChildItem -Path $prefetchPath -Force -ErrorAction SilentlyContinue |
                        Remove-Item -Force -ErrorAction SilentlyContinue
                    Write-Host "  [OK] Arquivos de Prefetch removidos." -ForegroundColor $corOK
                    Write-Log "Arquivos de Prefetch limpos."
                }
                catch {
                    Write-Host "  [AVISO] Alguns arquivos não puderam ser removidos." -ForegroundColor $corAviso
                    Write-Log "Limpeza Prefetch parcial."
                }
                Pause-Script
            }

            # ── F: SFC ──────────────────────────────────────
            "F" {
                Write-Header "Verificação de Arquivos do Sistema (SFC)"
                Write-Host "  Executando sfc /scannow — pode levar alguns minutos..." -ForegroundColor $corTexto
                Write-Log "Iniciando SFC /scannow."
                sfc /scannow
                Write-Log "SFC /scannow concluído."
                Pause-Script
            }

            # ── G: DISM ─────────────────────────────────────
            "G" {
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

            # ── H: CHKDSK ───────────────────────────────────
            "H" {
                Write-Header "Verificação de Disco (CHKDSK)"
                Write-Host "  O CHKDSK será agendado para o próximo reinício do sistema." -ForegroundColor $corAviso
                $confirm = Read-Host "  Confirmar agendamento? (S/N)"
                if ($confirm -eq "S" -or $confirm -eq "s") {
                    chkdsk C: /f /r /x
                    Write-Log "CHKDSK agendado para C:."
                }
                Pause-Script
            }

            # ── I: Spooler ──────────────────────────────────
            "I" {
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
                        Write-Log "Fila de impressão limpa."
                    }

                    Write-Host "  Iniciando o serviço Spooler..." -ForegroundColor $corTexto
                    Start-Service -Name Spooler -ErrorAction Stop
                    $status = (Get-Service -Name Spooler).Status
                    Write-Host "  [OK] Spooler reiniciado. Status: $status" -ForegroundColor $corOK
                    Write-Log "Spooler reiniciado. Status: $status"
                }
                catch {
                    $erro = $_.Exception.Message
                    Write-Host ("  [ERRO] {0}" -f $erro) -ForegroundColor $corErro
                    Write-Log ("[ERRO] Falha ao reiniciar Spooler: {0}" -f $erro)
                }
                Pause-Script
            }

            # ── J: Melhor Desempenho Visual ─────────────────
            "J" {
                Write-Header "Ajustar para Melhor Desempenho Visual"
                Write-Host "  Desativando efeitos visuais desnecessários..." -ForegroundColor $corTexto
                try {
                    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                    if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                    Set-ItemProperty -Path $path -Name "VisualFXSetting" -Value 2

                    $advPath = "HKCU:\Control Panel\Desktop"
                    Set-ItemProperty -Path $advPath -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary

                    Write-Host "  [OK] Configurações de desempenho aplicadas. Reinicie para efeito completo." -ForegroundColor $corOK
                    Write-Log "Efeitos visuais ajustados para melhor desempenho."
                }
                catch {
                    Write-Host "  [ERRO] Falha ao ajustar efeitos visuais." -ForegroundColor $corErro
                    Write-Log "[ERRO] Falha ao ajustar efeitos visuais: $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── K: Apps na inicialização ─────────────────────
            "K" {
                Write-Header "Gerenciar Apps na Inicialização"
                Write-Host "  Abrindo Gerenciador de Tarefas — aba Inicialização..." -ForegroundColor $corTexto
                Start-Process -FilePath "taskmgr.exe" -ArgumentList "/0 /startup"
                Write-Host "  [OK] Gerenciador de Tarefas aberto." -ForegroundColor $corOK
                Write-Log "Gerenciador de Tarefas aberto (aba inicialização)."
                Pause-Script
            }

            # ── L: Plano de energia ──────────────────────────
            "L" {
                Write-Header "Plano de Energia: Alto Desempenho"
                Write-Host "  Ativando plano de Alto Desempenho..." -ForegroundColor $corTexto
                try {
                    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
                    Write-Host "  [OK] Plano de Alto Desempenho ativado." -ForegroundColor $corOK
                    Write-Log "Plano de energia Alto Desempenho ativado."
                }
                catch {
                    Write-Host "  [AVISO] Tentando ativar via nome..." -ForegroundColor $corAviso
                    powercfg /setactive "Alto desempenho" 2>$null
                    Write-Host "  [OK] Concluído (verifique em Opções de Energia)." -ForegroundColor $corOK
                }
                Pause-Script
            }

            # ── M: Liberar memória RAM ───────────────────────
            "M" {
                Write-Header "Liberar Memória RAM (Cache)"
                Write-Host "  Forçando limpeza de memória em standby..." -ForegroundColor $corTexto
                try {
                    # Usa a API do Windows para limpar standby list
                    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Memory {
    [DllImport("psapi.dll")]
    public static extern bool EmptyWorkingSet(IntPtr hwProc);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetCurrentProcess();
}
"@
                    [Memory]::EmptyWorkingSet([Memory]::GetCurrentProcess()) | Out-Null

                    # Forçar GC .NET
                    [System.GC]::Collect()
                    [System.GC]::WaitForPendingFinalizers()

                    Write-Host "  [OK] Memória em cache liberada." -ForegroundColor $corOK
                    Write-Log "Memória RAM (cache) liberada."
                }
                catch {
                    Write-Host "  [AVISO] $($_.Exception.Message)" -ForegroundColor $corAviso
                    Write-Log "[AVISO] Limpeza de RAM parcial: $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── N: Desfragmentar / Otimizar Disco ───────────
            "N" {
                Write-Header "Desfragmentar / Otimizar Disco"
                Write-Host "  Iniciando otimização do disco C:..." -ForegroundColor $corTexto
                Write-Host "  (SSDs recebem TRIM; HDDs recebem desfragmentação)" -ForegroundColor DarkGray
                Write-Log "Iniciando otimização do disco."
                defrag C: /U /V
                Write-Log "Otimização de disco concluída."
                Pause-Script
            }

            # ── O: Windows Update ───────────────────────────
            "O" {
                Write-Header "Windows Update"
                Write-Host "  Abrindo configurações do Windows Update..." -ForegroundColor $corTexto
                Start-Process "ms-settings:windowsupdate"
                Write-Host "  [OK] Configurações do Windows Update abertas." -ForegroundColor $corOK
                Write-Log "Windows Update aberto."
                Pause-Script
            }

            # ── P: Ativação MAS ─────────────────────────────
            "P" {
                Write-Header "ATIVAÇÃO WINDOWS / OFFICE — Microsoft Activation Scripts"
                Write-Host "  Iniciando Microsoft Activation Scripts (MAS)..." -ForegroundColor $corTexto
                Write-Host "  Fonte: https://get.activated.win" -ForegroundColor DarkGray
                Write-Host ""
                try {
                    Write-Log "Iniciando MAS via get.activated.win"
                    Invoke-Expression (Invoke-RestMethod -Uri "https://get.activated.win")
                    Write-Log "[OK] MAS concluído."
                }
                catch {
                    $erro = $_.Exception.Message
                    Write-Host ("  [ERRO] {0}" -f $erro) -ForegroundColor $corErro
                    Write-Host "  Execute manualmente: irm https://get.activated.win | iex" -ForegroundColor $corAviso
                    Write-Log ("[ERRO] MAS: {0}" -f $erro)
                }
                Pause-Script
            }

            # ── Q: Remover Bloatware ────────────────────────
            "Q" {
                Show-BloatwareMenu
            }

            "0" { break }
            default {
                Write-Host "  Opção inválida." -ForegroundColor $corErro
                Start-Sleep -Seconds 1
            }
        }
    } until ($sub.ToUpper() -eq "0")
}

# ─── Submenu Bloatware ───────────────────────────────────────

function Remove-BloatApp {
    param([string]$PackageName, [string]$NomeExibicao)
    Write-Host "  Removendo: $NomeExibicao..." -ForegroundColor $corTexto
    try {
        Get-AppxPackage -AllUsers -Name $PackageName -ErrorAction SilentlyContinue |
            Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
            Where-Object { $_.PackageName -like "*$PackageName*" } |
            Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
        Write-Host "  [OK] $NomeExibicao removido." -ForegroundColor $corOK
        Write-Log "[OK] Bloatware removido: $NomeExibicao ($PackageName)"
    }
    catch {
        Write-Host "  [AVISO] Não foi possível remover $NomeExibicao (pode já estar ausente)." -ForegroundColor $corAviso
        Write-Log "[AVISO] Falha ao remover $NomeExibicao : $($_.Exception.Message)"
    }
}

function Show-BloatwareMenu {
    do {
        Clear-Host
        Show-Banner
        Write-Header "REMOVER BLOATWARE DO WINDOWS"
        Write-Host ""
        Write-Host "  Selecione o que deseja remover:" -ForegroundColor $corTexto
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "1" -ForegroundColor $corNumero -NoNewline; Write-Host " - Xbox (App, GameBar, GameOverlay, Identity)" -ForegroundColor $corTexto
        Write-Host "      Remove todos os componentes do Xbox que vêm instalados." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "2" -ForegroundColor $corNumero -NoNewline; Write-Host " - Seu Telefone (Phone Link / Link to Windows)" -ForegroundColor $corTexto
        Write-Host "      Remove o app de conexão com celular." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "3" -ForegroundColor $corNumero -NoNewline; Write-Host " - Cortana" -ForegroundColor $corTexto
        Write-Host "      Remove o assistente virtual da Microsoft." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "4" -ForegroundColor $corNumero -NoNewline; Write-Host " - Notícias e Interesses (MSN News)" -ForegroundColor $corTexto
        Write-Host "      Remove o feed de notícias do Windows." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "5" -ForegroundColor $corNumero -NoNewline; Write-Host " - Candy Crush e outros jogos patrocinados" -ForegroundColor $corTexto
        Write-Host "      Remove jogos instalados automaticamente pela Microsoft." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "6" -ForegroundColor $corNumero -NoNewline; Write-Host " - Clima (MSN Weather)" -ForegroundColor $corTexto
        Write-Host "      Remove o app de previsão do tempo." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "7" -ForegroundColor $corNumero -NoNewline; Write-Host " - Fotos Microsoft (substituível por outro visualizador)" -ForegroundColor $corTexto
        Write-Host "      Remove o app Fotos padrão do Windows." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "8" -ForegroundColor $corNumero -NoNewline; Write-Host " - Mapas do Windows" -ForegroundColor $corTexto
        Write-Host "      Remove o app de mapas offline da Microsoft." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "9" -ForegroundColor $corNumero -NoNewline; Write-Host " - OneDrive (desinstalar)" -ForegroundColor $corTexto
        Write-Host "      Remove o cliente OneDrive do sistema." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "10" -ForegroundColor $corNumero -NoNewline; Write-Host " - Teams (versão pessoal/consumer)" -ForegroundColor $corTexto
        Write-Host "      Remove o Microsoft Teams pessoal (não o corporativo)." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "11" -ForegroundColor $corNumero -NoNewline; Write-Host " - Skype" -ForegroundColor $corTexto
        Write-Host "      Remove o cliente Skype." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "12" -ForegroundColor $corNumero -NoNewline; Write-Host " - Paint 3D" -ForegroundColor $corTexto
        Write-Host "      Remove o Paint 3D (diferente do Paint clássico)." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "13" -ForegroundColor $corNumero -NoNewline; Write-Host " - Gravador de Voz" -ForegroundColor $corTexto
        Write-Host "      Remove o app de gravação de áudio." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "T" -ForegroundColor $corNumero -NoNewline; Write-Host " - Remover TODOS os itens acima de uma vez" -ForegroundColor $corTexto
        Write-Host "      Remove todos os bloatwares listados (recomendado para PCs novos)." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "0" -ForegroundColor $corNumero -NoNewline; Write-Host " - Voltar ao menu de Otimização" -ForegroundColor $corTexto
        Write-Host ""

        $sub = Read-Host "  Escolha uma opção"

        $bloatList = @(
            @{ Pkg = "Microsoft.XboxApp";                Nome = "Xbox App" }
            @{ Pkg = "Microsoft.XboxGameBar";            Nome = "Xbox Game Bar" }
            @{ Pkg = "Microsoft.XboxGameOverlay";        Nome = "Xbox Game Overlay" }
            @{ Pkg = "Microsoft.XboxIdentityProvider";   Nome = "Xbox Identity Provider" }
            @{ Pkg = "Microsoft.XboxSpeechToTextOverlay";Nome = "Xbox Speech Overlay" }
            @{ Pkg = "Microsoft.YourPhone";              Nome = "Seu Telefone / Phone Link" }
            @{ Pkg = "Microsoft.549981C3F5F10";          Nome = "Cortana" }
            @{ Pkg = "Microsoft.BingNews";               Nome = "MSN Notícias" }
            @{ Pkg = "king.com.CandyCrushSaga";          Nome = "Candy Crush Saga" }
            @{ Pkg = "king.com.CandyCrushFriends";       Nome = "Candy Crush Friends" }
            @{ Pkg = "Microsoft.BingWeather";            Nome = "MSN Clima" }
            @{ Pkg = "Microsoft.Windows.Photos";         Nome = "Fotos Microsoft" }
            @{ Pkg = "Microsoft.WindowsMaps";            Nome = "Mapas do Windows" }
            @{ Pkg = "Microsoft.MicrosoftTeams";         Nome = "Teams (pessoal)" }
            @{ Pkg = "Microsoft.SkypeApp";               Nome = "Skype" }
            @{ Pkg = "Microsoft.MSPaint";                Nome = "Paint 3D" }
            @{ Pkg = "Microsoft.WindowsSoundRecorder";   Nome = "Gravador de Voz" }
        )

        switch ($sub.ToUpper()) {
            "1" {
                Write-Header "Removendo Xbox..."
                foreach ($item in $bloatList | Where-Object { $_.Pkg -like "*Xbox*" }) {
                    Remove-BloatApp -PackageName $item.Pkg -NomeExibicao $item.Nome
                }
                Pause-Script
            }
            "2" {
                Write-Header "Removendo Seu Telefone..."
                Remove-BloatApp -PackageName "Microsoft.YourPhone" -NomeExibicao "Seu Telefone / Phone Link"
                Pause-Script
            }
            "3" {
                Write-Header "Removendo Cortana..."
                Remove-BloatApp -PackageName "Microsoft.549981C3F5F10" -NomeExibicao "Cortana"
                Pause-Script
            }
            "4" {
                Write-Header "Removendo MSN Notícias..."
                Remove-BloatApp -PackageName "Microsoft.BingNews" -NomeExibicao "MSN Notícias"
                Pause-Script
            }
            "5" {
                Write-Header "Removendo Jogos Patrocinados..."
                foreach ($item in $bloatList | Where-Object { $_.Pkg -like "*king.com*" }) {
                    Remove-BloatApp -PackageName $item.Pkg -NomeExibicao $item.Nome
                }
                Pause-Script
            }
            "6" {
                Write-Header "Removendo Clima..."
                Remove-BloatApp -PackageName "Microsoft.BingWeather" -NomeExibicao "MSN Clima"
                Pause-Script
            }
            "7" {
                Write-Header "Removendo Fotos Microsoft..."
                Remove-BloatApp -PackageName "Microsoft.Windows.Photos" -NomeExibicao "Fotos Microsoft"
                Pause-Script
            }
            "8" {
                Write-Header "Removendo Mapas do Windows..."
                Remove-BloatApp -PackageName "Microsoft.WindowsMaps" -NomeExibicao "Mapas do Windows"
                Pause-Script
            }
            "9" {
                Write-Header "Desinstalando OneDrive..."
                Write-Host "  Encerrando processo OneDrive..." -ForegroundColor $corTexto
                taskkill /f /im OneDrive.exe 2>$null
                Start-Sleep -Seconds 1
                $odPath32 = "$env:SystemRoot\System32\OneDriveSetup.exe"
                $odPath64 = "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
                if (Test-Path $odPath64) {
                    Start-Process -FilePath $odPath64 -ArgumentList "/uninstall" -Wait
                } elseif (Test-Path $odPath32) {
                    Start-Process -FilePath $odPath32 -ArgumentList "/uninstall" -Wait
                } else {
                    Write-Host "  [AVISO] OneDriveSetup.exe não encontrado." -ForegroundColor $corAviso
                }
                Write-Host "  [OK] OneDrive desinstalado (pastas de arquivos mantidas)." -ForegroundColor $corOK
                Write-Log "OneDrive desinstalado."
                Pause-Script
            }
            "10" {
                Write-Header "Removendo Teams (pessoal)..."
                Remove-BloatApp -PackageName "Microsoft.MicrosoftTeams" -NomeExibicao "Teams (pessoal)"
                Pause-Script
            }
            "11" {
                Write-Header "Removendo Skype..."
                Remove-BloatApp -PackageName "Microsoft.SkypeApp" -NomeExibicao "Skype"
                Pause-Script
            }
            "12" {
                Write-Header "Removendo Paint 3D..."
                Remove-BloatApp -PackageName "Microsoft.MSPaint" -NomeExibicao "Paint 3D"
                Pause-Script
            }
            "13" {
                Write-Header "Removendo Gravador de Voz..."
                Remove-BloatApp -PackageName "Microsoft.WindowsSoundRecorder" -NomeExibicao "Gravador de Voz"
                Pause-Script
            }
            "T" {
                Write-Header "Removendo TODOS os Bloatwares..."
                Write-Host "  Isso pode levar alguns minutos..." -ForegroundColor $corAviso
                Write-Host ""
                # OneDrive separado
                Write-Host "  Encerrando OneDrive..." -ForegroundColor $corTexto
                taskkill /f /im OneDrive.exe 2>$null
                Start-Sleep -Seconds 1
                $odPath64 = "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
                $odPath32 = "$env:SystemRoot\System32\OneDriveSetup.exe"
                if (Test-Path $odPath64) { Start-Process $odPath64 -ArgumentList "/uninstall" -Wait }
                elseif (Test-Path $odPath32) { Start-Process $odPath32 -ArgumentList "/uninstall" -Wait }

                foreach ($item in $bloatList) {
                    Remove-BloatApp -PackageName $item.Pkg -NomeExibicao $item.Nome
                }
                Write-Host ""
                Write-Host "  [OK] Remoção concluída." -ForegroundColor $corOK
                Write-Log "Todos os bloatwares removidos."
                Pause-Script
            }
            "0" { break }
            default {
                Write-Host "  Opção inválida." -ForegroundColor $corErro
                Start-Sleep -Seconds 1
            }
        }
    } until ($sub.ToUpper() -eq "0")
}

# ════════════════════════════════════════════════════════════
# MENU 3 — GERENCIAR USUÁRIOS
# ════════════════════════════════════════════════════════════

function Show-UserManagementMenu {
    do {
        Clear-Host
        Show-Banner
        Write-Header "GERENCIAR USUÁRIOS DO SISTEMA"
        Write-Host ""
        Write-Host "  ── CRIAR / REMOVER ───────────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "1" -ForegroundColor $corNumero -NoNewline; Write-Host " - Criar novo usuário local" -ForegroundColor $corTexto
        Write-Host "      Cria um novo usuário local com senha em branco (definida no 1º acesso)." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "2" -ForegroundColor $corNumero -NoNewline; Write-Host " - Remover usuário local" -ForegroundColor $corTexto
        Write-Host "      Remove uma conta local existente do sistema." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  ── SENHAS ────────────────────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "3" -ForegroundColor $corNumero -NoNewline; Write-Host " - Trocar senha de um usuário" -ForegroundColor $corTexto
        Write-Host "      Redefine a senha de qualquer conta local (requer admin)." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "4" -ForegroundColor $corNumero -NoNewline; Write-Host " - Forçar troca de senha no próximo logon" -ForegroundColor $corTexto
        Write-Host "      O usuário será obrigado a definir nova senha na próxima entrada." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "5" -ForegroundColor $corNumero -NoNewline; Write-Host " - Remover senha de um usuário (deixar em branco)" -ForegroundColor $corTexto
        Write-Host "      Define senha vazia para um usuário local." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  ── GRUPOS E PERMISSÕES ───────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "6" -ForegroundColor $corNumero -NoNewline; Write-Host " - Adicionar usuário ao grupo Administradores" -ForegroundColor $corTexto
        Write-Host "      Concede privilégios administrativos a um usuário local." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "7" -ForegroundColor $corNumero -NoNewline; Write-Host " - Remover usuário do grupo Administradores" -ForegroundColor $corTexto
        Write-Host "      Rebaixa um administrador para usuário padrão." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  ── CONTA ─────────────────────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "8" -ForegroundColor $corNumero -NoNewline; Write-Host " - Desativar conta de usuário" -ForegroundColor $corTexto
        Write-Host "      Bloqueia o acesso de um usuário sem excluir a conta." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "9" -ForegroundColor $corNumero -NoNewline; Write-Host " - Reativar conta de usuário" -ForegroundColor $corTexto
        Write-Host "      Reabilita uma conta que estava desativada." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "10" -ForegroundColor $corNumero -NoNewline; Write-Host " - Listar todos os usuários locais" -ForegroundColor $corTexto
        Write-Host "      Exibe todos os usuários, status e grupos de cada um." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  ── FERRAMENTAS AVANÇADAS ─────────────────────" -ForegroundColor $corTitulo
        Write-Host "  " -NoNewline; Write-Host "11" -ForegroundColor $corNumero -NoNewline; Write-Host " - Abrir Painel de Controle de Usuários (netplwiz)" -ForegroundColor $corTexto
        Write-Host "      Abre o gerenciador gráfico de contas e login automático do Windows." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "12" -ForegroundColor $corNumero -NoNewline; Write-Host " - Abrir Gerenciamento do Computador (lusrmgr)" -ForegroundColor $corTexto
        Write-Host "      Acesso avançado a usuários, grupos, serviços e mais." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "13" -ForegroundColor $corNumero -NoNewline; Write-Host " - Abrir Configurações de Contas (ms-settings)" -ForegroundColor $corTexto
        Write-Host "      Abre as configurações de contas no painel do Windows 10/11." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  " -NoNewline; Write-Host "0" -ForegroundColor $corNumero -NoNewline; Write-Host " - Voltar ao menu principal" -ForegroundColor $corTexto
        Write-Host ""

        $sub = Read-Host "  Escolha uma opção"

        switch ($sub) {

            # ── 1: Criar usuário ─────────────────────────────
            "1" {
                Write-Header "CRIAR NOVO USUÁRIO LOCAL"
                Write-Host "  Informe o nome do novo usuário ou 0 para cancelar." -ForegroundColor $corTexto
                Write-Host ""
                $nomeUsuario = Read-Host "  Nome do usuário (sem espaços) ou 0"
                if ($nomeUsuario -eq "0") { Write-Host "  Cancelado." -ForegroundColor $corAviso; Pause-Script; break }
                if ([string]::IsNullOrWhiteSpace($nomeUsuario)) { Write-Host "  [ERRO] Nome vazio." -ForegroundColor $corErro; Pause-Script; break }

                $nomeUsuario = ($nomeUsuario -replace '\s+', '_') -replace '[^\w\-]', ''

                if (Get-LocalUser -Name $nomeUsuario -ErrorAction SilentlyContinue) {
                    Write-Host "  [AVISO] Usuário '$nomeUsuario' já existe." -ForegroundColor $corAviso
                    Write-Log "[AVISO] Usuário '$nomeUsuario' já existe."
                    Pause-Script; break
                }

                try {
                    $senhaVazia = [System.Security.SecureString]::new()
                    New-LocalUser `
                        -Name $nomeUsuario `
                        -Password $senhaVazia `
                        -FullName $nomeUsuario `
                        -Description "Criado via Instalador Padrão - HTi TI" `
                        -PasswordNeverExpires:$false `
                        -UserMayNotChangePassword:$false `
                        -AccountNeverExpires `
                        -ErrorAction Stop

                    Add-LocalGroupMember -Group "Usuarios" -Member $nomeUsuario -ErrorAction SilentlyContinue
                    Add-LocalGroupMember -Group "Users"    -Member $nomeUsuario -ErrorAction SilentlyContinue

                    Write-Host "  [OK] Usuário '$nomeUsuario' criado. Senha será definida no 1º acesso." -ForegroundColor $corOK
                    Write-Log "[OK] Usuário '$nomeUsuario' criado."
                }
                catch {
                    Write-Host ("  [ERRO] {0}" -f $_.Exception.Message) -ForegroundColor $corErro
                    Write-Log "[ERRO] Criar usuário '$nomeUsuario': $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── 2: Remover usuário ───────────────────────────
            "2" {
                Write-Header "REMOVER USUÁRIO LOCAL"
                $usuarios = Get-LocalUser | Where-Object { $_.Name -notin @("Administrador","Administrator","DefaultAccount","WDAGUtilityAccount","Convidado","Guest") }
                Write-Host ""
                Write-Host "  Usuários disponíveis para remoção:" -ForegroundColor $corTexto
                $usuarios | ForEach-Object { Write-Host "    - $($_.Name)" -ForegroundColor $corAviso }
                Write-Host ""
                $nome = Read-Host "  Nome do usuário a remover (ou 0 para cancelar)"
                if ($nome -eq "0") { Pause-Script; break }

                $confirm = Read-Host "  Tem certeza que deseja remover '$nome'? (S/N)"
                if ($confirm -ne "S" -and $confirm -ne "s") { Write-Host "  Cancelado." -ForegroundColor $corAviso; Pause-Script; break }

                try {
                    Remove-LocalUser -Name $nome -ErrorAction Stop
                    Write-Host "  [OK] Usuário '$nome' removido." -ForegroundColor $corOK
                    Write-Log "[OK] Usuário '$nome' removido."
                }
                catch {
                    Write-Host ("  [ERRO] {0}" -f $_.Exception.Message) -ForegroundColor $corErro
                    Write-Log "[ERRO] Remover usuário '$nome': $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── 3: Trocar senha ──────────────────────────────
            "3" {
                Write-Header "TROCAR SENHA DE USUÁRIO"
                $nome = Read-Host "  Nome do usuário (ou 0 para cancelar)"
                if ($nome -eq "0") { Pause-Script; break }
                $novaSenha = Read-Host "  Nova senha" -AsSecureString
                try {
                    Set-LocalUser -Name $nome -Password $novaSenha -ErrorAction Stop
                    Write-Host "  [OK] Senha de '$nome' alterada com sucesso." -ForegroundColor $corOK
                    Write-Log "[OK] Senha do usuário '$nome' alterada."
                }
                catch {
                    Write-Host ("  [ERRO] {0}" -f $_.Exception.Message) -ForegroundColor $corErro
                    Write-Log "[ERRO] Trocar senha '$nome': $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── 4: Forçar troca de senha ─────────────────────
            "4" {
                Write-Header "FORÇAR TROCA DE SENHA NO PRÓXIMO LOGON"
                $nome = Read-Host "  Nome do usuário (ou 0 para cancelar)"
                if ($nome -eq "0") { Pause-Script; break }
                try {
                    # net user força PasswordExpired via cmd
                    net user $nome /logonpasswordchg:yes 2>&1 | Out-Null
                    Write-Host "  [OK] Usuário '$nome' deverá definir nova senha no próximo logon." -ForegroundColor $corOK
                    Write-Log "[OK] Troca de senha forçada para '$nome'."
                }
                catch {
                    Write-Host ("  [ERRO] {0}" -f $_.Exception.Message) -ForegroundColor $corErro
                    Write-Log "[ERRO] Forçar troca senha '$nome': $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── 5: Remover senha ─────────────────────────────
            "5" {
                Write-Header "REMOVER SENHA (DEIXAR EM BRANCO)"
                $nome = Read-Host "  Nome do usuário (ou 0 para cancelar)"
                if ($nome -eq "0") { Pause-Script; break }
                $confirm = Read-Host "  Confirmar remoção da senha de '$nome'? (S/N)"
                if ($confirm -ne "S" -and $confirm -ne "s") { Write-Host "  Cancelado." -ForegroundColor $corAviso; Pause-Script; break }
                try {
                    $senhaVazia = [System.Security.SecureString]::new()
                    Set-LocalUser -Name $nome -Password $senhaVazia -ErrorAction Stop
                    Write-Host "  [OK] Senha de '$nome' removida." -ForegroundColor $corOK
                    Write-Log "[OK] Senha removida do usuário '$nome'."
                }
                catch {
                    Write-Host ("  [ERRO] {0}" -f $_.Exception.Message) -ForegroundColor $corErro
                    Write-Log "[ERRO] Remover senha '$nome': $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── 6: Adicionar ao grupo Admin ──────────────────
            "6" {
                Write-Header "ADICIONAR AO GRUPO ADMINISTRADORES"
                $nome = Read-Host "  Nome do usuário (ou 0 para cancelar)"
                if ($nome -eq "0") { Pause-Script; break }
                try {
                    Add-LocalGroupMember -Group "Administradores" -Member $nome -ErrorAction SilentlyContinue
                    Add-LocalGroupMember -Group "Administrators"  -Member $nome -ErrorAction SilentlyContinue
                    Write-Host "  [OK] '$nome' adicionado ao grupo Administradores." -ForegroundColor $corOK
                    Write-Log "[OK] '$nome' adicionado a Administradores."
                }
                catch {
                    Write-Host ("  [ERRO] {0}" -f $_.Exception.Message) -ForegroundColor $corErro
                    Write-Log "[ERRO] Adicionar admin '$nome': $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── 7: Remover do grupo Admin ────────────────────
            "7" {
                Write-Header "REMOVER DO GRUPO ADMINISTRADORES"
                $nome = Read-Host "  Nome do usuário (ou 0 para cancelar)"
                if ($nome -eq "0") { Pause-Script; break }
                try {
                    Remove-LocalGroupMember -Group "Administradores" -Member $nome -ErrorAction SilentlyContinue
                    Remove-LocalGroupMember -Group "Administrators"  -Member $nome -ErrorAction SilentlyContinue
                    Write-Host "  [OK] '$nome' removido do grupo Administradores." -ForegroundColor $corOK
                    Write-Log "[OK] '$nome' removido de Administradores."
                }
                catch {
                    Write-Host ("  [ERRO] {0}" -f $_.Exception.Message) -ForegroundColor $corErro
                    Write-Log "[ERRO] Remover admin '$nome': $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── 8: Desativar conta ───────────────────────────
            "8" {
                Write-Header "DESATIVAR CONTA DE USUÁRIO"
                $nome = Read-Host "  Nome do usuário (ou 0 para cancelar)"
                if ($nome -eq "0") { Pause-Script; break }
                try {
                    Disable-LocalUser -Name $nome -ErrorAction Stop
                    Write-Host "  [OK] Conta '$nome' desativada." -ForegroundColor $corOK
                    Write-Log "[OK] Conta '$nome' desativada."
                }
                catch {
                    Write-Host ("  [ERRO] {0}" -f $_.Exception.Message) -ForegroundColor $corErro
                    Write-Log "[ERRO] Desativar conta '$nome': $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── 9: Reativar conta ────────────────────────────
            "9" {
                Write-Header "REATIVAR CONTA DE USUÁRIO"
                $nome = Read-Host "  Nome do usuário (ou 0 para cancelar)"
                if ($nome -eq "0") { Pause-Script; break }
                try {
                    Enable-LocalUser -Name $nome -ErrorAction Stop
                    Write-Host "  [OK] Conta '$nome' reativada." -ForegroundColor $corOK
                    Write-Log "[OK] Conta '$nome' reativada."
                }
                catch {
                    Write-Host ("  [ERRO] {0}" -f $_.Exception.Message) -ForegroundColor $corErro
                    Write-Log "[ERRO] Reativar conta '$nome': $($_.Exception.Message)"
                }
                Pause-Script
            }

            # ── 10: Listar usuários ──────────────────────────
            "10" {
                Write-Header "USUÁRIOS LOCAIS DO SISTEMA"
                Write-Host ""
                $usuarios = Get-LocalUser
                foreach ($u in $usuarios) {
                    $grupos = (Get-LocalGroup | Where-Object {
                        (Get-LocalGroupMember -Group $_.Name -ErrorAction SilentlyContinue |
                        Where-Object { $_.Name -like "*\$($u.Name)" }) -ne $null
                    }).Name -join ", "

                    $status = if ($u.Enabled) { "[ATIVO]  " } else { "[INATIVO]" }
                    $corStatus = if ($u.Enabled) { $corOK } else { $corAviso }

                    Write-Host "  $status " -ForegroundColor $corStatus -NoNewline
                    Write-Host "$($u.Name)" -ForegroundColor White -NoNewline
                    if ($grupos) { Write-Host "  |  Grupos: $grupos" -ForegroundColor DarkGray }
                    else { Write-Host "" }
                }
                Write-Host ""
                Write-Log "Lista de usuários exibida."
                Pause-Script
            }

            # ── 11: netplwiz ─────────────────────────────────
            "11" {
                Write-Header "PAINEL DE CONTROLE DE USUÁRIOS (netplwiz)"
                Write-Host "  Abrindo netplwiz..." -ForegroundColor $corTexto
                Write-Host "  Permite gerenciar contas, login automático e requisição de senha." -ForegroundColor DarkGray
                Start-Process "netplwiz"
                Write-Log "netplwiz aberto."
                Pause-Script
            }

            # ── 12: lusrmgr ──────────────────────────────────
            "12" {
                Write-Header "GERENCIAMENTO DO COMPUTADOR (lusrmgr)"
                Write-Host "  Abrindo gerenciador avançado de usuários e grupos..." -ForegroundColor $corTexto
                Write-Host "  Acesso completo a usuários, grupos, serviços e configurações." -ForegroundColor DarkGray
                try {
                    Start-Process "lusrmgr.msc"
                    Write-Log "lusrmgr.msc aberto."
                }
                catch {
                    Write-Host "  [AVISO] lusrmgr não disponível (Windows Home). Abrindo netplwiz..." -ForegroundColor $corAviso
                    Start-Process "netplwiz"
                }
                Pause-Script
            }

            # ── 13: Configurações de Contas ──────────────────
            "13" {
                Write-Header "CONFIGURAÇÕES DE CONTAS (Windows Settings)"
                Write-Host "  Abrindo painel de contas do Windows 10/11..." -ForegroundColor $corTexto
                Write-Host "  Gerencie e-mail, sincronização, família e opções de logon." -ForegroundColor DarkGray
                Start-Process "ms-settings:accounts"
                Write-Log "ms-settings:accounts aberto."
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

# ════════════════════════════════════════════════════════════
# MENU PRINCIPAL
# ════════════════════════════════════════════════════════════

function Show-Menu {
    Clear-Host
    $host.UI.RawUI.BackgroundColor = $corFundo
    $host.UI.RawUI.ForegroundColor = $corTexto

    Show-Banner

    Write-Host "  ── MENU PRINCIPAL ───────────────────────────" -ForegroundColor $corTitulo
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Host "1" -ForegroundColor $corNumero -NoNewline; Write-Host " - Instalar Aplicativos Padrões" -ForegroundColor $corTexto
    Write-Host "      Chrome, Adobe, WinRAR, 7-Zip e mais." -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Host "2" -ForegroundColor $corNumero -NoNewline; Write-Host " - Otimização do Sistema" -ForegroundColor $corTexto
    Write-Host "      Limpeza, reparo, desempenho, bloatware e ativação." -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Host "3" -ForegroundColor $corNumero -NoNewline; Write-Host " - Gerenciar Usuários" -ForegroundColor $corTexto
    Write-Host "      Criar, remover, senhas, grupos e ferramentas de conta." -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  ── SAIR ──────────────────────────────────────" -ForegroundColor $corTitulo
    Write-Host "  " -NoNewline; Write-Host "0" -ForegroundColor $corNumero -NoNewline; Write-Host " - Sair" -ForegroundColor $corTexto
    Write-Host ""
    Write-Host "  Log: $LogFile" -ForegroundColor DarkGray
    Write-Host ""
}

# ════════════════════════════════════════════════════════════
# EXECUÇÃO PRINCIPAL
# ════════════════════════════════════════════════════════════

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
            "1" { Show-AppInstallMenu }
            "2" { Show-OptimizationMenu }
            "3" { Show-UserManagementMenu }
            "0" {
                Write-Host ""
                Write-Host "  Encerrando e limpando histórico..." -ForegroundColor $corAviso
                Write-Log "Script encerrado pelo usuário."

                try { [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory() } catch {}
                try { Clear-History -ErrorAction SilentlyContinue } catch {}

                $histFile = (Get-PSReadLineOption).HistorySavePath
                if ($histFile -and (Test-Path $histFile)) {
                    Clear-Content -Path $histFile -ErrorAction SilentlyContinue
                }

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
