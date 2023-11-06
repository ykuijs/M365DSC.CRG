function New-CompositeResourceModule
{
    <#
        .Synopsis
        Generate a new module with composite resources based on Microsoft365DSC.

        .Description
        This function generates a new module with composite resources for Microsoft365DSC, split into workloads.

        .Example
        New-CompositeResourceModule -OutputPath 'C:\Temp'

        .Parameter OutputPath
        Specifies the path in which the new module should be generated.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Using Write-Host to format output")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Not changing state")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath
    )

    process
    {
        # These properties should be ignored by the code because they are not used in the composite resource
        $ignoredProperties = @('Credential', 'CertificatePassword', 'CertificatePath', 'ApplicationSecret', 'ManagedIdentity', 'DependsOn', 'PsDscRunAsCredential')

        $prerequisitesDatafile = Join-Path -Path $PSScriptRoot -ChildPath 'Dependencies.psd1'

        if (Test-Path -Path $prerequisitesDatafile)
        {
            $resourceDependencies = Import-PowerShellDataFile -Path $prerequisitesDatafile
        }
        else
        {
            Write-Host -Object "[ERROR] Prerequisites data file '$prerequisitesDatafile' not found!" -ForegroundColor Red
            return $false
        }

        $configData = [Ordered]@{
            AllNodes    = @(
                @{
                    NodeName        = 'localhost'
                    CertificateFile = '.\DSCCertificate.cer'
                }
            )
            NonNodeData = [Ordered]@{
                Environment    = @{
                    Name             = '[Name of your environment, e.g. Test]'
                    ShortName        = '[Abbreviation of the environment name, e.g. TST]'
                    TenantId         = '[Tenant URL, e.g. test.onmicrosoft.com]'
                    OrganizationName = '[Name of your organization, e.g. Test]'
                }
                AppCredentials = @(
                    @{
                        Workload       = 'AAD'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                    @{
                        Workload       = 'Exchange'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                    @{
                        Workload       = 'Intune'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                    @{
                        Workload       = 'Office365'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                    @{
                        Workload       = 'OneDrive'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                    @{
                        Workload       = 'Planner'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                    @{
                        Workload       = 'PowerPlatform'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                    @{
                        Workload       = 'SecurityCompliance'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                    @{
                        Workload       = 'SharePoint'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                    @{
                        Workload       = 'Teams'
                        ApplicationId  = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                        CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
                    }
                )
            }
        }
        #endregion Initialize Variables

        #region Main script
        # Get the Microsoft365DSC module
        [Array]$m365Module = Get-Module Microsoft365DSC -ListAvailable

        # Check if the module has been retrieved or not
        if ($m365Module.Count -eq 1)
        {
            # Get the version of Microsoft365DSC
            $version = $m365Module.Version.ToString()

            # Initialize the module
            Initialize-Module -Version $version -OutputPath $OutputPath

            # Get the module root path and find all schema.mof files in the module
            $m365modulePath = Split-Path -Path $m365Module.Path -Parent
            $mofSearchPath = Join-Path -Path $m365modulePath -ChildPath '\**\**.schema.mof'
            $mofSchemaFiles = @(Get-ChildItem -Path $mofSearchPath -Recurse)

            Write-Host -Object ("Found {0} MOF files in path '{1}'." -f $mofSchemaFiles.Count, $m365modulePath) -ForegroundColor Cyan

            if ($mofSchemaFiles.Count -eq 0)
            {
                return $false
            }

            Write-Host -Object ' '
            Write-Host -Object 'Processing resources:' -ForegroundColor Cyan

            $lastWorkload = ''

            # Loop through all the Schema files found in the modules folder
            foreach ($mofSchemaFile in $mofSchemaFiles)
            {
                # Read schema
                $mofSchemas = Get-MofSchemaObject -FileName $mofSchemaFile.FullName
                $dscResourceName = $mofSchemaFile.Name.Replace('.schema.mof', '')
                $shortResourceName = $dscResourceName -replace '^MSFT_'

                Write-Host -Object "  - $shortResourceName" -ForegroundColor Green

                # Geth the main CIM class of the resource
                $resourceSchema = $mofSchemas |
                    Where-Object -FilterScript {
                            ($_.ClassName -eq $dscResourceName) -and ($null -ne $_.FriendlyName)
                    }

                # Determine which workload the current resource is in
                switch ($shortResourceName)
                {
                    { $_.StartsWith('AAD') }
                    {
                        $resourceWorkload = 'AAD'
                        $customResourceName = $shortResourceName -replace "^$resourceWorkload"
                    }
                    { $_.StartsWith('EXO') }
                    {
                        $resourceWorkload = 'Exchange'
                        $customResourceName = $shortResourceName -replace '^EXO'
                    }
                    { $_.StartsWith('Intune') }
                    {
                        $resourceWorkload = 'Intune'
                        $customResourceName = $shortResourceName -replace "^$resourceWorkload"
                    }
                    { $_.StartsWith('O365') }
                    {
                        $resourceWorkload = 'Office365'
                        $customResourceName = $shortResourceName -replace '^O365'
                    }
                    { $_.StartsWith('OD') }
                    {
                        $resourceWorkload = 'OneDrive'
                        $customResourceName = $shortResourceName -replace '^OD'
                    }
                    { $_.StartsWith('Planner') }
                    {
                        $resourceWorkload = 'Planner'
                        $customResourceName = $shortResourceName -replace "^$resourceWorkload"
                    }
                    { $_.StartsWith('PP') }
                    {
                        $resourceWorkload = 'PowerPlatform'
                        $customResourceName = $shortResourceName -replace '^PP'
                    }
                    { $_.StartsWith('SC') }
                    {
                        $resourceWorkload = 'SecurityCompliance'
                        $customResourceName = $shortResourceName -replace '^SC'
                    }
                    { $_.StartsWith('SPO') }
                    {
                        $resourceWorkload = 'SharePoint'
                        $customResourceName = $shortResourceName -replace '^SPO'
                    }
                    { $_.StartsWith('Teams') }
                    {
                        $resourceWorkload = 'Teams'
                        $customResourceName = $shortResourceName -replace "^$resourceWorkload"
                    }
                    { $_.StartsWith('M365DSC') }
                    {
                        Write-Host '    Skipping M365DSC workload (RuleEvaluation)' -ForegroundColor 'Yellow'
                    }
                    Default
                    {
                        Write-Error 'Unknown workload for this resource!'
                        continue
                    }
                }

                # Check if the last workload matches the current workload
                if ($lastWorkload -ne $resourceWorkload)
                {
                    # Last workload is different from the current workload.
                    # Check if this is the first workload or a subsequent workload
                    if ([String]::IsNullOrEmpty($lastWorkload) -eq $false)
                    {
                        # Is a subsequent workload, so wrap up previous workload and save resource
                        [void]$configString.Append('}')
                        Save-Resource -Config $configString.ToString() -Workload $lastWorkload -Version $version -OutputPath $OutputPath
                    }

                    $lastWorkload = $resourceWorkload

                    if ($null -eq $configData.NonNodeData.$resourceWorkload)
                    {
                        $configData.NonNodeData.$resourceWorkload = [Ordered]@{}
                    }

                    # Initialize new composite resource content
                    $configString = [System.Text.StringBuilder]::new()
                    [void]$configString.AppendLine("# ($(Get-Date -f 'yyyy-MM-dd HH:mm:ss')) Generated using Microsoft365DSC v$($m365Module.Version)")
                    [void]$configString.AppendLine("Configuration '$($resourceWorkload)'")
                    [void]$configString.AppendLine('{')
                    [void]$configString.AppendLine('    param')
                    [void]$configString.AppendLine('    (')
                    [void]$configString.AppendLine('        [Parameter(Mandatory = $true)]')
                    [void]$configString.AppendLine('        [System.String]')
                    [void]$configString.AppendLine('        $ApplicationId,')
                    [void]$configString.AppendLine('')
                    [void]$configString.AppendLine('        [Parameter(Mandatory = $true)]')
                    [void]$configString.AppendLine('        [System.String]')
                    [void]$configString.AppendLine('        $TenantId,')
                    [void]$configString.AppendLine('')
                    [void]$configString.AppendLine('        [Parameter(Mandatory = $true)]')
                    [void]$configString.AppendLine('        [System.String]')
                    [void]$configString.AppendLine('        $CertificateThumbprint')
                    [void]$configString.AppendLine('    )')
                    [void]$configString.AppendLine('')
                    [void]$configString.AppendLine('    Import-DscResource -ModuleName Microsoft365DSC')
                }

                $identityGlobalResource = $false
                $indent = 1

                # Generate Configuration Data location of the settings
                $configDataLocation = '$ConfigurationData.NonNodeData.{0}.{1}' -f $lastWorkload, $customResourceName

                # Checking for missing CertificateThumbprint parameter and skip resource if it is (TeamsUserCallingSettings resource)
                if (($resourceSchema.Attributes | Where-Object -FilterScript { $_.Name -eq 'CertificateThumbprint' }) -isnot [System.Collections.Hashtable])
                {
                    Write-Host '    Resource does not support CertificateThumbprint authentication. Skipping resource for now!' -ForegroundColor Red
                    continue
                }

                # Check if the current DSC resource is a SingleInstance resource
                if (($resourceSchema.Attributes | Where-Object -FilterScript { $_.Name -eq 'IsSingleInstance' }) -is [System.Collections.Hashtable])
                {
                    # IsSingleInstance resources can only exist once and therefore should not loop through an array
                    Write-Debug -Message '    * Has IsSingleInstance'

                    $configData.NonNodeData.$resourceWorkload.$customResourceName = [Ordered]@{}
                    $currentDataObject = $configData.NonNodeData.$resourceWorkload.$customResourceName

                    # Single instance resources should
                    [void]$configString.AppendLine('')

                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "if (`$ConfigurationData.NonNodeData.$resourceWorkload.ContainsKey('$customResourceName'))"))
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), '{'))

                    $indent++
                    $resourceTitle = "$($customResourceName)Defaults"

                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$resourceTitle = '$resourceTitle'"))
                    [void]$configString.AppendLine('')

                    # Adding parameters hashtable initialization to the code
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$parameters = $configDataLocation"))
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$parameters.IsSingleInstance = 'Yes'"))
                }
                # Check if the current DSC resource has an Identity parameter which only accepts the value 'Global'
                elseif (($resourceSchema.Attributes | Where-Object -FilterScript { $_.Name -eq 'Identity' -and $_.ValueMap -eq 'Global' }) -is [System.Collections.Hashtable])
                {
                    # Global resources can only exist once and therefore should not loop through an array
                    $identityGlobalResource = $true
                    Write-Debug -Message '    * Identity = Global'

                    $configData.NonNodeData.$resourceWorkload.$customResourceName = @{}
                    $currentDataObject = $configData.NonNodeData.$resourceWorkload.$customResourceName

                    [void]$configString.AppendLine('')

                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "if (`$ConfigurationData.NonNodeData.$resourceWorkload.ContainsKey('$customResourceName'))"))
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), '{'))

                    $indent++
                    $resourceTitle = "$($customResourceName)Defaults"

                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$resourceTitle = '$resourceTitle'"))
                    [void]$configString.AppendLine('')

                    # Adding parameters hashtable initialization to the code
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$parameters = $configDataLocation"))
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$parameters.Identity = 'Global'"))
                }
                # All other resources should be processed similar
                else
                {
                    # All other resources can exist multiple times and therefore should loop through an array
                    [void]$configString.AppendLine('')

                    # Generate the plural name of the data node
                    if ($shortResourceName.EndsWith('y'))
                    {
                        $dataName = $customResourceName -replace 'y$', 'ies'
                    }
                    elseif ($shortResourceName -like '*Policy*')
                    {
                        $dataName = $customResourceName -replace 'Policy', 'Policies'
                    }
                    elseif ($shortResourceName -like '*Profile*')
                    {
                        $dataName = $customResourceName -replace 'Profile', 'Profiles'
                    }
                    elseif ($shortResourceName.EndsWith('Settings'))
                    {
                        $dataName = $customResourceName += 'Items'
                    }
                    else
                    {
                        $dataName = $customResourceName + 's'
                    }

                    $configData.NonNodeData.$resourceWorkload.$dataName = @(@{})
                    $currentDataObject = $configData.NonNodeData.$resourceWorkload.$dataName[0]

                    # Add foreach to loop through the array
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "foreach (`$$($customResourceName) in `$ConfigurationData.NonNodeData.$($lastWorkload).$($dataName))"))
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), '{'))
                    $indent++

                    # Shorten the Configuration Data location
                    $configDataLocation = '${0}' -f $customResourceName

                    # Generate name of the resource, using the Key parameter(s)
                    $mandatoryProperties = $resourceSchema.Attributes | Where-Object { $_.State -in @('Key') }
                    if ($mandatoryProperties.Name -is [System.Array])
                    {
                        # Multiple key parameters found, combine these names
                        $paramFullPlaceholder = ''
                        $paramPlaceholder = ''
                        for ($i = 0; $i -lt $mandatoryProperties.Name.Count; $i++)
                        {
                            $paramFullPlaceholder += "$configDataLocation.{$i},"
                            $paramPlaceholder += "{$i}-"
                        }
                        $paramFullPlaceholder = $paramFullPlaceholder.TrimEnd(',')
                        $paramPlaceholder = $paramPlaceholder.TrimEnd('-')

                        $resourceTitle = '$resourceTitle = ''{0}-[parameter]'' -f {1}' -f $shortResourceName, $paramFullPlaceholder
                        $resourceTitle = $resourceTitle -f $mandatoryProperties.Name
                        $resourceTitle = $resourceTitle -replace '\[parameter\]', $paramPlaceholder
                    }
                    else
                    {
                        # Single key parameter found
                        $resourceTitle = '$resourceTitle = ''{0}-{1}'' -f {2}.{3}' -f $shortResourceName, '{0}', $configDataLocation, $mandatoryProperties.Name
                    }

                    # Adding resource title generation
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), $resourceTitle))
                    [void]$configString.AppendLine('')

                    # Adding parameters hashtable initialization to the code
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$parameters = $configDataLocation"))
                }

                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$parameters.ApplicationId = `$ApplicationId"))
                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$parameters.TenantId = `$TenantId"))
                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "`$parameters.CertificateThumbprint = `$CertificateThumbprint"))
                [void]$configString.AppendLine('')

                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "if (`$parameters.ContainsKey('UniqueId'))"))
                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), '{'))
                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "    `$parameters.Remove('UniqueId')"))
                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), '}'))

                $script:currentDepth = 0
                $script:maxDepth = 5

                # Process all parameters, but handle embedded parameters separately
                $result = Get-EmbeddedPropertyString -Properties $resourceSchema.Attributes -Indentation $indent -ParameterName '$parameters'
                if ([String]::IsNullOrEmpty($result) -eq $false)
                {
                    [void]$configString.Append($result)
                }

                # Add DependsOn parameter, when necessary.
                if ($resourceDependencies.ContainsKey($shortResourceName))
                {
                    $dependsString = $resourceDependencies.$shortResourceName

                    [void]$configString.AppendLine(("{0}{1} = {2}" -f (Get-IndentationString -Indentation $indent), '$parameters.DependsOn', $dependsString))
                    [void]$configString.AppendLine('')
                }

                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "(Get-DscSplattedResource -ResourceName '$shortResourceName' -ExecutionName `$resourceTitle -Properties `$parameters -NoInvoke).Invoke(`$parameters)"))

                # Get all the properties in the resource and filter out those that should be ignored
                $filteredProperties = $resourceSchema.Attributes | Where-Object { $_.Name -notin $ignoredProperties } | Sort-Object -Property Name

                $script:currentDepth = 0

                if ($filteredProperties.Name -notcontains "Id" -and $filteredProperties.Name -notcontains "Identity")
                {
                    $currentDataObject.UniqueId = ('{0} | {1} | {2}' -f "String", "Required", "[Unique ID to identify this specific object]")
                }

                # Loop through all the filtered properties and build example config data file
                foreach ($property in $filteredProperties)
                {
                    # Check if the property is an EmbeddedInstance
                    if ($null -ne $property.EmbeddedInstance -and $property.EmbeddedInstance -ne 'MSFT_Credential')
                    {
                        $null = Get-AttributeString -Property $property -ConfigData $currentDataObject
                    }
                    else
                    {
                        if ($property.Name -notin @('IsSingleInstance','ApplicationId', 'CertificateThumbprint', 'TenantId') -and
                            (($identityGlobalResource -eq $false) -or ($identityGlobalResource -and $property.Name -ne 'Identity')))
                        {
                            # For all other parameter, generate the correct parameter value name from the Configuration Data
                            $propertyDataType = $property.DataType

                            if ($propertyDataType -eq 'Instance' -and $property.EmbeddedInstance -eq 'MSFT_Credential')
                            {
                                $propertyDataType = 'PSCredential'
                            }

                            $state = 'Optional'
                            if ($property.State -in @('Key', 'Required'))
                            {
                                $state = 'Required'
                            }

                            if ($null -eq $property.ValueMap)
                            {
                                $currentDataObject.$($property.Name) = ('{0} | {1}' -f $propertyDataType, $state)
                            }
                            else
                            {
                                $currentDataObject.$($property.Name) = ('{0} | {1} | {2}' -f $propertyDataType, $state, ($property.ValueMap -join ' / '))
                            }
                        }
                    }
                }

                $indent--
                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), '}'))
            }

            # Last workload is processed. Make sure the this resource is also saved to file
            [void]$configString.Append('}')
            Save-Resource -Config $configString.ToString() -Workload $lastWorkload -Version $version -OutputPath $OutputPath

            Write-Host -Object 'Writing ConfigurationData file' -ForegroundColor Cyan
            $psdStringData = "# ($(Get-Date -f 'yyyy-MM-dd HH:mm:ss')) Generated using Microsoft365DSC v$($m365Module.Version)`n"
            $psdStringData += $configData | ConvertTo-Psd
            $psdPath = Join-Path -Path $OutputPath -ChildPath 'M365ConfigurationDataExample.psd1'
            Set-Content -Path $psdPath -Value $psdStringData
            return $true
        }
        elseif ($m365Module.Count -eq 0)
        {
            # Can't generate the module, since the Microsoft365DSC module cannot be found.
            Write-Host -Object 'Microsoft365DSC not found!' -ForegroundColor Red
            return $false
        }
        else
        {
            # Can't generate the module, since the Microsoft365DSC module cannot be found.
            $versions = ($m365Module.Version | Sort-Object -Property Major, Minor, Build) -join ', '
            Write-Host -Object "Multiple versions of Microsoft365DSC found: $versions" -ForegroundColor Red
            return $false
        }
        #endregion

    }
}
