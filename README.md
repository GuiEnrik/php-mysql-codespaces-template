# Servidor Web PHP + MySQL

Ambiente simples para atividades com PHP e MySQL no GitHub Codespaces.

## Recursos

- PHP 8.2 com Apache
- MariaDB/MySQL no mesmo container
- phpMyAdmin para administrar o banco pelo navegador
- Cliente `mysql` no terminal
- Pasta `htdocs` como raiz do projeto PHP
- Página exemplo com "Olá Mundo"

## Como usar

1. Crie uma cópia deste repositório usando o botão `Use this template`.
2. Na cópia do repositório pelo botão "<> Code" > "Codespaces" > "Create codespace on master" para abrir o repositório no GitHub Codespaces.
3. Aguarde o ambiente iniciar.

Os serviços do Apache e do MariaDB são iniciados automaticamente quando o Codespace abre.

## Acessos

No GitHub Codespaces, acesse a aplicação pela URL da porta `80`.

Para encontrar essa URL:

1. Abra a aba `Ports` no painel inferior do VS Code.
2. Procure a porta `80`.
3. Clique em `Open in Browser`.

A URL normalmente aparece neste formato:

```text
https://NOME-DO-CODESPACE-80.app.github.dev
```

Teste acessar o phpMyAdmin pelo url:

```text
https://NOME-DO-CODESPACE-80.app.github.dev/phpmyadmin/
```

No phpMyAdmin, entre com o usuário `root` e deixe o campo de senha vazio.

Nenhum banco de dados é criado automaticamente. Crie o banco pelo phpMyAdmin ou pelo terminal.

## Terminal MySQL

Para entrar no MySQL como root:

```bash
mysql -u root
```

## Se o banco nao conectar

Se aparecer erro de conexão com o MySQL/MariaDB ou com o phpMyAdmin, rode:

```bash
bash .devcontainer/start-codespace-services.sh
```

Depois tente entrar novamente.

Para criar um banco de dados pelo terminal:

```bash
CREATE DATABASE nome_do_banco;
```

## Exemplo de conexao PHP

Depois de criar um banco, use o host `127.0.0.1` para conectar no MariaDB criando o arquivo conecta.php com o código abaixo:

```php
<?php
try {
    $conn = new PDO('mysql:host=127.0.0.1;port=3306;dbname=nome_do_banco;charset=utf8', 'root', '');
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo 'Conectado ao banco de dados!';
} catch (PDOException $e) {
    die('Erro ao conectar: ' . $e->getMessage());
}
```
Para testar, acrescente `/conecta.php` no final do endereço, por exemplo:

```text
https://NOME-DO-CODESPACE-80.app.github.dev/conecta.php
```

Note que foram usados esses dados no código PHP ao MariaDB dentro do Codespace:

```text
Host: 127.0.0.1
Porta: 3306
Usuario: root
Senha: em branco
```

## Salvando o banco de dados

Os bancos criados no MariaDB ficam salvos apenas dentro do Codespace atual.

Se você parar e abrir o mesmo Codespace novamente, os dados normalmente continuam disponíveis. Mas, se o Codespace for apagado, recriado ou reconstruído, os bancos podem ser perdidos.

Para guardar um banco importante, exporte o banco para um arquivo `.sql` na raiz do projeto.

Exemplo:

```bash
mysqldump -u root nome_do_banco > backup.sql
```

Esse comando cria o arquivo `backup.sql` na raiz do projeto, baixe ou comite ele no projeto.

Para restaurar o backup depois:

```bash
mysql -u root nome_do_banco < backup.sql
```
