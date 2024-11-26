# Define parameters
$resourceGroupName = "YourResourceGroupName"
$vmssName = "YourVmssName"
$storageAccountName = "YourStorageAccountName"
$storageAccountKey = "YourStorageAccountKey"
$containerName = "YourContainerName"
$scriptFileName = "YourScript.ps1"
 
# Get the storage account context
$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
 
# Generate the SAS token for the script file
$expiryTime = (Get-Date).AddHours(1)
$scriptUri = New-AzStorageBlobSASToken -Container $containerName -Blob $scriptFileName -Context $storageContext -Permission r -ExpiryTime $expiryTime -FullUri
 
# Define the VMSS extension settings
$extensionName = "CustomScriptExtension"
$publisher = "Microsoft.Compute"
$type = "CustomScriptExtension"
$typeHandlerVersion = "1.10"
$settings = @{
    "fileUris" = @($scriptUri)
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File $scriptFileName"
}
 
# Add the extension to the VMSS
Add-AzVmssExtension -ResourceGroupName $resourceGroupName -VMScaleSetName $vmssName -Name $extensionName -Publisher $publisher -Type $type -TypeHandlerVersion $typeHandlerVersion -Settings $settings