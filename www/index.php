<?php
// Obtendo as informações
$apache_version = apache_get_version();
$php_version = phpversion();
$mysql_version = mysqli_get_client_version();

?>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
  <meta charset="UTF-8">
  <title>Bem-vindo ao Servidor de Treinamento da SP Skills!</title>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Montserrat', sans-serif;
      background-color: #ffffff;
      color: #000000;
      margin: 0;
      padding: 0;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
      text-align: center;
    }

    h1 {
      color: #e30613;
      margin-bottom: 20px;
      font-weight: 600;
    }

    p {
      max-width: 900px;
      line-height: 1.6;
      font-weight: 300;
    }

    .logo {
      margin-bottom: 20px;
      width: 350px;
      height: auto;
    }

    .footer {
            margin-top: 30px;
            font-size: 0.9em;
            color: #666666;
        }
  </style>
</head>

<body>
  <img src="senai-logo.png" alt="Logo SENAI-SP" class="logo">
  <h1>Seja bem-vindo ao servidor de treinamento da SP Skills!</h1>
  <p>Este servidor foi configurado para auxiliar no desenvolvimento das suas habilidades. Explore os recursos
    disponíveis e aproveite ao máximo seu treinamento.</p>

  <div class="footer">
    <p><strong>Versão do Apache:</strong> <?php echo $apache_version; ?></p>
    <p><strong>Versão do PHP:</strong> <?php echo $php_version; ?></p>
    <p><strong>Versão do MySQL:</strong> <?php echo $mysql_version; ?></p>
  </div>
</body>

</html>
