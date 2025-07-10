Q. Powershell script to print all the files in the given directory
```
PS C:\Users\289220> $directory = "C:\Users\289220\Desktop\Ansible_test"
PS C:\Users\289220> Get-ChildItem -Path $directory -File | ForEach-Object {
>>     Write-Output $_.FullName
>> }
```

Q. Powershell script to print all the directories and files in a directory
```
# Print all files in current directory and all subdirectories
Get-ChildItem -File -Recurse
```

Q.# Print just the names of files
`Get-ChildItem -File | ForEach-Object { $_.Name }`
