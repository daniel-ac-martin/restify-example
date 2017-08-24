-- Create tables
CREATE TYPE sex AS ENUM ('female', 'male');

CREATE TYPE species AS ENUM ('cat', 'dog');

CREATE TABLE pets
(
  "id"      BIGSERIAL PRIMARY KEY,
  "dob"     DATE      NOT NULL,
  "name"    VARCHAR   NOT NULL,
  "sex"     SEX       NOT NULL,
  "species" SPECIES   NOT NULL
);

-- Create stored precedures (functions) and indexes
CREATE FUNCTION pet(x BIGINT)
RETURNS TABLE
(
"id"      BIGINT,
"dob"     DATE,
"name"    VARCHAR,
"sex"     SEX,
"species" SPECIES
)
AS
$$
SELECT
"id",
"dob",
"name",
"sex",
"species"
FROM "pets"
WHERE "id" = "x"
LIMIT 1
$$
LANGUAGE SQL;

CREATE FUNCTION pets(s_dob_start DATE, s_dob_finish DATE, s_name_fragment VARCHAR, s_sex SEX, s_species SPECIES)
RETURNS TABLE
(
  "id"      BIGINT,
  "dob"     DATE,
  "name"    VARCHAR,
  "sex"     SEX,
  "species" SPECIES
)
AS
$$
  SELECT
    "id",
    "dob",
    "name",
    "sex",
    "species"
  FROM "pets"
  WHERE "dob" >= "s_dob_start"
    AND "dob" <= "s_dob_finish"
    AND "name" LIKE ('%' || "s_name_fragment" || '%')
    AND "sex" = "s_sex"
    AND "species" = "s_species"
$$
LANGUAGE SQL;

CREATE INDEX "pets1" ON "pets"
(
  "dob",
  "name",
  "sex",
  "species"
);

CREATE FUNCTION new_pet
(
  "dob"     DATE,
  "name"    VARCHAR,
  "sex"     SEX,
  "species" SPECIES
)
RETURNS BIGINT AS
$$
  INSERT INTO "pets"
         ("dob", "name", "sex", "species")
  VALUES ("dob", "name", "sex", "species")
  RETURNING "id";
$$
LANGUAGE SQL;

-- Create app user and assign permissions
CREATE USER "${app_user}"
WITH PASSWORD '${app_password}';

GRANT SELECT, INSERT ON TABLE pets TO "${app_user}";
GRANT SELECT, USAGE ON SEQUENCE pets_id_seq TO "${app_user}";
GRANT EXECUTE ON FUNCTION pet(BIGINT) TO "${app_user}";
GRANT EXECUTE ON FUNCTION new_pet(DATE, VARCHAR, SEX, SPECIES) TO "${app_user}";
