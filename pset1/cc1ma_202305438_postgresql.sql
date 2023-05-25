-- APAGAR O BANCO DE DADOS SE EXISTIR

DROP DATABASE IF EXISTS uvv;



-- APAGAR O USUÁRIO SE EXISTER 

DROP USER IF EXISTS sofia;



-- CRIANDO O USUÁRIO 

CREATE USER sofia with 
CREATEDB
CREATEROLE                          
ENCRYPTED PASSWORD '12345'
;



-- CRIANDO O BANCO DE DADOS "uvv" E ATRIBUINDO O OWNER AO USER "sofia"

CREATE DATABASE uvv with
OWNER = sofia
TEMPLATE = template0
ENCODING = 'UTF8'
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE = 'pt_BR.UTF-8'
ALLOW_CONNECTIONS = true
;



-- ENTRANDO NO BANCO DE DADOS "uvv" COM O USUÁRIO "sofia", COM A SENHA SENDO PREENCHIDA AUTOMATICAMENTE 
-- Obs.: Com uma dica do meu colega de sala, encontrei o seguinte código abaixo
-- para preencher automaticamente a senha no momento do login.
 
\c "dbname=uvv user=sofia password=12345"



-- CRIANDO O SCHEMA E DANDO AUTORIZAÇÃO PARA O USER "sofia".

CREATE SCHEMA lojas AUTHORIZATION sofia
;



-- TROCANDO O SCHEMA PADRÃO PARA O SCHEMA "lojas" E TORNANDO-O PERMANENTE AO ATRIBUIR AO USER "sofia"

ALTER USER sofia
SET SEARCH_PATH TO lojas, "$user", public
;



-- CRIANDO TABELAS E COMENTÁRIOS:


-- criando a tabela lojas.

CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT pk_lojas PRIMARY KEY (loja_id)
);

-- comentários sobre a tabela lojas e suas colunas

COMMENT ON TABLE lojas.lojas IS 'Cadastro das lojas.';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'Chave primária da tabela. Identifica o código da loja.';
COMMENT ON COLUMN lojas.lojas.nome IS 'Nome completo da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'URL da loja.  Se esse endereço estiver vazio, a coluna endereco_fisico deve ser preenchida';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'Endereço físico da loja. Se esse endereço estiver vazio, a coluna endereco_web deve ser preenchida';
COMMENT ON COLUMN lojas.lojas.latitude IS 'Localização da loja pela latitude do planeta.';
COMMENT ON COLUMN lojas.lojas.longitude IS 'Localização da loja pela longitude do planeta.';
COMMENT ON COLUMN lojas.lojas.logo IS 'Imagem da logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'Mime type da imagem da logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'Formato do arquivo da imagem da logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'Codificação de caracteres da imagem da logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Data da última atualização da imagem da logo da loja.';



-- criando a tabela produtos

CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT pk_produtos PRIMARY KEY (produto_id)
);

-- comentários sobre a tabela produtos e suas colunas

COMMENT ON TABLE lojas.produtos IS 'Cadastro dos produtos.';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'Chave primária da tabela. Identifica o código do produto.';
COMMENT ON COLUMN lojas.produtos.nome IS 'Nome do completo do produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'Preço do produto por unidade. Não é permitido preço negativo';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'Detalhes sobre o produto.';
COMMENT ON COLUMN lojas.produtos.imagem IS 'Imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'Mime type da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'Formato do arquivo da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'Codificação de caracteres da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Data da última atualização da imagem do produto.';



-- criando a tabela estoques

CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoques PRIMARY KEY (estoque_id)
);

-- comentários sobre a tabela estoques e suas colunas

COMMENT ON TABLE lojas.estoques IS 'Cadastro dos estoques.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'Chave primária da tabela. Identifica o código do estoque.';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'Identifica código do estoque da loja. Também é uma FK para a tabela lojas.';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'Identifica o código do estoque do produto. Também é uma FK para a tabela produtos.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Quantidade numérica de produtos de uma loja no estoque. Não é permitido quantidade negativa';



-- criando a tabela clientes

CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT pk_clientes PRIMARY KEY (cliente_id)
);

-- comentários sobre a tabela clientes e suas colunas

COMMENT ON TABLE lojas.clientes IS 'Cadastro dos clientes.';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Chave primária da tabela. Identifica o código do cliente.';
COMMENT ON COLUMN lojas.clientes.email IS 'Campo pra preencher o email do cliente.';
COMMENT ON COLUMN lojas.clientes.nome IS 'Campo pra preencher o nome completo do cliente. Escreva igual ao RG';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'Campo pra preencher o primeiro telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'Campo pra preencher o segundo telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'Campo pra preencher o terceiro telefone do cliente.';



-- criando a tabela envios

CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT pk_envios PRIMARY KEY (envio_id)
);

-- comentários sobre a tabela envios e suas colunas

COMMENT ON TABLE lojas.envios IS 'Cadastro dos envios.';
COMMENT ON COLUMN lojas.envios.envio_id IS 'Chave primária da tabela. Identifica o código do envio.';
COMMENT ON COLUMN lojas.envios.loja_id IS 'Identifica o código do envio da loja. Também é uma FK para a tabela lojas';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'Identifica código do envio de um cliente. Também é uma FK para a tabela clientes.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Campo pra preencher endereço completo da entrega.';
COMMENT ON COLUMN lojas.envios.status IS 'Mostra o status do envio. Só são aceitos os seguintes valores: CRIADO, ENVIADO, TRANSITO e ENTREGUE.';



-- criando a tabela pedidos

CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id)
);

-- comentários sobre a tabela pedidos e suas colunas

COMMENT ON TABLE lojas.pedidos IS 'Cadastro dos pedidos.';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'Chave primária da tabela. Identifica o código do pedido.';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'Indica o dia e a hora que o pedido foi feito.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Identifica código do pedido de um cliente. Também é uma FK para a tabela clientes.';
COMMENT ON COLUMN lojas.pedidos.status IS 'Mostra o status do pedido. Só são aceitos os seguintes valores: CANCELADO, COMPLETO, ABERTO, PAGO, REEMBOLSADO e
ENVIADO.';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'Identifica o código do pedido da loja. Também é uma FK para a tabela lojas.';



-- criando a tabela pedidos_itens

CREATE TABLE lojas.pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);

-- comentários sobre a tabela pedidos_itens e suas colunas

COMMENT ON TABLE lojas.pedidos_itens IS 'Cadastro dos itens pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'Chave primária da tabela. Identifica o código de itens de pedidos específicos. Também é uma FK para a tabela pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'Chave primária da tabela. Identifica o código de pedidos de itens específicos. Também é uma FK para a tabela produtos.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Número da linha de produção de um pedido específico de um item específico. Não é permitido numero da linha negativo.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'Preço por unidade de um pedido específico de um item específico. Não é permitido quantidade negativo.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'Quantidade de um pedido específico de um item específico. Não é permitido quantidade negativa.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'Identifica o código de um pedido de um item enviado. Também é uma FK para a tabela envios.';



-- CHAVES ESTRANGEIRAS

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- MUDANDO PROPRIETÁRIO DAS TABELAS PARA O USER "sofia"

ALTER TABLE lojas.lojas OWNER TO sofia;
ALTER TABLE lojas.clientes OWNER TO sofia;
ALTER TABLE lojas.envios OWNER TO sofia;
ALTER TABLE lojas.pedidos OWNER TO sofia;
ALTER TABLE lojas.produtos OWNER TO sofia;
ALTER TABLE lojas.estoques OWNER TO sofia;
ALTER TABLE lojas.pedidos_itens OWNER TO sofia;



-- CHEKS

ALTER TABLE lojas.produtos
ADD CONSTRAINT produtos_preco_positivo
CHECK (preco_unitario >= 0); 

ALTER TABLE lojas.estoques
ADD CONSTRAINT estoques_quantidade_positiva
CHECK (quantidade >= 0); 

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT pi_preco_positivo
CHECK (preco_unitario >= 0); 

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT pi_quantidade_positiva
CHECK (quantidade >= 0); 

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT pi_numero_da_linha_positivo
CHECK (numero_da_linha >= 0);

ALTER TABLE lojas.lojas
ADD CONSTRAINT endereco_check
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

ALTER TABLE lojas.pedidos
ADD CONSTRAINT pedidos_status
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REMBOLSADO', 'ENVIADO'));

ALTER TABLE lojas.envios
ADD CONSTRAINT envios_status
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));