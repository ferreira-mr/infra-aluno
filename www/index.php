<?php
// Tenta obter as informações do servidor. Usa 'N/A' se a função não existir.
$apache_version = function_exists('apache_get_version') ? apache_get_version() : 'N/A (Não é Apache ou função desabilitada)';
$php_version = phpversion();

// Para a versão do MariaDB/MySQL, é melhor checar a versão do servidor, mas isso exige uma conexão.
// A versão do cliente é uma boa aproximação para saber qual driver está em uso.
$mysql_client_version = function_exists('mysqli_get_client_info') ? mysqli_get_client_info() : 'N/A';
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>SENAI SP - Servidor Local</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 40px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            text-align: center;
        }
        .container {
            background: #ffffff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            max-width: 900px;
            width: 100%;
        }
        h1 {
            color: #e30613;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 2em;
        }
        p {
            line-height: 1.6;
            font-weight: 400;
        }
        .logo {
            margin-bottom: 30px;
            width: 300px;
            height: auto;
        }
        .info-box {
            margin-top: 30px;
            padding: 20px;
            background-color: #fafafa;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-align: left;
        }
        .info-box h2 {
            text-align: center;
            color: #333;
            font-weight: 600;
            margin-top: 0;
        }
        .info-box table {
            width: 100%;
            border-collapse: collapse;
        }
        .info-box th, .info-box td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        .info-box th {
            font-weight: 600;
            color: #e30613;
            text-align: right;
            width: 30%;
        }
        .info-box td {
            font-family: 'Courier New', Courier, monospace;
            font-weight: 600;
            color: #555;
        }
        .footer {
            margin-top: 30px;
            font-size: 0.9em;
            color: #777;
            border-top: 1px solid #eee;
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="senai-logo.png" alt="Logo SENAI-SP" class="logo">
        <h1>Seja bem-vindo ao Servidor Local de Estudos!</h1>
        <p>Este ambiente foi configurado para auxiliar no desenvolvimento das suas habilidades. Explore os recursos disponíveis e aproveite ao máximo seu tempo.</p>

        <div class="info-box">
            <h2>Informações de Acesso</h2>
            <table>
                <tr>
                    <th>IP</th>
                    <td>__VM_IP__</td>
                </tr>
                <tr>
                    <th>SSH (Porta)</th>
                    <td>22</td>
                </tr>
                 <tr>
                    <th>Banco de Dados (Porta)</th>
                    <td>3306</td>
                </tr>
                <tr>
                    <th>PhpMyAdmin</th>
                    <td><a href="http://__VM_IP__/phpmyadmin" target="_blank">http://__VM_IP__/phpmyadmin</a></td>
                </tr>
                <tr>
                    <th>Usuário (BD e SSH)</th>
                    <td>__USER_NAME__</td>
                </tr>
                <tr>
                    <th>Senha (BD e SSH)</th>
                    <td>__USER_PASS__</td>
                </tr>
            </table>
        </div>

        <div class="footer">
            <p><strong>Versão do Apache:</strong> <?php echo $apache_version; ?> | <strong>Versão do PHP:</strong> <?php echo $php_version; ?> | <strong>Cliente MySQL:</strong> <?php echo $mysql_client_version; ?></p>
        </div>
    </div>
</body>
</html>