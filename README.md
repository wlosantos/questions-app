# Question-Api

O Question-Api é um projeto de API Webserver construído em Rails 7 api-only, com authenticação de Token (jwt) que tem como objetivo oferecer uma Api server para criar e gerenciar provas. Com essa API, os administradores criarão provas de multiplas escolhas onde os usuários podem escolher as provas disponível e realiazarem os teste. Os participantes poderão editar as respostas, o que alterá o score final dessa prova. A cada questão poderão quantas opções os administradores definirem. Toda prova terá uma pontuação máxima de 10, o que será divida pela quantidade de perguntas adicionadas pelos administradores.

### Como usar essa Api:
1) ### Criar um administrador 
* Com o sistema rodando, um usuário deve ser criado. Todo os usuário criação são categorizados automaticamente como 'Participante' podendo apenas gerenciar sua conta e suas provas. Como primeiro usuário, para se tornar administrador você deve entrar no terminal, localizado seu cadastro para se tornar administrador use o seguinte código: 
```ruby
  User.first.add_role :admin 
```

2) ### Como administrador você terá acesso a todoas as funcionalidades (endpoint's) da Api que contam com os seguinte recursos:
* Criação, edição e exclusão de Provas, Questões e Opções de respostas;
* Cada um desses recursos possuem paginação e ordenação;
* Cada prova poderá ter quantas perguntas forem nessárias;
* Cada pergunta, sendo de multipla escolha, poderá ter várias opções, sendo que apenas uma irá conter o recurso de verdairo;


3) ### Apesar da simplicidade do sistema ele segue uma ordem lógica de uso:
- Criar uma coleção de matérias (Subject), toda prova precisa de uma matéria;
- Criar a prova (Exam);
- Criar perguntas (Question) que estarão ligadas a prova;
- Criar as opções de respostas (Answer) para cada pergunta. Obs.: Quando se cria uma pergunta (Question) é criada automática uma resposta padrão (nenhuma das alternativas) como verdadeira. Quando se cria uma nova opção e ela é marcada como verdadeira é feita a troca automática, deixando apenas uma opção como true;
- Podem ser criadas quantas opções de respostas forem necessárias;

4) ### Respondendo uma prova
- Todas as provas criadas estarão disponível em uma lista onde o usuário poderá escolher uma e gerar uma prova excluivamente dele para responder;
- Esta prova gerada fará parte de uma lista esclusiva desse usuário, onde ao responder será gerado um score do resultado dessa prova;
- Todas as provas do usuário estará disponível para edição, o que irá alterar o score da prova dependendo dos acertos e erros;

5) ### Documentação dos Endpoint's
- Dentro do sistema há o link <b>http://localhost:3000/api-docs</b> com a documentação (swagger) com todos os endpoint do sistema:


