# https://freddysblog.com/2021/01/03/how-to-use-run-alvalidation/

# install-module bccontainerhelper -force -AllowClobber
# uninstall-module navcontainerhelper -force

# $licenseFile = 'X:\OneDrive\Red And Bundle B.V\Development - Documents\Licenses\Business Central\BC25 On Prem ForNAV + Own Objects.bclicense'
# $fnLanguage = "X:\SourceCode\Cust.ForNAV\ForNAV Docker Installer\UniversalCodeApp 25\ForNAV Language Module 8.0.2500.3.app"
# $fnCore = "X:\SourceCode\Cust.ForNAV\ForNAV Docker Installer\UniversalCodeApp 25\ForNAV Core 8.0.2500.3.app"
# $fnReport = "X:\SourceCode\Cust.ForNAV\ForNAV Docker Installer\UniversalCodeApp 25\ForNAV Customizable Report Pack 8.0.2500.3.app"
$app = "X:\SourceCode\Red.Regen\Red Regenerator\_Build\Red and Bundle_Red Regenerator_1.0.0.6.app"
$prev = "X:\SourceCode\Red.Regen\Red Regenerator\_Build - Archive\Red and Bundle_Red Regenerator_1.0.0.6.app"

# Run-AlValidation `
#     -licenseFile $licenseFile `
#     -installApps @($fnLanguage, $fnCore, $fnReport) `
#     -apps @("X:\Sync\Red and Bundle\Development\Source Code\Red.MultipleLayouts\_Build\Red and Bundle_Multiple Report Layout Selector_2.1.0.0.app") `
#     -affixes "red" `
#     -countries @("nl", "de", "dk", "us")

$validationResults = Run-AlValidation `
    -validateCurrent `
    -previousApps @( $prev ) `
    -apps @( $app ) `
    -countries @("nl", "de", "dk", "us") `
    -affixes @( "red" ) `
    -supportedCountries @( "nl", "de", "dk", "us" )

$validationResults | Write-Host -ForegroundColor Red