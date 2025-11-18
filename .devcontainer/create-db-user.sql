CREATE USER postgres WITH PASSWORD 'password';

CREATE DATABASE naturio_development OWNER postgres;
CREATE DATABASE naturio_test OWNER postgres;
CREATE DATABASE naturio_production OWNER postgres;

GRANT ALL PRIVILEGES ON DATABASE naturio_development TO postgres;
GRANT ALL PRIVILEGES ON DATABASE naturio_test TO postgres;
GRANT ALL PRIVILEGES ON DATABASE naturio_production TO postgres;

\c naturio_development
GRANT ALL PRIVILEGES ON SCHEMA public TO postgres;

\c naturio_test
GRANT ALL PRIVILEGES ON SCHEMA public TO postgres;

\c naturio_production
GRANT ALL PRIVILEGES ON SCHEMA public TO postgres;
