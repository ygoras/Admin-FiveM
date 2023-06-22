# Admin-FiveM

Trabalhando no desenvolvimento da Carandiru Roleplay, nos deparamos com uma questão:

- Jogadores que possuem cargos de ADMIN, STREAM, STAFF, entre outros, devem possuir comandos quando setados no grupo.
  
Com essa informação, foi realizado uma verificação do grupo do jogador através do banco de dados conectado na base e permitindo ou não seu acesso aos comandos com variações de local, uso, items, cargos, etc. Além disso, por diversos comandos também possuirem "poderes" de administradores, adição de itens, ou algo que possa beneficiar ou prejudicar os usuários, alguns comandos possuem uma log de uso enviada para o Discord através de uma webhook.
