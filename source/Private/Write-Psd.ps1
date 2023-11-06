function Write-Psd
{
    <#
        .Synopsis
        Converts an object into a string so it can be written to PSD file.

        .Description
        This function converts an inputted object into a string so it can be written to a PSD1 file.

        .Example
        Write-Psd -Object $configData

        .Parameter Object
        Specifies the object that needs to be converted to a string.

        .Parameter Depth
        Specifies how deep the recursion should go. The default is 0, which means no recursion.

        .Parameter NoIndent
        Specifies that the output should not be indented.
    #>
    [CmdletBinding()]
    [OutputType()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Object,

        [Parameter()]
        [System.Int32]
        $Depth = 0,

        [Parameter()]
        [switch]
        $NoIndent
    )

    process
    {
        $indent1 = $script:Indent * $Depth
        if (!$NoIndent)
        {
            $script:Writer.Write($indent1)
        }

        if ($null -eq $Object)
        {
            $script:Writer.WriteLine('$null')
            return
        }

        $type = $Object.GetType()
        switch ([System.Type]::GetTypeCode($type))
        {
            Object
            {
                if ($type -eq [System.Guid] -or $type -eq [System.Version])
                {
                    $script:Writer.WriteLine("'{0}'", $Object)
                    return
                }
                if ($type -eq [System.Management.Automation.SwitchParameter])
                {
                    $script:Writer.WriteLine($(if ($Object)
                            {
                                '$true'
                            }
                            else
                            {
                                '$false'
                            }))
                    return
                }
                if ($type -eq [System.Uri])
                {
                    $script:Writer.WriteLine("'{0}'", $Object.ToString().Replace("'", "''"))
                    return
                }
                if ($script:Depth -and $Depth -ge $script:Depth)
                {
                    $script:Writer.WriteLine("''''")
                    ++$script:Pruned
                    return
                }
                if ($Object -is [System.Collections.IDictionary])
                {
                    if ($Object.Count)
                    {
                        $itemNo = 0
                        $script:Writer.WriteLine('@{')
                        $indent2 = $script:Indent * ($Depth + 1)
                        foreach ($e in $Object.GetEnumerator())
                        {
                            $key = $e.Key
                            $value = $e.Value
                            $keyType = $key.GetType()
                            if ($keyType -eq [string])
                            {
                                if ($key -match '^\w+$' -and $key -match '^\D')
                                {
                                    $script:Writer.Write('{0}{1} = ', $indent2, $key)
                                }
                                else
                                {
                                    $script:Writer.Write("{0}'{1}' = ", $indent2, $key.Replace("'", "''"))
                                }
                            }
                            elseif ($keyType -eq [int])
                            {
                                $script:Writer.Write('{0}{1} = ', $indent2, $key)
                            }
                            elseif ($keyType -eq [long])
                            {
                                $script:Writer.Write('{0}{1}L = ', $indent2, $key)
                            }
                            elseif ($script:Depth)
                            {
                                ++$script:Pruned
                                $script:Writer.Write('{0}item__{1} = ', $indent2, ++$itemNo)
                                $value = New-Object 'System.Collections.Generic.KeyValuePair[object, object]' $key, $value
                            }
                            else
                            {
                                throw "Not supported key type '$($keyType.FullName)'."
                            }
                            Write-Psd -Object $value -Depth ($Depth + 1) -NoIndent
                        }
                        $script:Writer.WriteLine("$indent1}")
                    }
                    else
                    {
                        $script:Writer.WriteLine('@{}')
                    }
                    return
                }
                if ($Object -is [System.Collections.IEnumerable])
                {
                    $script:Writer.Write('@(')
                    $empty = $true
                    foreach ($e in $Object)
                    {
                        if ($empty)
                        {
                            $empty = $false
                            $script:Writer.WriteLine()
                        }
                        Write-Psd -Object $e -Depth ($Depth + 1)
                    }
                    if ($empty)
                    {
                        $script:Writer.WriteLine(')')
                    }
                    else
                    {
                        $script:Writer.WriteLine("$indent1)" )
                    }
                    return
                }
                if ($Object -is [scriptblock])
                {
                    $script:Writer.WriteLine('{{{0}}}', $Object)
                    return
                }
                if ($Object -is [PSCustomObject] -or $script:Depth)
                {
                    $script:Writer.WriteLine('@{')
                    $indent2 = $script:Indent * ($Depth + 1)
                    foreach ($e in $Object.PSObject.Properties)
                    {
                        $key = $e.Name
                        if ($key -match '^\w+$' -and $key -match '^\D')
                        {
                            $script:Writer.Write('{0}{1} = ', $indent2, $key)
                        }
                        else
                        {
                            $script:Writer.Write("{0}'{1}' = ", $indent2, $key.Replace("'", "''"))
                        }
                        Write-Psd -Object $e.Value -Depth ($Depth + 1) -NoIndent
                    }
                    $script:Writer.WriteLine("$indent1}")
                    return
                }
            }
            String
            {
                $script:Writer.WriteLine("'{0}'", $Object.Replace("'", "''"))
                return
            }
            Boolean
            {
                $script:Writer.WriteLine($(if ($Object)
                        {
                            '$true'
                        }
                        else
                        {
                            '$false'
                        }))
                return
            }
            DateTime
            {
                $script:Writer.WriteLine("[DateTime] '{0}'", $Object.ToString('o'))
                return
            }
            Char
            {
                $script:Writer.WriteLine("'{0}'", $Object.Replace("'", "''"))
                return
            }
            DBNull
            {
                $script:Writer.WriteLine('$null')
                return
            }
            default
            {
                if ($type.IsEnum)
                {
                    $script:Writer.WriteLine("'{0}'", $Object)
                }
                else
                {
                    $script:Writer.WriteLine($Object)
                }
                return
            }
        }

        throw "Not supported type '{0}'." -f $type.FullName
    }
}
