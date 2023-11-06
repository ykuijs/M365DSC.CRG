function Get-IndentationString
{
    <#
      .SYNOPSIS
      Converts a number into a number of spaces, used for indentation.

      .DESCRIPTION
      This function converts a number into a number of spaces (4x the provided number), so it can be used for indentation.

      .EXAMPLE
      Get-IndentationString -Indentation 2

      .PARAMETER Indentation
      The number of indentations (four spaces) that should be returned.
    #>
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Int32]
        $Indentation
    )

    process
    {
        return ('    ' * $Indentation)
    }
}
