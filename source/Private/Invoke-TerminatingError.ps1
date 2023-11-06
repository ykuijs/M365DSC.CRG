function Invoke-TerminatingError
{
    <#
        .Synopsis
        Throws a terminating error.

        .Description
        This function throws a terminating error, which makes sure the code actually stops.

        .Example
        Invoke-TerminatingError

        .Parameter M
        The M parameter is the message that needs to be displayed when the error is thrown.
      #>
    [CmdletBinding()]
    [OutputType()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $M
    )

    process
    {
        $PSCmdlet.ThrowTerminatingError((New-Object System.Management.Automation.ErrorRecord ([Exception]"$M"), $null, 0, $null))
    }
}
