function Get-TemporaryPath
{
    <#
        .Synopsis
        Gets the temporary path for the operating system

        .Description
        This function retrieves the system temporary path for the operating system.

        .Example
        Get-TemporaryPath
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    process
    {
        $temporaryPath = $null

        switch ($true)
        {
            (-not (Test-Path -Path variable:IsWindows) -or ((Get-Variable -Name 'IsWindows' -ValueOnly -ErrorAction SilentlyContinue) -eq $true))
            {
                # Windows PowerShell or PowerShell 6+
                $temporaryPath = (Get-Item -Path env:TEMP).Value
            }

            ((Get-Variable -Name 'IsMacOs' -ValueOnly -ErrorAction SilentlyContinue) -eq $true)
            {
                $temporaryPath = (Get-Item -Path env:TMPDIR).Value
            }

            ((Get-Variable -Name 'IsLinux' -ValueOnly -ErrorAction SilentlyContinue) -eq $true)
            {
                $temporaryPath = '/tmp'
            }

            default
            {
                throw 'Cannot set the temporary path. Unknown operating system.'
            }
        }

        return $temporaryPath
    }
}
