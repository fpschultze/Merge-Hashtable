function Merge-Hashtable {
    [CmdletBinding()]
    param (
        # Hashtable with default values
        [Parameter(Mandatory = $true)]
        [hashtable]
        $Default,

        # Hashtable with custom values
        [Parameter(Mandatory = $true)]
        [hashtable]
        $Custom
    )

    function Set-Keys ($Default, $Custom) {
        @($Default.Keys) |
            Where-Object {$Custom.ContainsKey($_)} |
            ForEach-Object {
            if (($Default.$_ -is [hashtable]) -and ($Custom.$_ -is [hashtable])) {
                Set-Keys -Default $Default.$_ -Custom $Custom.$_
            }
            else {
                $Default.Remove($_)
                $Default.Add($_, $Custom.$_)
            }
        }
    }

    function Add-Keys ($Default, $Custom) {
        @($Custom.Keys) |
            ForEach-Object {
            if ($Default.ContainsKey($_)) {
                if (($Custom.$_ -is [hashtable]) -and ($Default.$_ -is [hashtable])) {
                    Add-Keys -Default $Default.$_ -Custom $Custom.$_
                }
            }
            else {
                $Default.Add($_, $Custom.$_)
            }
        }
    }

    $newHashTable = $Default.Clone()
    Set-Keys -Default $newHashTable -Custom $Custom
    Add-Keys -Default $newHashTable -Custom $Custom

    Write-Output $newHashTable
}
