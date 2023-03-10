![example workflow](https://github.com/wlosantos/questions-app/actions/workflows/rubyonrails.yml/badge.svg)
# Bem-vindo ao questions-app

Este webserver-api é um servidor de provas e testes construído com Rails 7 API-only e outros recursos de autorização e autenticação! Com ele, você pode criar, gerenciar e participar de provas com facilidade. Com dois tipos de usuários - administrador e participante - nossos recursos são adaptados às necessidades específicas de cada um. 

Os administradores têm o poder de criar provas personalizadas, com perguntas e opções de múltiplas escolhas, além de gerenciar o acesso a estas provas pelos participantes. Eles podem monitorar a construção da prova, perguntas e suas opções de respostas, e só depois libera-las para acesso.

Por outro lado, os participantes podem se concentrar nas provas disponíveis, e ao escolher uma delas, ela ficará disponível para ele responder e até editar suas respostas. Após a conclusão da prova ele já terá acesso ao resultado final de acúmulo de pontos para este prova. Além do participante poder realizar as provas, todas as provas que ele realizar ficará registrada em seu histórico, podem assim editar qualquer uma delas. Cada participante só tem acesso as suas provas.

Com esse webserver-api o processo de criação, gerenciamento e participação em provas nunca foi tão fácil.

### Veja como funciona:
[Wiki-documentação](https://github.com/wlosantos/questions-app/wiki)

### Recursos
* Rails 7 api-only
* JWT - autenticação
* Rolify - Gerenciamento de classificação de usuários
* Pundit - Gerenciamento de autorizações
* Kaminary - Paginação
* Ransack - Consultas e ordenação
* rswag - Documentação dos endpoints
* Rspec - Testes unitários e de integração

### Recursos Auxiliares
* Docker
* Docker-compose
* Insomnia (Arquivo json com os endpoint para o Insomnia na pasta public)
* diagram.io - Database

<img src="https://github.com/wlosantos/questions-app/blob/develop/public/fractal_dbase.png" width="650" />

