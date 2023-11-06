function Convert-Indent
{
    <#
        .Synopsis
        Converts a numbered indentation into spaces or tabs

        .Description
        This function converts a numbered indentation into spaces or tabs.

        .Example
        Convert-Ident -Indent 2

        .Parameter Indent
        The Indent parameter is the number of spaces or tabs that need to be returned.
    #>
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter()]
        [System.String]
        $Indent
    )

    process
    {
        switch ($Indent)
        {
            ''
            {
                return '    '
            }
            '1'
            {
                return "`t"
            }
            '2'
            {
                return '  '
            }
            '4'
            {
                return '    '
            }
            '0'
            {
                return ''
            }
        }
        $Indent
    }
}
