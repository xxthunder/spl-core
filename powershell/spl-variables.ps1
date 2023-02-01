# Read build environment definitions from VSCode config
Function Read-Environment-Variable-List {
    try {
        $settingsJSON = Get-Content -Raw -Path .vscode/settings.json | ConvertFrom-Json
        if ($settingsJSON.'cmake.environment') {
            $settingsJSON.'cmake.environment' | ForEach-Object {
                [Environment]::SetEnvironmentVariable($_.Name, $_.Value)
            }
        }
    } catch {
        Write-Information -Tags "Error:" -MessageData "Error while reading VSCode settings."
    }
}

### Env Vars ###
Read-Environment-Variable-List

$SPL_CORE_INSTALL_DEPENDENCY_JSON_CONTENT = Get-Content -Raw -Path "$PSScriptRoot/../dependencies.json" | ConvertFrom-Json
if ($null -eq $SPL_CORE_INSTALL_DEPENDENCY_JSON_CONTENT) {
    Write-Information -Tags "Error:" -MessageData "SPL_CORE_INSTALL_DEPENDENCY_JSON_CONTENT is not defined, maybe a configuration issue?"
}

$SPL_EXTENSIONS_SETUP_SCRIPTS_PATH = "$Env:SPL_EXTENSION_ROOT_DIR$Env:SPL_EXTENSION_SETUP_SCRIPT_SUBDIR"
if ($null -eq $SPL_EXTENSIONS_SETUP_SCRIPTS_PATH) {
    Write-Information -Tags "Error:" -MessageData "SPL_EXTENSIONS_SETUP_SCRIPTS_PATH is not defined, maybe a configuration issue?"
}

# proxy settings are read from configuration file and present as environment variables afterwards.
$SPL_PROXY_HOST = $Env:SPL_PROXY_HOST
$SPL_PROXY_BYPASS_LIST = $Env:SPL_PROXY_BYPASS_LIST

# Check if the proxy host and bypass list variables are defined
if ($SPL_PROXY_HOST -and $SPL_PROXY_BYPASS_LIST) {
    # Initialize the proxy using the defined variables
    Initialize-Proxy -ProxyHost $SPL_PROXY_HOST -NoProxy $SPL_PROXY_BYPASS_LIST
}
