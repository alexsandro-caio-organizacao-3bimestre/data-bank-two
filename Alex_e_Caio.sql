create database if not exists dbEmpresa
character set utf8mb4
collate utf8mb4_general_ci;
use dbEmpresa;

create table if not exists Cliente(
id_cliente int auto_increment primary key,
nome varchar(50) not null,
email varchar(50),
ativo tinyint not null default 1,
data_cadastro datetime default current_timestamp
) engine = InnoDB;

create table if not exists Produto(
id_produto int primary key auto_increment,
nome varchar(50) not null,
preco decimal(10,2) check (preco > 0),
estoque int default 0, 
data_cadastro datetime default current_timestamp
) engine = InnoDB;

-- 1. Decimal
-- 2. Float pode causar erros de arredondamento.
-- 3. Por conta do arredondamento ele pode causar problemas em sistemas financeiros.
-- 4. O valor fica nulo.
-- 5. Não, pois o SQL já tem um valor padrão.

create table if not exists Categoria(
id_categoria int primary key,
nome varchar(50) unique
) engine = InnoDB;

-- 6. int pois o ID é um valor numérico e o nome recebe caracteres
-- 7. para não ocorrer erros de repetição de categórias.
-- 8. as categorias poderiam ser repetidas e isso causaria confusão e possíveis erros no sistema.
-- 9. a tabela não teria um identificador e isso também poderia levar a erros no sistema.

alter table Produto add id_categoria int;
alter table Produto add constraint produto_fk foreign key (id_categoria) references Categoria (id_categoria) on delete restrict; 
-- 10. Restrict por impedir que a tabela seja apagada enquanto ainda existirem produtos referenciando ela.
-- 11. Quando é necessário excluir uma tabela junto com todas as outras tabelas referenciando ela.
-- 12. Quando se quer bloquear a exclusão de uma tabela enquanto houverem dados referenciando ela.
-- 13. Haverão referências nulas na tabela.
-- 14. Regra no banco é restringida pelo próprio sql, enquanto na aplicação é o programador quem a decide.

create table if not exists Pedido(
id_pedido int primary key auto_increment,
id_cliente int not null, constraint foreign key (id_cliente) references Cliente (id_cliente) on delete cascade, 
data_pedido datetime default current_timestamp, 
valor decimal(8,2) not null check (valor > 0)
) engine = InnoDB;
 
create table if not exists Pedido_Item(
id_pedido int not null,
id_produto int not null,
quantidade int not null check (quantidade > 0),
preco_unitario decimal(10,2) not null,
constraint fk_item_pedido foreign key (id_pedido) references Pedido (id_pedido) on delete cascade,
constraint fk_item_produto foreign key (id_produto) references Produto(id_produto) on delete restrict,
primary key(id_pedido, id_produto)
) engine= InnoDB;

insert into Cliente (nome, email, ativo)
values ('Ana Souza', 'Ana@email.com', 1),
('Carla Mendes', 'carla@email.com', 1),
('Ana Souza', 'ana@gmail.com', 1),
('Bruno Lima', 'bruno@yahoo.com', 1),
('Carla Dias', 'carla@gmail.com', 1),
('Diego Silva', 'diego@outlook.com', 0),
('Eva Santos', null, 1),
('Fabio Rocha', 'fabio@gmail.com', 1);


insert into Categoria (id_categoria, nome) 
values 
(3, 'Acessórios'),
(1, 'Informática'),
(2, 'Livros'); 


insert into Produto (nome, preco, estoque, id_categoria)
values ('Notebook', 4500.000, 10, 1),
('Mouse Gamer', 150.00, 50, 1),
('Livro SQL', 90.00, 30, 2),
('Smartphone', 3200.00, 15, 1);


insert into Pedido (id_cliente, valor)
values (1, 4500.00),
(1, 150.00),
(2, 3200.00),
(3, 90.00),
(3, 500.00);


insert into Pedido_Item (id_pedido, id_produto, quantidade, preco_unitario)
values (1, 1, 1, 4500.00),
(2, 2, 1, 150.00),
(3, 4, 1, 3200.00),
(4, 3, 1, 90.00),
(5, 3, 5, 100.00);


/* 
SELECT @@secure_file_priv; -- verificar o caminho do arquivo

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cliente.csv'
INTO TABLE cliente
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(nome, email, ativo, data_cadastro);
*/

alter table Pedido add desconto decimal(10,2) check (desconto >= 0 and desconto <= 100);

-- 15. O ON DELETE CASCADE faz com que, ao deletar a tabela Pedido_Item, outras tabelas referenciando ela sejam apagadas juntas, sendo eficaz já que essa tabela referencia muitas outras.
-- 16. ON RESTRICT é eficaz para impedir que Produto seja deletado enquanto outras tabelas estiverem referenciando ele.

start transaction;
insert into Categoria (id_categoria, nome)
values
	(4, 'Perifericos'),
	(5, 'Smartphones'),
	(6, 'Componentes'),
	(7, 'Games'),
	(8, 'Impressão');
    
commit;

start transaction;
insert into Cliente (nome, email, ativo)
values
	('Marcos Oliveira', 'marcos@email.com', 1),
    ('Juliana Costa', 'juliana@email.com', 1),
    ('Ricardo Martins', 'ricardo@gmail.com', 1),
    ('Patrícia Alves', 'patricia@yahoo.com', 1),
    ('Fernando Souza', 'fernando@outlook.com', 1),
    ('Camila Rocha', 'camila@gmail.com', 1),
    ('Lucas Ferreira', 'lucas@email.com', 1),
    ('Renata Lima', 'renata@yahoo.com', 1),
    ('Gustavo Santos', 'gustavo@gmail.com', 0),
    ('Vanessa Mendes', 'vanessa@email.com', 1),
    ('Tiago Ribeiro', 'tiago@outlook.com', 1),
    ('Amanda Carvalho', 'amanda@egmail.com', 1),
    ('Bruno Fernandes', 'bruno@email.com', 1),
    ('Daniela Gomes', 'daniela@yahoo.com', 0),
    ('Eduardo Pereira', 'eduardo@gmail.com', 1),
    ('Flávia Nunes', null, 1),
    ('Henrique Barbosa', 'henrique@email.com', 1),
    ('Isabela Freitas', 'isabela@gmail.com', 1),
    ('João Pedro Silva', 'joaopedro@yahoo.com', 1),
    ('Karen Rodrigues', 'karen@outlook.com', 1);
commit;

start transaction;
insert into Produto (nome, preco, estoque, id_categoria)
values 
	('Teclado Mecânico RGB', 299.90, 25, 4),
	('Mouse Gamer Pro', 149.90, 40, 4),
	('Webcam Full HD', 249.90, 18, 4),
	('Galaxy S25', 4899.00, 12, 5),
	('Iphone 17', 7999.00, 8, 5),
	('Memória RAM 16GB', 359.90, 30, 6),
	('SSD NVMe 1TB', 499.90, 22, 6),
	('Fonte 650W', 389.90, 15, 6),
	('Controle Xbox Series', 429.90, 20, 7),
	('Headset Gamer', 319.90, 28, 7),
	('Impressora Multifuncional', 899.90, 10, 8),
	('Toner Compatível', 129.90, 50, 8),
	('Papel Fotográfico A4', 39.90, 80, 8),
	('Livro SQL Avançado', 119.90, 35, 2),
	('Livro Modelagem de Dados', 89.90, 20, 2);
    
commit;