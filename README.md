# Guia Técnico de Instalação e Utilização da VM com VirtualBox e Vagrant

Este guia detalha como obter o projeto, instalar o VirtualBox e Vagrant, e como executar e gerenciar a máquina virtual (VM) definida pelo `Vagrantfile` contido neste repositório. O objetivo é fornecer instruções precisas para configurar um ambiente de desenvolvimento ou teste baseado na VM `debian/bookworm64` com LAMP stack.

## Sumário

- [Pré-requisitos](#pré-requisitos)
- [Passo 0: Obtendo o Projeto](#passo-0-obtendo-o-projeto)
  - [Opção A: Usando Git (Recomendado)](#opção-a-usando-git-recomendado)
  - [Opção B: Baixando o Arquivo ZIP](#opção-b-baixando-o-arquivo-zip)
- [Passo 1: Instalação do VirtualBox](#passo-1-instalação-do-virtualbox)
- [Passo 2: Instalação do Vagrant](#passo-2-instalação-do-vagrant)
- [Passo 3: Inicializando a Máquina Virtual](#passo-3-inicializando-a-máquina-virtual)
- [Passo 4: Gerenciando o Ciclo de Vida da VM](#passo-4-gerenciando-o-ciclo-de-vida-da-vm)
- [Passo 5: Acessando a Máquina Virtual](#passo-5-acessando-a-máquina-virtual)
- [Passo 6: Como Usar o Ambiente](#passo-6-como-usar-o-ambiente)
- [Passo 7: Informações Adicionais e Troubleshooting](#passo-7-informações-adicionais-e-troubleshooting)
- [Conclusão](#conclusão)

## Pré-requisitos

Antes de começar, certifique-se de que você possui:

- **Conexão com a internet:** Necessária para download dos softwares e da imagem da VM.
- **Privilégios de administrador:** Requerido para instalar VirtualBox e Vagrant.
- **Virtualização Habilitada na BIOS/UEFI:** Verifique se as tecnologias de virtualização (VT-x para Intel, AMD-V para AMD) estão ativadas na configuração da BIOS/UEFI do seu computador. Isso é essencial para o VirtualBox funcionar corretamente.
- **Git (Opcional, mas recomendado):** Necessário se você escolher a Opção A no Passo 0 para obter o projeto. Você pode baixá-lo em [git-scm.com](https://git-scm.com/).
- **Espaço em Disco:** Reserve alguns GB de espaço livre para o VirtualBox, Vagrant, a imagem base da VM (debian/bookworm64) e os dados da própria VM.

## Passo 0: Obtendo o Projeto

Você precisa baixar os arquivos de configuração deste repositório (`Vagrantfile`, pasta `www-vm`, script de provisionamento) para sua máquina local. Escolha uma das opções abaixo:

### Opção A: Usando Git (Recomendado)

Se você tem o Git instalado, este é o método preferido, pois facilita futuras atualizações.

1.  **Abra o Terminal:**
    * **Windows:** Prompt de Comando, PowerShell ou Git Bash.
    * **macOS/Linux:** Terminal.
2.  **Navegue até o diretório onde deseja salvar o projeto.** (Ex: `cd Documentos`)
3.  **Clone o repositório:**
    ```bash
    git clone https://github.com/ferreira-mr/infra-competidor.git
    ```
4.  **Acesse a pasta do projeto:** O Git criará uma pasta chamada `infra-competidor`. Entre nela:
    ```bash
    cd infra-competidor
    ```
    **Você executará os próximos comandos do Vagrant (Passo 3 em diante) dentro desta pasta.**

### Opção B: Baixando o Arquivo ZIP

Se você não tem ou não quer usar o Git.

1.  **Acesse o Repositório:** Abra [https://github.com/ferreira-mr/infra-competidor/](https://github.com/ferreira-mr/infra-competidor/) no seu navegador.
2.  **Baixe o ZIP:** Clique no botão verde "<> Code", e depois em "Download ZIP" ou [diretamente neste link](https://github.com/ferreira-mr/infra-competidor/archive/refs/heads/master.zip).
3.  **Extraia o Arquivo:** Localize o arquivo `.zip` baixado (geralmente `infra-competidor-main.zip` ou similar) e extraia seu conteúdo para um local de sua preferência. Isso criará uma pasta (provavelmente chamada `infra-competidor-main`).
4.  **Abra o Terminal:**
    * **Windows:** Prompt de Comando, PowerShell.
    * **macOS/Linux:** Terminal.
5.  **Acesse a pasta do projeto:** Use o comando `cd` para navegar até a pasta que você acabou de extrair. **Verifique o nome exato da pasta!**
    ```bash
    # Exemplo (o nome da pasta pode variar):
    cd /caminho/para/onde/voce/extraiu/infra-competidor-main
    ```
    **Você executará os próximos comandos do Vagrant (Passo 3 em diante) dentro desta pasta.**

---

*A partir daqui, todos os comandos `vagrant` devem ser executados dentro da pasta do projeto (`infra-competidor` ou `infra-competidor-main`).*

---

## Passo 1: Instalação do VirtualBox

O VirtualBox atuará como o provedor (hipervisor) para nossa máquina virtual.

1.  **Download:** Acesse [www.virtualbox.org](https://www.virtualbox.org), clique em "Downloads" e baixe o instalador para o seu sistema operacional (Windows, macOS, Linux).
2.  **Instalação:** Execute o instalador e siga as instruções. Mantenha as opções padrão, a menos que saiba o que está fazendo. Conceda permissões para instalar drivers de rede se solicitado.
3.  **Verificação:** Abra o VirtualBox após a instalação para garantir que ele inicia sem erros.
4.  **(Alternativa):** Em Linux ou macOS, você pode preferir instalar via gerenciador de pacotes (ex: `sudo apt install virtualbox` no Debian/Ubuntu, `brew install --cask virtualbox` no macOS com Homebrew).

## Passo 2: Instalação do Vagrant

O Vagrant automatiza a criação e o gerenciamento da VM.

1.  **Download:** Acesse [www.vagrantup.com](https://www.vagrantup.com), clique em "Download" e baixe a versão para o seu sistema operacional.
2.  **Instalação:** Execute o instalador e siga as instruções. Pode ser necessário reiniciar o computador após a instalação.
3.  **Verificação:** Abra um **novo** terminal (importante para reconhecer o Vagrant após a instalação) e execute:
    ```bash
    vagrant --version
    ```
    Se a versão for exibida, a instalação foi bem-sucedida.
4.  **(Alternativa):** Em Linux ou macOS, você pode preferir instalar via gerenciador de pacotes (ex: `sudo apt install vagrant`, `brew install vagrant`).

## Passo 3: Inicializando a Máquina Virtual

Agora que as ferramentas estão instaladas e você está dentro da pasta do projeto (obtida no Passo 0), vamos iniciar a VM.

1.  **Certifique-se de estar no diretório correto:** Use `pwd` (Linux/macOS) ou `cd` (Windows) no terminal para confirmar que você está na pasta `infra-competidor` (ou `infra-competidor-main`). O arquivo `Vagrantfile` deve estar presente neste diretório.
2.  **Execute o comando `vagrant up`:**
    ```bash
    vagrant up
    ```
    Este comando fará o seguinte:
    * **Verifica/Baixa a Box:** Confere se a imagem base (`debian/bookworm64`) existe localmente. Caso contrário, faz o download (pode levar algum tempo na primeira vez).
    * **Cria a VM:** Instancia uma nova máquina virtual no VirtualBox.
    * **Configura Recursos:** Aloca 1024MB de RAM e 1 CPU (conforme definido no `Vagrantfile`).
    * **Configura Rede:** Estabelece uma rede privada com o IP estático `192.168.56.10`.
    * **Sincroniza Pastas:** Mapeia a pasta local `./www-vm` (dentro da pasta do projeto) para o diretório `/var/www/html` dentro da VM.
    * **Executa Provisionamento:** Roda o script de configuração (`provision.sh`, localizado na pasta do projeto) para instalar e configurar o ambiente LAMP (Apache2, MariaDB, PHP - verifique o script para versões exatas) e criar o usuário `competidor`.
    * **Inicia a VM:** Liga a máquina virtual.

Aguarde até que o processo seja concluído. Você verá várias mensagens no terminal.

## Passo 4: Gerenciando o Ciclo de Vida da VM

Use estes comandos do Vagrant (sempre dentro da pasta do projeto) para gerenciar a VM:

-   **Ligar/Iniciar ou Continuar (Resume):**
    ```bash
    vagrant up
    ```
-   **Desligar (Shutdown):**
    ```bash
    vagrant halt
    ```
-   **Pausar (Salvar Estado Atual):**
    ```bash
    vagrant suspend
    ```
-   **Reiniciar:**
    ```bash
    vagrant reload
    ```
    (Aplica mudanças no `Vagrantfile` ou reinicia após `halt`)
-   **Executar Provisionamento Novamente:** Se precisar rodar o script `provision.sh` de novo (ex: após uma falha ou alteração no script):
    ```bash
    vagrant provision
    ```
-   **Destruir (Apagar Completamente a VM):** Use com cuidado! Isso remove a VM do VirtualBox. Seus dados *dentro* da VM (exceto na pasta sincronizada `/var/www/html`) serão perdidos.
    ```bash
    vagrant destroy
    ```
    (Será necessário confirmar com `y`).

## Passo 5: Acessando a Máquina Virtual

Após o `vagrant up` ser concluído com sucesso, você pode acessar a VM:

-   **Via Navegador (Servidor Web Apache):**
    Abra seu navegador e acesse: `http://192.168.56.10`
    Você deverá ver a página padrão do Apache ou o conteúdo da pasta `./www-vm`.

-   **Via SFTP (Transferência de Arquivos):**
    Use um cliente SFTP (como FileZilla, WinSCP, Cyberduck):
    -   **Host/Servidor:** `192.168.56.10`
    -   **Usuário:** `competidor`
    -   **Senha:** `senai914`
    -   **Porta:** `22`

-   **Via SSH (Acesso ao Terminal da VM):**
    No seu terminal local:
    ```bash
    ssh competidor@192.168.56.10
    ```
    Quando solicitado, digite a **Senha:** `senai914`

    **(Alternativa SSH mais simples):** O Vagrant configura um atalho. Dentro da pasta do projeto, execute:
    ```bash
    vagrant ssh
    ```
    Isso conecta você diretamente via SSH sem precisar de senha (usa chave gerenciada pelo Vagrant).

-   **Acesso ao Banco de Dados (MariaDB):**
    1.  Conecte-se à VM via SSH (`vagrant ssh` ou `ssh competidor@192.168.56.10`).
    2.  Dentro da VM, acesse o MariaDB:
        ```bash
        mysql -u competidor -p
        ```
        Digite a senha `senai914` quando solicitado.
        *(Nota: O script de provisionamento pode ter configurado outras credenciais ou o acesso root. Verifique `provision.sh` para detalhes)*.

**⚠️ Nota de Segurança:** A senha `senai914` é definida para facilitar o acesso inicial em ambiente de desenvolvimento local. **Não utilize esta configuração em produção ou ambientes expostos.** Para maior segurança, considere alterar a senha do usuário `competidor` dentro da VM (`passwd competidor`) e configurar o acesso SSH via chaves públicas/privadas em vez de senha.

## Passo 6: Como Usar o Ambiente

1.  **Desenvolvimento Web:** Coloque os arquivos do seu site ou aplicação (PHP, HTML, CSS, JS) na pasta `./www-vm` no seu computador. Eles aparecerão automaticamente em `http://192.168.56.10` devido à sincronização de pastas.
2.  **Gerenciamento do Banco de Dados:** Use o cliente `mysql` via SSH (como mostrado acima) ou instale uma ferramenta gráfica como phpMyAdmin dentro da VM, se necessário.
3.  **Executar Comandos na VM:** Use a conexão SSH (`vagrant ssh`) para instalar pacotes adicionais (`sudo apt update && sudo apt install <pacote>`), gerenciar serviços (`sudo systemctl status apache2`), etc.

## Passo 7: Informações Adicionais e Troubleshooting

-   **Erro "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!":**
    Isso geralmente acontece se você destruiu (`vagrant destroy`) e recriou (`vagrant up`) a VM. A identidade SSH da VM mudou. Solução: remova a chave antiga do seu arquivo `known_hosts`. No seu terminal local, execute:
    ```bash
    ssh-keygen -R 192.168.56.10
    ```
    Tente conectar via SSH novamente.

-   **VM não inicia / Erros durante `vagrant up`:**
    -   Verifique se a **virtualização está habilitada na BIOS/UEFI**.
    -   Verifique se não há **conflitos de porta** (ex: se outro serviço já usa a porta 80 ou 22 mapeada). Veja o `Vagrantfile` para mapeamentos.
    -   Observe atentamente as mensagens de erro no terminal.
    -   Tente `vagrant destroy -f && vagrant up` para recriar do zero (cuidado, apaga a VM!).
    -   Verifique a interface gráfica do VirtualBox para mensagens de erro específicas da VM.

-   **Provisionamento Falhou ou Incompleto:**
    Se a VM subiu (`vagrant up` terminou) mas o Apache/PHP/MariaDB não parecem funcionar, tente rodar o provisionamento novamente:
    ```bash
    vagrant provision
    ```

-   **Verificar Status da VM:**
    Use este comando para ver o estado atual da VM (rodando, desligada, salva, etc.):
    ```bash
    vagrant status
    ```

## Conclusão

Este guia forneceu os passos para obter o projeto, configurar o ambiente necessário (VirtualBox, Vagrant) e iniciar/gerenciar a máquina virtual de desenvolvimento. Utilize os comandos do Vagrant e as informações de acesso para interagir com sua VM. Consulte o `Vagrantfile` e o script `provision.sh` neste repositório para detalhes específicos da configuração. Esperamos que este ambiente facilite seu trabalho!
