Import-Module 'C:\Program Files\Reports ForNAV\ForNav.Cmdlet.dll'

# Set-Location -Path $PSScriptRoot

Invoke-ExportTranslationFromXlfToExcel `
    -FromXlf '.\Red Regenerator\Translations\'`
    -ToExcel '.\Scripts\Translations-Generated.xlsx'

Invoke-ImportTranslationFromExcelToXlf `
    -FromXlf '.\Red Regenerator\Translations\Red Regenerator.g.xlf'`
    -FromExcel '.\Red Regenerator\Scripts\Translations - baseline.xlsx'`
    -ToXlf '.\Red Regenerator\Translations'

Invoke-ImportTranslationFromExcelToXlf `
    -FromXlf '.\Red Regenerator\Translations\Red Regenerator.g.xlf'`
    -FromExcel '.\Scripts\Translations.xlsx'`
    -ToXlf '.\Red Regenerator\Translations'