 use magazin_online;
 -- 1.populare cumparator
   
  DROP PROCEDURE IF EXISTS populare_cumparator;
DELIMITER //
CREATE PROCEDURE populare_cumparator (nume_c varchar(45),nume_utilizator_c varchar(45), parola_c varchar(45),email_c  varchar(45),telefon_c varchar(45),judet_c varchar(45), 
oras_c varchar(45),strada_c varchar(45), numar_c int)

  BEGIN
  
	DECLARE EXIT HANDLER FOR SQLSTATE '45000'
	BEGIN
	SELECT 'Modifica adresa de email' as `email`;
	RESIGNAL;
	END;
    
    DECLARE EXIT HANDLER FOR SQLSTATE '43000'
	BEGIN
	SELECT 'Modifica nume utilizator' as `nume utilizator`;
	RESIGNAL;
	END;
  
	START TRANSACTION;
		INSERT INTO cumparator
	    (nume,nume_utilizator, parola,email,numar_telefon,judet,oras,strada,numar)
	    VALUES
	    (nume_c,nume_utilizator_c,parola_c,email_c, telefon_c, judet_c,oras_c ,strada_c ,numar_c );
	COMMIT;
	  
  END //
  
  use magazin_online;
 -- adaugare card
DROP PROCEDURE IF EXISTS adaugare_card;

DELIMITER //
CREATE PROCEDURE adaugare_card (p_nume_utilizator varchar(45), p_nume_cont_bancar varchar(45))
  BEGIN

    DECLARE EXIT HANDLER FOR SQLSTATE '45000'
    BEGIN
    SELECT 'Schimbati numarul contului bancar' as `numar cont bancar`;
    RESIGNAL;
    END;

    START TRANSACTION;
        SET @ID_C = NULL;
        SELECT @ID_C := id_cumparator FROM cumparator WHERE nume_utilizator = p_nume_utilizator;

        IF (@ID_C  IS NOT NULL) THEN
        BEGIN
            INSERT INTO cont_bancar (id_client, nume_cont) VALUES (@ID_C, p_nume_cont_bancar);
            COMMIT;
        END;
        ELSE 
            ROLLBACK;
        END IF;
    COMMIT;
  END //
  
  use magazin_online;
-- populare produs si stoc
DROP PROCEDURE IF EXISTS populare_produs_si_stoc;
 
  DELIMITER //
CREATE PROCEDURE populare_produs_si_stoc (p_nume_produs varchar(45), p_pret float, p_cantitate int)
  BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '45000'
        BEGIN
            SELECT 'Inserati un pret valid' as "pret valid";
            RESIGNAL;
        END;
        START TRANSACTION;
            SET @ID = NULL;
            SET @ID_P = NULL;
            SELECT @ID :=  id_produs FROM produse WHERE p_nume_produs = produse.nume_produs;

        IF (@ID IS NULL) THEN
        BEGIN
            INSERT INTO produse (produse.nume_produs, produse.pret) VALUES (p_nume_produs, p_pret);
            SELECT @ID_P :=  id_produs FROM produse WHERE p_nume_produs = produse.nume_produs;
            INSERT INTO stoc (stoc.cantitate, stoc.id_prod) VALUES (p_cantitate, @ID_P);
            COMMIT;
        END;
        ELSE
        BEGIN
            SELECT @ID_P :=  id_produs FROM produse WHERE p_nume_produs = produse.nume_produs AND produse.pret = p.pret;
            UPDATE stoc SET stoc.cantitate = stoc.cantitate + p_cantitate WHERE stoc.id_prod = @ID_P;
            COMMIT;
        END;
        END IF;
  END //
  
  -- 6.populare detalii comanda 
    DROP PROCEDURE IF EXISTS populare_detalii_comanda;
 
  DELIMITER //
CREATE PROCEDURE populare_detalii_comanda (nume_produs_dc varchar(45), cantitate_dc int, nume_utilizator_dc varchar(45), metoda_plata_dc varchar(45))
  BEGIN
 
    DECLARE EXIT HANDLER FOR SQLSTATE '47000'
    BEGIN
    SELECT 'Prea multe produse!' as produse;
    RESIGNAL;
    END;
 
    START TRANSACTION;
        SET @id_c = NULL, @id_p = NULL, @id_pay = NULL;
        SELECT @id_c :=  c.id_cumparator FROM cumparator c WHERE c.nume_utilizator = nume_utilizator_dc;
        SELECT @id_p := p.id_produs FROM produse p WHERE p.nume_produs = nume_produs_dc;
        SELECT @id_pay := plata.id_plata FROM plata plata WHERE plata.metoda = metoda_plata_dc;

    IF (@id_c IS not null) THEN
    BEGIN
         UPDATE stoc SET cantitate = cantitate - cantitate_dc WHERE id_prod = @id_p;
         INSERT INTO detalii_comanda(id_c, id_p, id_pay, data_comanda, cantitate ) VALUES (@id_c, @id_p, @id_pay, NOW(), cantitate_dc);
        COMMIT;
    END;
    ELSE
        ROLLBACK;
    END IF;

  END //
  
  
  
  