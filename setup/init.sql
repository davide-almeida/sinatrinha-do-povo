CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	limit_amount INTEGER DEFAULT 0,
  balance INTEGER CHECK(balance >= -limit_amount) DEFAULT 0
);

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  client_id INTEGER,
  amount INTEGER,
  transaction_type CHAR(1),
  transaction_description VARCHAR(10),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_clients_transactions_id
    FOREIGN KEY (client_id) REFERENCES clients (id)
);

DO $$
BEGIN
  INSERT INTO clients (name, limit_amount)
  VALUES
    ('o barato sai caro', 1000 * 100),
    ('zan corp ltda', 800 * 100),
    ('les cruders', 10000 * 100),
    ('padaria joia de cocaia', 100000 * 100),
    ('kid mais', 5000 * 100);
END; $$