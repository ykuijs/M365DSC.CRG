function ConvertTo-Psd
{
    <#
        .Synopsis
        Converts the inputted object to a hashtable in string format, which can be saved as PSD.

        .Description
        This function converts the inputted object to a string format, which can then be saved to a PSD1 file.

        .Example
        $configData = @{
            Value1 = "String1"
            Value2 = 25
            Value3 = @{
                Value4 = "String2"
                Value5 = 50
            }
            Value6 = @(
                @{
                    Value7 = "String3"
                    Value8 = 75
                }
            )
        }
        $configData | ConvertTo-Psd

        .Parameter InputObject
        The InputObject parameter specified the object that has to be converted into PSD format.

        .Parameter Depth
        The Depth parameter specifies how deep the recursion should go.

        .Parameter Indent
        The Indent parameter is the number of spaces that need to be indented.
    #>
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Position = 0, ValueFromPipeline = 1)]
        [System.Object]
        $InputObject,

        [Parameter()]
        [System.Int32]
        $Depth,

        [Parameter()]
        [System.String]
        $Indent
    )

    begin
    {
        $objects = [System.Collections.Generic.List[object]]@()
    }

    process
    {
        $objects.Add($InputObject)
    }

    end
    {
        trap
        {
            Invoke-TerminatingError $_
        }

        $script:Depth = $Depth
        $script:Pruned = 0
        $script:Indent = Convert-Indent -Indent $Indent
        $script:Writer = New-Object System.IO.StringWriter
        try
        {
            foreach ($object in $objects)
            {
                Write-Psd -Object $object
            }
            $script:Writer.ToString().TrimEnd()
            if ($script:Pruned)
            {
                Write-Warning "ConvertTo-Psd truncated $script:Pruned objects."
            }
        }
        finally
        {
            $script:Writer = $null
        }
    }
}
