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

1. Crie uma cópia deste repositório.
2. Abra no GitHub Codespaces.
3. Aguarde o ambiente iniciar.
4. Coloque os arquivos do projeto dentro da pasta `htdocs`.
5. Acesse a aplicação PHP pela porta `80`.
6. Acesse o phpMyAdmin pelo caminho `/phpmyadmin`.

## Acessos

Aplicação PHP:

```text
http://localhost
```

phpMyAdmin:

```text
http://localhost/phpmyadmin
```

Banco de dados:

```text
Host: localhost
Porta: 3306
Usuario: root
Senha: deixe em branco
```

Nenhum banco de dados é criado automaticamente. Crie o banco pelo phpMyAdmin ou pelo terminal.

## Terminal MySQL

Para entrar no MySQL como root:

```bash
mysql -u root
```

Para criar um banco de dados pelo terminal:

```bash
mysql -u root -e "CREATE DATABASE nome_do_banco;"
```

## Exemplo de conexao PHP

Depois de criar um banco, use o host `localhost` para conectar no MariaDB:

```php
<?php
$conn = new mysqli('localhost', 'root', '', 'nome_do_banco');

if ($conn->connect_error) {
    die('Erro ao conectar: ' . $conn->connect_error);
}

echo 'Conectado ao banco de dados!';
```
