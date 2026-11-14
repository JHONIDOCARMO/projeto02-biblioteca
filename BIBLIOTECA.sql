-- Projeto 02: Sistema de Biblioteca (SQL Server)

USE master;
GO
IF DB_ID('biblioteca') IS NOT NULL DROP DATABASE biblioteca;
GO
CREATE DATABASE biblioteca;
GO
USE biblioteca;
GO

-- TABELAS
CREATE TABLE autores (
    id_autor INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nome_categoria VARCHAR(50) NOT NULL
);

CREATE TABLE livros (
    id_livro INT PRIMARY KEY IDENTITY(1,1),
    titulo VARCHAR(150) NOT NULL,
    ano_publicacao INT,
    id_autor INT,
    id_categoria INT,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE alunos (
    id_aluno INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL,
    turma VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE emprestimos (
    id_emprestimo INT PRIMARY KEY IDENTITY(1,1),
    id_livro INT,
    id_aluno INT,
    data_emprestimo DATE NOT NULL,
    data_prevista DATE NOT NULL,
    data_devolucao DATE NULL,
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro),
    FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno)
);
GO

-- DADOS
INSERT INTO autores (nome) VALUES
('Machado de Assis'),
('Clarice Lispector'),
('Monteiro Lobato'),
('George Orwell'),
('Paulo Coelho'),
('Flávio Josefo'),
('Henrietta Mears');

INSERT INTO categorias (nome_categoria) VALUES
('Romance'),
('Infantil'),
('Ficção Científica'),
('Autoajuda'),
('História'),
('Religião');

INSERT INTO livros (titulo, ano_publicacao, id_autor, id_categoria) VALUES
('Dom Casmurro', 1899, 1, 1),
('Memórias Póstumas de Brás Cubas', 1881, 1, 1),
('A Hora da Estrela', 1977, 2, 1),
('Reinações de Narizinho', 1931, 3, 2),
('1984', 1949, 4, 3),
('A Revolução dos Bichos', 1945, 4, 3),
('O Alquimista', 1988, 5, 4),
('A Guerra dos Judeus', 75, 6, 5),
('Antiguidades Judaicas', 93, 6, 5),
('O Que a Bíblia Diz', 1953, 7, 6);

INSERT INTO alunos (nome, turma, email) VALUES
('Ana Souza', '1A', 'ana@escola.com'),
('Bruno Lima', '1A', 'bruno@escola.com'),
('Carla Mendes', '2B', 'carla@escola.com'),
('Diego Alves', '2B', 'diego@escola.com'),
('Elisa Rocha', '3C', 'elisa@escola.com'),
('Felipe Costa', '3C', 'felipe@escola.com');

INSERT INTO emprestimos (id_livro, id_aluno, data_emprestimo, data_prevista, data_devolucao) VALUES
(1, 1, '2026-09-01', '2026-09-15', '2026-09-14'),
(5, 2, '2026-09-10', '2026-09-24', '2026-09-30'),
(3, 3, '2026-10-02', '2026-10-16', '2026-10-15'),
(1, 2, '2026-10-05', '2026-10-19', NULL),
(7, 1, '2026-10-12', '2026-10-26', NULL),
(10, 4, '2026-10-20', '2026-11-03', '2026-11-02'),
(5, 1, '2026-10-25', '2026-11-08', NULL),
(8, 5, '2026-11-05', '2026-11-19', NULL),
(4, 3, '2026-11-10', '2026-11-24', NULL),
(2, 1, '2026-11-12', '2026-11-26', NULL);
GO

-- CONSULTAS

-- 1. Livros emprestados agora
SELECT l.titulo, a.nome AS aluno, e.data_emprestimo, e.data_prevista
FROM emprestimos e
JOIN livros l ON l.id_livro = e.id_livro
JOIN alunos a ON a.id_aluno = e.id_aluno
WHERE e.data_devolucao IS NULL
ORDER BY e.data_emprestimo;

-- 2. Empréstimos atrasados
SELECT l.titulo, a.nome AS aluno, e.data_prevista,
       DATEDIFF(DAY, e.data_prevista, GETDATE()) AS dias_de_atraso
FROM emprestimos e
JOIN livros l ON l.id_livro = e.id_livro
JOIN alunos a ON a.id_aluno = e.id_aluno
WHERE e.data_devolucao IS NULL
  AND e.data_prevista < CAST(GETDATE() AS DATE)
ORDER BY dias_de_atraso DESC;

-- 3. Livros nunca emprestados
SELECT l.titulo, a.nome AS autor
FROM livros l
JOIN autores a ON a.id_autor = l.id_autor
LEFT JOIN emprestimos e ON e.id_livro = l.id_livro
WHERE e.id_livro IS NULL
ORDER BY l.titulo;

-- 4. Aluno que mais pegou livros
SELECT a.nome AS aluno, COUNT(*) AS total_emprestimos
FROM alunos a
JOIN emprestimos e ON e.id_aluno = a.id_aluno
GROUP BY a.nome
ORDER BY total_emprestimos DESC, a.nome;