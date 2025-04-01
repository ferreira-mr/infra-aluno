
# Guia Completo de Instalação do VirtualBox e Vagrant

Este guia irá te ajudar a instalar o **VirtualBox** e o **Vagrant** no seu computador e te ensinar a executar uma máquina virtual usando o arquivo **Vagrantfile**. Siga as instruções passo a passo para garantir que tudo funcione corretamente.

## Passo 1: Instalando o VirtualBox

O **VirtualBox** é uma ferramenta que permite criar e gerenciar máquinas virtuais. Vamos instalar essa ferramenta primeiro.

1. **Acesse o site do VirtualBox:**
   - Vá até [https://www.virtualbox.org](https://www.virtualbox.org).

2. **Baixe o instalador:**
   - Na página inicial, clique em **"Download VirtualBox"**.
   - Escolha a versão do VirtualBox que corresponde ao seu sistema operacional (Windows, macOS ou Linux).

3. **Execute o instalador:**
   - Após o download, abra o arquivo de instalação.
   - Siga as instruções do instalador para concluir a instalação. Se aparecerem opções, deixe as configurações padrão.

4. **Verifique se a instalação foi bem-sucedida:**
   - Abra o **VirtualBox** no seu computador. Se o programa abrir sem erros, a instalação foi concluída corretamente.

## Passo 2: Instalando o Vagrant

O **Vagrant** é uma ferramenta que automatiza a criação e gerenciamento de ambientes de desenvolvimento virtualizados. Vamos instalá-lo.

1. **Acesse o site do Vagrant:**
   - Vá até [https://www.vagrantup.com](https://www.vagrantup.com).

2. **Baixe o instalador:**
   - Na página inicial, clique em **"Download"**.
   - Escolha a versão do Vagrant que corresponde ao seu sistema operacional.

3. **Execute o instalador:**
   - Após o download, abra o arquivo de instalação.
   - Siga as instruções na tela para concluir a instalação.

4. **Verifique a instalação do Vagrant:**
   - Abra o **terminal** (Prompt de Comando no Windows ou Terminal no macOS/Linux) e digite o comando:

     ```bash
     vagrant --version
     ```

   - Se o Vagrant mostrar a versão instalada, significa que a instalação foi bem-sucedida.

## Passo 3: Executando a Máquina Virtual com Vagrant

Agora que o VirtualBox e o Vagrant estão instalados, é hora de iniciar a máquina virtual.

1. **Baixe ou clone o repositório com o Vagrantfile:**
   - Se você já tem o repositório com o arquivo `Vagrantfile`, ótimo! Caso contrário, baixe ou clone o repositório que contém o arquivo `Vagrantfile` para o seu computador.

2. **Abra o terminal na pasta onde está o `Vagrantfile`:**
   - No **Windows**, abra o **Prompt de Comando**.
   - No **macOS/Linux**, abra o **Terminal**.

   Em seguida, use o comando `cd` para navegar até a pasta que contém o arquivo `Vagrantfile`. Por exemplo:

   ```bash
   cd /caminho/para/o/diretorio/do/vagrantfile
   ```

## Passo 4: Parando a Máquina Virtual

Quando terminar de usar a máquina virtual, você pode pará-la (sem destruí-la) para usá-la novamente mais tarde.

### Parar a VM:

Use o seguinte comando no terminal para desligar a máquina virtual de forma segura:

```bash
vagrant halt
```

Isso vai parar a máquina, mas manterá a configuração e os dados para a próxima vez que você usar o comando `vagrant up`.

## Passo 5: Destruindo e Apagando a Máquina Virtual

Se você quiser remover completamente a máquina virtual e começar tudo do zero, use o comando `vagrant destroy`.

### Destruir a máquina virtual:

Para apagar a VM e todos os dados dentro dela, execute:

```bash
vagrant destroy
```

Este comando não pode ser desfeito e irá apagar a máquina virtual permanentemente.

### Subir uma nova VM do zero:

Após destruir a máquina virtual, você pode iniciar uma nova com o comando:

```bash
vagrant up
```

O Vagrant irá baixar novamente a imagem e iniciar uma nova máquina virtual.

## Passo 6: Comandos para Criar, Destruir e Desligar as Máquinas Virtuais

Aqui estão os comandos principais que você vai usar para criar, destruir e desligar as máquinas virtuais no Vagrant:

### Criar e iniciar uma nova máquina virtual:

Para criar e iniciar uma nova máquina virtual com base no arquivo Vagrantfile, use:

```bash
vagrant up
```

Esse comando irá iniciar a VM, fazendo o download da imagem, se necessário, e configurando a máquina virtual.

### Desligar a máquina virtual sem destruí-la:

Se você quiser parar a máquina virtual sem apagá-la, use:

```bash
vagrant halt
```

Este comando desliga a máquina virtual de forma segura, mas a deixa disponível para ser iniciada novamente no futuro.

### Destruir a máquina virtual:

Para remover completamente a máquina virtual e apagar todos os dados, use:

```bash
vagrant destroy
```

Atenção: Este comando apaga todos os dados e configurações da máquina virtual e não pode ser desfeito. Após destruí-la, você precisará rodar o comando `vagrant up` novamente para recriar a máquina.

### Reiniciar a máquina virtual (se já estiver em execução):

Se a máquina virtual já estiver em execução e você quiser reiniciá-la, use:

```bash
vagrant reload
```

Este comando vai reiniciar a VM e aplicar quaisquer mudanças feitas no arquivo Vagrantfile.

## Passo 7: Dicas e Problemas Comuns

- **Erro ao iniciar a VM:** Se você encontrar problemas ao rodar o comando `vagrant up`, tente verificar se o VirtualBox está instalado corretamente e se sua máquina tem memória suficiente para rodar a VM.
  
- **Erro no Windows ao rodar `vagrant up`:** Certifique-se de que o Vagrant e o VirtualBox foram instalados corretamente e que o comando `vagrant` está acessível no terminal. Pode ser necessário reiniciar o computador após a instalação.

- **Necessidade de privilégios de administrador:** Se o seu sistema pedir privilégios de administrador durante a instalação do VirtualBox ou Vagrant, clique em "Sim" ou "Permitir" para continuar a instalação.

-**Erro "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!": Um novo servidor foi criado com o o mesm IP, é necessário limpar a chave ssh para este IP**
```bash
ssh-keygen -R 192.168.56.10
```

Se você ainda tiver problemas, consulte a documentação oficial ou entre em contato com o seu instrutor.

## Conclusão

Agora que você configurou o VirtualBox e o Vagrant, pode começar a criar e gerenciar máquinas virtuais de maneira fácil e automatizada. Aproveite a flexibilidade de testar ambientes diferentes e explorar novas tecnologias!

Boa sorte e bons estudos! 😄
