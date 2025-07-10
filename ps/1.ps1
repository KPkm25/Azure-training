# $bootTime=(Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime

# $newProcess=Get-Process | Where-Object{
#    $_.StartTime -gt $bootTime
# } | Select-Object ProcessName, StartTime

# $newProcess | Export-Csv -Path "./trial.csv" -NoTypeInformation

# ------------------------------

# Get-ChildItem -Path "C:/Users/289220/Desktop/Azure_training" -Recurse 

# ------------------------------

# Get-PSDrive -PSProvider "Environment"

# ------------------------------

# Get-Process | Sort-Object CPU -Descending | Where-Object{
#    $_.CPU -gt 50
# } |Select-Object ProcessName,Handles,NPM,PM

# ------------------------------

# Get-ChildItem -Path "C:/Users/289220/Desktop/Azure_Training" | Where-Object{
#    $_.Length -gt 1Mb
# } | Select-Object Name, Length

# ------------------------------

# Get-Service | Where-Object{
#    $_.Status -eq "Running"
# } | Select-Object Name, Status