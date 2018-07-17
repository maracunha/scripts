#parametro de excução
param($procurarPor, $tipoDeExportacao)

<#
$procurarPor é uma variável para descobir algo no diretário, um arquivo.

podemos usar como parametros:
Primeiro -> o que arquivo vc quer procurar. 
Segundo -> HTML, JSON ou CSV para ter relatórios com esses formatos.
#>

#posso retirar esse comentário, e ele procura por o que estiver aqui. 
#$procurarPor = "*.ps1"

#Caso aconteça um erro, ele para a execução do script
$ErrorActionPreference = "Stop"

#Cria um Hashtable para a coluna do nome
$nameExpr = @{
  Label = "Nome";
  Expression = { $_.Name }
}
#Cria um Hashtable para a coluna do tamanho
$lengthExpr = @{
  Label = "Tamanho";
  Expression = { "{0:N2}KB" -f ($_.Length / 1kb)}
}
#Basta usar uma vírgula e nos temos um array
$params = $nameExpr, $lengthExpr

$resultado =
  gci -Recurse -File |
    ? Name -Like $procurarPor |
    select $params

    if ($tipoDeExportacao -eq "HTML") {
      $estilos = Get-Content C:\codes\Scripts\styles.css
      $styleTag = "<style> $estilos </style>"
      $tituloPagina = "Relatorio de Scripts em Migracao"
      $tituloBody = "<h1> $tituloPagina </h1>"

      $resultado |
        ConvertTo-Html -Head $styleTag -Title $tituloPagina -Body $tituloBody  |
        Out-File C:\codes\Scripts\relatorios\relatorios.html
         } elseif ($tipoDeExportacao -eq "JSON") {
      $resultado |
        ConvertTo-JSON |
        Out-File C:\codes\Scripts\relatorios\relatorios.json
    } elseif ($tipoDeExportacao -eq "CSV") {
      $resultado |
        ConvertTo-CSV -NoTypeInformation |
        Out-File C:\codes\Scripts\relatorios\relatorios.csv
    } else {
      $resultado}