$cutoffTime=(Get-Date).AddDays(-3)

Get-LocalUser | Where-Object {
    $_.WhenCreated -gt $cutoffTime
} | Select-Object Name, WhenCreated