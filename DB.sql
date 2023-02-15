use magazin_online; 

create table if not exists administrator(
id_administrator INT NOT NULL AUTO_INCREMENT,
nume varchar(45),
nume_utilizator varchar(45),
parola varchar(45),
PRIMARY KEY(id_administrator)
);

create table if not exists cumparator(
id_cumparator INT NOT NULL AUTO_INCREMENT,
nume varchar(45) not null,
nume_utilizator varchar(45) not null,
email varchar(45) not null unique,
parola varchar(45)  not null,
numar_telefon varchar(45)  not null unique,
judet varchar(45)  not null,
oras varchar(45)  not null,
strada varchar(45)  not null,
numar int  not null,
PRIMARY KEY(id_cumparator)
);

create table if not exists produse(
id_produs INT NOT NULL auto_increment,
nume_produs varchar(45) not null unique,
pret float,
descriere_produs varchar(100),
feedback varchar(100),
PRIMARY KEY(id_produs)
);

create table if not exists stoc(
id_stoc INT NOT NULL auto_increment,
cantitate int ,
id_prod int,
PRIMARY KEY(id_stoc),

Constraint FK_stoc_produs
FOREIGN KEY(id_prod)
references produse(id_produs)
ON DELETE  CASCADE
ON UPDATE  CASCADE
);

create table if not exists plata(
id_plata int not null auto_increment,
metoda varchar(45),
primary key(id_plata)
);

create table if not exists cont_bancar(
id_cont_bancar INT NOT NULL auto_increment,
nume_cont varchar(45),
id_client int,
primary key(id_cont_bancar),
constraint FK_cont_bancar
FOREIGN KEY (id_client)
references cumparator(id_cumparator)
ON DELETE  CASCADE
ON UPDATE  CASCADE
);

create table if not exists detalii_comanda(
id_detalii_comanda INT NOT NULL auto_increment,
id_c int,
id_p int ,
id_pay int ,
cantitate int,
data_comanda date,
primary key(id_detalii_comanda),


constraint FK_detalii_comanda_produs
foreign key(id_p)
references produse(id_produs)
ON DELETE  CASCADE
ON UPDATE  CASCADE,


constraint FK_comanda_cumparator
FOREIGN KEY (id_c)
REFERENCES cumparator(id_cumparator)
ON DELETE  CASCADE
ON UPDATE  CASCADE,
    
    
constraint FK_comanda_plata
FOREIGN KEY(id_pay)
references plata(id_plata)
ON DELETE  CASCADE
ON UPDATE  CASCADE
);

CREATE TABLE IF NOT EXISTS reducere(
id_reducere INT NOT NULL AUTO_INCREMENT,
id_prod int,
pret_nou float,
primary key(id_reducere),
constraint FK_produs_reducere
foreign key(id_prod)
references produse(id_produs)
ON DELETE  CASCADE
ON UPDATE  CASCADE
);

create table if not exists cos_produse(
id_cos_produse INT NOT NULL AUTO_INCREMENT,
id_p int,
id_comanda int,

primary key(id_cos_produse),
constraint FK_cos_produse_produse
foreign key(id_p)
references produse(id_produs)
ON DELETE  CASCADE
ON UPDATE  CASCADE,

constraint FK_cos_produse_detalii_comanda
foreign key(id_comanda)
references detalii_comanda(id_c)
ON DELETE  CASCADE
ON UPDATE  CASCADE
);

insert into administrator(id_administrator,nume,nume_utilizator,parola) values 
(1,'Popescu','Popescu21','admin1234');

insert into cumparator(id_cumparator,nume,nume_utilizator,email,parola,numar_telefon,judet,oras,strada,numar) values
(1,'Pop','Pop01','pop@yahoo.com','a1234','089920394','Cluj','Cluj-Napoca','Observaotor',21),
(2,'Ionescu','Íon10','ionescu@yahoo.com','abdr','01989335','Salaj','Jibou','Vasile-Fati',34),
(3,'Tanescu','tanescu70','tanescu@yahoo.com','iujmbhd','07493902','Cluj','Dej','Trandafirilor',19);


insert into produse(id_produs,nume_produs,pret,descriere_produs,feedback) values 
(1,'laptop Dell', 4500.89 ,'brand Dell,procesor Intel,capacitate SSD:128 GB','PRODUS ESTE OK'),
(2,'laptop  Apple MacBook Pro',10508.99,'brand Apple,procesor Intel,capacitate SSD:128 GB','PRODUS EXCELENT'),
(3,'mouse gaming',35.90,'brand Logitech, interfata USB, culoare negru','NU RECOMAND');


insert into stoc(id_stoc,cantitate,id_prod) values
(1 , 56 ,1),
(2 , 100 , 2),
 (3 , 456 ,3);

insert into plata(id_plata,metoda) values
(1,'card'),
(2,'cash');

insert into cont_bancar(id_cont_bancar,nume_cont,id_client) values
(1,'Pop',1),
(2,'Ionescu',2),
(3,'Tanescu',3);

insert into detalii_comanda(id_detalii_comanda, id_c, id_p, id_pay, cantitate,data_comanda) values
(1,1,1,1,2,"2020-09-27"),
(2,1,1,1,5,"2019-08-23");

insert into cos_produse(id_cos_produse, id_p, id_comanda) values
(1,1,1),
(2,2,1);


insert into reducere(id_reducere, id_prod, pret_nou) values
(1,1,4000.00),
(2,2,9999.99),
(3,3,28.99);
