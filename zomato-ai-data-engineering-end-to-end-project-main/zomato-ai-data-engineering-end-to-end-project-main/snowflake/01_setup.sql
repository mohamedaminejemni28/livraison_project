-- =====================================================================
-- Phase 2 · Step 1 — Warehouse, database, schemas, role
-- =====================================================================

-- Utilise le rôle ACCOUNTADMIN pour avoir les permissions nécessaires
-- à la création du warehouse, de la database, des schemas et du rôle.
USE ROLE ACCOUNTADMIN;


-- =====================================================================
-- 1. CREATE WAREHOUSE
-- =====================================================================

-- Crée le warehouse ZOMATO_WH s'il n'existe pas déjà.
CREATE WAREHOUSE IF NOT EXISTS ZOMATO_WH

  -- Utilise la plus petite taille de calcul disponible.
  -- XSMALL est adaptée à un projet de test / apprentissage.
  WAREHOUSE_SIZE = 'XSMALL'

  -- Suspend automatiquement le warehouse après 60 secondes
  -- sans activité afin d'éviter de consommer inutilement des crédits.
  AUTO_SUSPEND = 60

  -- Redémarre automatiquement le warehouse lorsqu'une requête
  -- nécessite son utilisation.
  AUTO_RESUME = TRUE

  -- Crée le warehouse initialement à l'état SUSPENDED.
  -- Il démarrera automatiquement grâce à AUTO_RESUME.
  INITIALLY_SUSPENDED = TRUE;


-- =====================================================================
-- 2. CREATE DATABASE
-- =====================================================================

-- Crée la database principale du projet si elle n'existe pas déjà.
CREATE DATABASE IF NOT EXISTS ZOMATO;


-- =====================================================================
-- 3. CREATE SCHEMAS
-- =====================================================================

-- Crée le schema BRONZE pour stocker les données brutes provenant
-- de Spark sous forme de tables Iceberg.
-- Ces tables seront ensuite utilisées comme sources par dbt.
CREATE SCHEMA IF NOT EXISTS ZOMATO.BRONZE;


-- Crée le schema RAW pour stocker les données chargées directement
-- dans Snowflake avec COPY INTO si le chemin alternatif est utilisé.
CREATE SCHEMA IF NOT EXISTS ZOMATO.RAW;


-- Crée le schema STAGING pour les données nettoyées et standardisées
-- par les transformations dbt.
CREATE SCHEMA IF NOT EXISTS ZOMATO.STAGING;


-- Crée le schema MARTS pour les données finales / Gold utilisées
-- pour l'analyse, le reporting et la BI.
CREATE SCHEMA IF NOT EXISTS ZOMATO.MARTS;


-- Crée le schema SNAPSHOTS pour conserver l'historique des changements
-- avec les snapshots dbt, notamment pour mettre en place du SCD Type 2.
CREATE SCHEMA IF NOT EXISTS ZOMATO.SNAPSHOTS;


-- Crée le schema AI pour stocker les données enrichies ou produites
-- par les traitements utilisant des modèles LLM / OpenAI.
CREATE SCHEMA IF NOT EXISTS ZOMATO.AI;


-- =====================================================================
-- 4. CREATE ROLE
-- =====================================================================

-- Crée un rôle spécifique appelé DBT_ROLE.
-- Ce rôle sera utilisé par dbt et potentiellement Airflow
-- au lieu d'utiliser le rôle très puissant ACCOUNTADMIN.
CREATE ROLE IF NOT EXISTS DBT_ROLE;


-- Donne au rôle DBT_ROLE la permission USAGE sur le warehouse.
-- Cela permet au rôle d'utiliser ZOMATO_WH pour exécuter des requêtes.
GRANT USAGE ON WAREHOUSE ZOMATO_WH TO ROLE DBT_ROLE;


-- Donne au rôle DBT_ROLE la permission OPERATE sur le warehouse.
-- Cela permet notamment de gérer son fonctionnement, comme
-- le suspendre ou le reprendre.
GRANT OPERATE ON WAREHOUSE ZOMATO_WH TO ROLE DBT_ROLE;


-- Donne au rôle DBT_ROLE tous les privilèges disponibles
-- sur la database ZOMATO.
GRANT ALL ON DATABASE ZOMATO TO ROLE DBT_ROLE;


-- Donne au rôle DBT_ROLE tous les privilèges sur les schemas
-- qui existent actuellement dans la database ZOMATO.
GRANT ALL ON ALL SCHEMAS IN DATABASE ZOMATO TO ROLE DBT_ROLE;


-- Donne automatiquement au rôle DBT_ROLE les privilèges nécessaires
-- sur les futurs schemas qui seront créés dans ZOMATO.
GRANT ALL ON FUTURE SCHEMAS IN DATABASE ZOMATO TO ROLE DBT_ROLE;


-- Donne automatiquement au rôle DBT_ROLE les privilèges nécessaires
-- sur les futures tables créées dans la database ZOMATO.
GRANT ALL ON FUTURE TABLES IN DATABASE ZOMATO TO ROLE DBT_ROLE;


-- Donne automatiquement au rôle DBT_ROLE les privilèges nécessaires
-- sur les futures vues créées dans la database ZOMATO.
GRANT ALL ON FUTURE VIEWS IN DATABASE ZOMATO TO ROLE DBT_ROLE;


-- =====================================================================
-- 5. ASSIGN ROLE TO CURRENT USER
-- =====================================================================

-- Récupère automatiquement le nom de l'utilisateur Snowflake
-- actuellement connecté et le stocke dans la variable my_user.
SET my_user = CURRENT_USER();


-- Attribue le rôle DBT_ROLE à l'utilisateur actuellement connecté.
-- IDENTIFIER($my_user) permet d'utiliser la valeur de la variable
-- comme nom d'utilisateur Snowflake.
GRANT ROLE DBT_ROLE TO USER IDENTIFIER($my_user);


-- =====================================================================
-- 6. VERIFICATION
-- =====================================================================

-- Retourne simplement un message pour confirmer que le script
-- est arrivé jusqu'à cette instruction sans erreur.
SELECT 'setup complete' AS status;