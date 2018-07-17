gci -Recurse -File | Where-Object Name -Like "*gem*" | Select-Object Name, {"{0:N2}KB" -f ($_.Length / 1kb)}

# mesma coisa com alians
gci -Recurse -File | ? Name -Like "*gem*" | select Name, {"{0:N2}KB" -f ($_.Length / 1kb)}

# mesma coisa com `
gci -Recurse -File `
  | ? Name -Like "*gem*" `
  | select `
      Name, `
        {"{0:N2}KB" -f ($_.Length / 1kb)}

# mesma coisa com |
gci -Recurse -File |
  ? Name -Like "*gem*" |
  select `
    Name, `
      {"{0:N2}KB" -f ($_.Length / 1kb)}

# refatorando o código
$nameExpr = "Name"
$lengthExpr = {"{0:N2}KB" -f ($_.Length / 1kb)}

$params = $nameExpr, $lengthExpr
gci -Recurse -File |
  ? Name -Like "*gem*" |
  select $params

  
# criando um Hashtable para exibir nome e expressão
$nameExpr = @{}
$nameExpr.Add("Label", "Name")
$nameExpr.Add("Expression", { $_.Name })

$lengthExpr = @{}
$lengthExpr.Add("Label", "Tamanho")
$lengthExpr.Add("Expression", { "{0:N2}KB" -f ($_.Length / 1kb)})

$params = $nameExpr, $lengthExpr

gci -Recurse -File |
  ? Name -Like "*gem*" |
  select $params

  #ou modo mais legível
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

  gci -Recurse -File |
    ? Name -Like "*gem*" |
    select $params