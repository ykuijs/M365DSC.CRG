function New-CompositeResourceModule
{
    <#
        .Synopsis
        Generate a new module with composite resources based on Microsoft365DSC.

        .Description
        This function generates a new module with composite resources for Microsoft365DSC, split into workloads.

        .Example
        New-CompositeResourceModule -OutputPath 'C:\Temp' -Version '11.23.1122.100'

        .Parameter OutputPath
        Specifies the path in which the new module should be generated.

        .Parameter Version
        Specifies the version of the new module should be generated. This should be related to the version of Microsoft365DSC.
        E.g. Version is 1.23.1122.100 when the Microsoft365DSC version is 1.23.1122.1
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification="Using Write-Host to format output")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Not changing state")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Version
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

        $script:errors = @()

        $configData = [Ordered]@{
            AllNodes    = @(
                @{
                    NodeName        = 'String | Required | Name of the host of which the LCM is used, normally this is localhost'
                    CertificateFile = 'String | Required | Relative path to the public key of the DSC credential encryption certificate, e.g. .\DSCCertificate.cer'
                }
            )
            NonNodeData = [Ordered]@{
                Environment    = @{
                    Name             = 'String | Required | Name of your environment, e.g. TestEnvironment'
                    ShortName        = 'String | Required | Abbreviation of the environment name, e.g. TST'
                    TenantId         = 'String | Required | Tenant URL, e.g. test.onmicrosoft.com'
                    OrganizationName = 'String | Required | Name of your organization, prefix of the tenant id, e.g. test'
                    CICD             = @{
                        DependsOn     = 'String | Required | Name of the environment this environment depends on, e.g. TestEnvironment'
                        UseCodeBranch = 'String | Required | Name of the branch that is used for the CICD (Script) repository, e.g. main'
                        Approvers = @(
                            @{
                                Principal = 'String | Required | Principal of the user or groups that needs to get added to the approvers list.'
                                Type      = 'String | Required | Type of principal | User / Group'
                            }
                        )
                    }
                    UsedWorkloads = @{}
                    Tokens = @{
                        ExampleToken = 'String | Optional | Example of a token that can be used anywhere in the config, by specifying {{ExampleToken}}'
                    }
                }
                AppCredentials = @(
                    @{
                        Workload       = 'String | Required | Name of the Workload for which this credential will be used | AzureAD / AzureDevOps / Azure / Defender / Exchange / Fabric / Intune / Office365 / OneDrive / Planner / PowerPlatform / SecurityCompliance / Sentinel / SharePoint / Teams'
                        ApplicationId  = 'Guid | Required | The GUID of the Entra ID Service Principal'
                        CertThumbprint = 'String | Required | The Certificate Thumbprint of the certificate used for authentication'
                    }
                )
            }
        }
        #endregion Initialize Variables

        #region Main script
        # Get the Microsoft365DSC module
        $m365dscVersion = $Version.Substring(0, $Version.LastIndexOf('.') + 2)
        [Array]$m365Module = Get-Module Microsoft365DSC -ListAvailable | Where-Object -FilterScript {
            $_.Version -eq $m365dscVersion
        }

        # Check if the module has been retrieved or not
        if ($m365Module.Count -gt 0)
        {
            if ($m365Module.Count -gt 1)
            {
                Write-Host -Object 'Found multiple versions of Microsoft365DSC. Using the latest version.'
                $m365Module = $m365Module | Select-Object -First 1
            }

            # Initialize the module
            Initialize-Module -Version $Version -OutputPath $OutputPath

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
            :schemaloop foreach ($mofSchemaFile in $mofSchemaFiles)
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
                        $resourceWorkload = 'AzureAD'
                        $customResourceName = $shortResourceName -replace "^AAD"
                    }
                    { $_.StartsWith('ADO') }
                    {
                        $resourceWorkload = 'AzureDevOps'
                        $customResourceName = $shortResourceName -replace "^ADO"
                    }
                    { $_.StartsWith('Azure') }
                    {
                        $resourceWorkload = 'Azure'
                        $customResourceName = $shortResourceName -replace "^$resourceWorkload"
                    }
                    { $_.StartsWith('Defender') }
                    {
                        $resourceWorkload = 'Defender'
                        $customResourceName = $shortResourceName -replace "^$resourceWorkload"
                    }
                    { $_.StartsWith('EXO') }
                    {
                        $resourceWorkload = 'Exchange'
                        $customResourceName = $shortResourceName -replace '^EXO'
                    }
                    { $_.StartsWith('Fabric') }
                    {
                        $resourceWorkload = 'Fabric'
                        $customResourceName = $shortResourceName -replace "^$resourceWorkload"
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
                    { $_.StartsWith('Sentinel') }
                    {
                        $resourceWorkload = 'Sentinel'
                        $customResourceName = $shortResourceName -replace "^$resourceWorkload"
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
                        continue schemaloop
                    }
                    Default
                    {
                        Write-Error 'Unknown workload for this resource!'
                        $script:errors += [PSCustomObject]@{
                            Type = 'Error'
                            Message = "Unknown workload for resource '$shortResourceName'"
                        }
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
                        Save-Resource -Config $configString.ToString() -Workload $lastWorkload -Version $Version -OutputPath $OutputPath
                    }

                    $lastWorkload = $resourceWorkload

                    if ($null -eq $configData.NonNodeData.$resourceWorkload)
                    {
                        $configData.NonNodeData.$resourceWorkload = [Ordered]@{}
                    }

                    $configData.NonNodeData.Environment.UsedWorkloads.$resourceWorkload = 'Boolean | Required | Specifies if the workload should be included in the configuration'

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
                    $script:errors += [PSCustomObject]@{
                        Type = 'Warning'
                        Message = "Resource '$shortResourceName' does not support CertificateThumbprint authentication. Resource has been skipped!"
                    }
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

                    $replaceCharsString = '$resourceTitle = $resourceTitle -replace "@","_"'
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), $replaceCharsString))
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
                [void]$configString.AppendLine('')

                $script:currentDepth = 0
                $script:maxDepth = 8

                # Process all parameters, but handle embedded parameters separately
                $result = Get-EmbeddedPropertyString -Properties $resourceSchema.Attributes -Indentation $indent -ParameterName '$parameters'
                if ([String]::IsNullOrEmpty($result) -eq $false)
                {
                    [void]$configString.Append($result)
                }

                # Add DependsOn parameter, when necessary.
                if ($resourceDependencies.ContainsKey($shortResourceName))
                {
                    $ifStatementString = $resourceDependencies.$shortResourceName.IfStatement
                    $dependsString = $resourceDependencies.$shortResourceName.DependsOnString

                    [void]$configString.AppendLine(("{0}if ({1})" -f (Get-IndentationString -Indentation $indent), $ifStatementString))
                    [void]$configString.AppendLine(("{0}{{" -f (Get-IndentationString -Indentation $indent)))

                    $indent++
                    [void]$configString.AppendLine(("{0}{1} = {2}" -f (Get-IndentationString -Indentation $indent), '$parameters.DependsOn', $dependsString))
                    $replaceCharsInDependsOn = '$parameters.DependsOn = $parameters.DependsOn -replace "@","_"'
                    [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), $replaceCharsInDependsOn))
                    $indent--

                    [void]$configString.AppendLine(("{0}}}" -f (Get-IndentationString -Indentation $indent)))
                    [void]$configString.AppendLine('')
                }

                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), "(Get-DscSplattedResource -ResourceName '$shortResourceName' -ExecutionName `$resourceTitle -Properties `$parameters -NoInvoke).Invoke(`$parameters)"))

                # Get all the properties in the resource and filter out those that should be ignored
                $filteredProperties = $resourceSchema.Attributes | Where-Object { $_.Name -notin $ignoredProperties } | Sort-Object -Property Name

                $script:currentDepth = 0

                # Check if the resource needs a UniqueId parameter by checking if the names of the properties contain
                # any of the below property names. If they don't, a UniqueId is required.
                $propertiesNeedUniqueId = @("Id", "Identity", "SettingDefinitionId", "IsSingleInstance")
                $diff = Compare-Object -ReferenceObject $filteredProperties.Name -DifferenceObject $propertiesNeedUniqueId -ExcludeDifferent -IncludeEqual
                if ($null -eq $diff)
                {
                    $currentDataObject.UniqueId = ('{0} | {1} | {2}' -f "String", "Required", "Unique ID to identify this specific object")
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
                                if ($propertyDataType -like "*Array")
                                {
                                    $propertyDataType = $propertyDataType -replace "Array"
                                    $result = @(('{0} | {1} | {2}' -f $propertyDataType, $state, $property.Description))
                                }
                                else
                                {
                                    $result = ('{0} | {1} | {2}' -f $propertyDataType, $state, $property.Description)
                                }
                            }
                            else
                            {
                                if ($propertyDataType -like "*Array")
                                {
                                    $propertyDataType = $propertyDataType -replace "Array"
                                    $result = @(('{0} | {1} | {2} | {3}' -f $propertyDataType, $state, $property.Description, ($property.ValueMap -join ' / ')))
                                }
                                else
                                {
                                    $result = ('{0} | {1} | {2} | {3}' -f $propertyDataType, $state, $property.Description, ($property.ValueMap -join ' / '))
                                }
                            }
                            $currentDataObject.$($property.Name) = $result
                        }
                    }
                }

                $indent--
                [void]$configString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $indent), '}'))
            }

            # Last workload is processed. Make sure the this resource is also saved to file
            [void]$configString.Append('}')
            Save-Resource -Config $configString.ToString() -Workload $lastWorkload -Version $Version -OutputPath $OutputPath

            Write-Host -Object 'Writing ConfigurationData file' -ForegroundColor Cyan
            $psdStringData = "# ($(Get-Date -f 'yyyy-MM-dd HH:mm:ss')) Generated using Microsoft365DSC v$($m365Module.Version)`n"
            $psdStringData += $configData | ConvertTo-Psd
            $psdPath = Join-Path -Path $OutputPath -ChildPath "M365DSC.CompositeResources\$Version\M365ConfigurationDataExample.psd1"
            Set-Content -Path $psdPath -Value $psdStringData

            Write-Host -Object 'Encountered issues:' -ForegroundColor Cyan
            foreach ($err in $script:errors)
            {
                Write-Host -Object ("{0,-10} | {1}"-f $err.Type,$err.Message)
            }

            return $true
        }
        else
        {
            # Can't generate the module, since the Microsoft365DSC module cannot be found.
            Write-Host -Object 'Microsoft365DSC not found!' -ForegroundColor Red
            return $false
        }
        #endregion

    }
}
