USE enade;
CREATE TABLE IF NOT EXISTS enade_tratado (
  id int(10) NOT NULL AUTO_INCREMENT,
  NU_IDADE int(10),
  SEXO varchar(100),
  RENDA_FAMILIAR varchar(100),
  COR varchar(100),
  TP_ESCOLA varchar(100),
  KEY(id)
);