# Bem-vindo ao questions-app

Este webserver-api é um servidor de provas e testes construído com Rails 7 API-only e outros recursos de autorização e autenticação! Com ele, você pode criar, gerenciar e participar de provas com facilidade. Com dois tipos de usuários - administrador e participante - nossos recursos são adaptados às necessidades específicas de cada um. 

<<<<<<< HEAD
### Como usar essa Api:
1) ### Criar um administrador
* Para a criação de usuário no endpoint Registration funciona como um sign-up padrão para o usuário;
* Depois de cadastrado com um formulário de login e senha o endpoint Session faz a identificação e gera o token;
* Com o sistema rodando, todo os usuário criação são categorizados automaticamente como 'Participante' podendo apenas gerenciar sua conta e suas provas;
* Como o gerencimanto e administração só pode ser data se o usuário for admin, o sistema cadastrará e idenficará automaticamente o primeiro cadastrado como participante e Admin;  
```json
{
  "data": {
    "id": "1",
    "type": "users",
    "attributes": {
      "name": "Wendel Lopes",
      "email": "wendelopes@email.com",
      "username": "lednew",
      "role": "participant, admin"
     }
   }
} 
```
=======
Os administradores têm o poder de criar provas personalizadas, com perguntas e opções de múltiplas escolhas, além de gerenciar o acesso a estas provas pelos participantes. Eles podem monitorar a construção da prova, perguntas e suas opções de respostas, e só depois libera-las para acesso.
>>>>>>> develop

Por outro lado, os participantes podem se concentrar nas provas disponíveis, e ao escolher uma delas, ela ficará disponível para ele responder e até editar suas respostas. Após a conclusão da prova ele já terá acesso ao resultado final de acúmulo de pontos para este prova. Além do participante poder realizar as provas, todas as provas que ele realizar ficará registrada em seu histórico, podem assim editar qualquer uma delas. Cada participante só tem acesso as suas provas.

Com esse webserver-api o processo de criação, gerenciamento e participação em provas nunca foi tão fácil.

### Veja como funciona:
[Wiki](https://github.com/wlosantos/questions-app/wiki)
