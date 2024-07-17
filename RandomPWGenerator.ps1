function Generate-RandomPassword {
    param (
        [int]$length = 10
    )
    
    $characters = @()
    $characters += [char[]](65..90)    # A-Z
    $characters += [char[]](97..122)   # a-z
    $characters += [char[]](48..57)    # 0-9
    $characters += [char[]](33..47)    # Special characters !"#$%&'()*+,-./
    $characters += [char[]](58..64)    # Special characters :;<=>?@
    $characters += [char[]](91..96)    # Special characters [\]^_`
    $characters += [char[]](123..126)  # Special characters {|}~

    $password = -join ((1..$length) | ForEach-Object { $characters | Get-Random })
    return $password
}

# Generate a random 10-character password
$password = Generate-RandomPassword -length 10
Write-Output $password
