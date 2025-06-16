# Install-NAVSipCryptoProviderFromNavContainer -containerName 'bc-uc'
# Run this as admin in powershell when this error occurs: This file format cannot be signed because it is not recognized.
$BuildFolder = "X:\SourceCode\Red.Regen\Red Regenerator\_Build"
$files = Get-ChildItem $BuildFolder -Filter *.app

Set-Location "C:\Program Files (x86)\Microsoft SDKs\ClickOnce\SignTool"

for ($i=0; $i -lt $files.Count; $i++) {
    $outfile = $files[$i].FullName
   .\SignTool.exe sign /n 'Red and Bundle' /t http://timestamp.comodoca.com/authenticode $outfile
}

# Get signtool from Microsoft https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool
# Have BC14 installed locally
# Use Safenet toen password from Bitwarden: Sectigo token password
# Install safenet token client from https://www.sectigo.com/knowledge-base/detail/SafeNet-Authentication-Client-Download-for-Sectigo-Certificates-on-eToken/kA03l000000o6kL