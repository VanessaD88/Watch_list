--
-- PostgreSQL database cluster dump
--

\restrict BFCkBRyvRH4Mbb9ZvD55cwixI092VRb9rGBnyZFTeUYSpfFuTfNuxmn8IXEEUYM

SET default_transaction_read_only = off;

SET client_encoding = 'LATIN1';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE benlangtech;
ALTER ROLE benlangtech WITH SUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








\unrestrict BFCkBRyvRH4Mbb9ZvD55cwixI092VRb9rGBnyZFTeUYSpfFuTfNuxmn8IXEEUYM

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict WUetzmUIo4RsrMqHgxM7XZcZt9hpqd1u23A3K0pmHtuoKMyybOc0sb389KDnevn

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'LATIN1';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict WUetzmUIo4RsrMqHgxM7XZcZt9hpqd1u23A3K0pmHtuoKMyybOc0sb389KDnevn

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict BcoHyTRd7kTER9gB1u0cuq6opKVXe7udmP9OQS7e72T6GZWkrhXIrcI7uT8NUMR

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'LATIN1';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict BcoHyTRd7kTER9gB1u0cuq6opKVXe7udmP9OQS7e72T6GZWkrhXIrcI7uT8NUMR

--
-- PostgreSQL database cluster dump complete
--

