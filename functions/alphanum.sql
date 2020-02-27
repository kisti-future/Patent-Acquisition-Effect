/*************************/
/** 구두점 제거 함수 선언 **/
/*************************/
DROP FUNCTION IF EXISTS alphanum; 
DELIMITER | 
CREATE FUNCTION alphanum( str varchar(500) ) RETURNS varchar(500) 
BEGIN 
  DECLARE i, len SMALLINT DEFAULT 1; 
  DECLARE ret  varchar(500) DEFAULT ''; 
  DECLARE c CHAR(1); 
  SET len = CHAR_LENGTH( str ); 
  REPEAT 
    BEGIN 
      SET c = MID( str, i, 1 ); 
      IF c REGEXP '[[:alnum:]]' THEN 
        SET ret=CONCAT(ret,c); 
      END IF; 
      SET i = i + 1; 
    END; 
  UNTIL i > len END REPEAT; 
  RETURN ret; 
END | 
DELIMITER ; 
