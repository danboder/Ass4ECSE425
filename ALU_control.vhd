LIBRARY ieee;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ALU_control IS
	PORT(
	op_in, funct_in	: IN STD_LOGIC_VECTOR(5 downto 0);
	choose1, choose2: OUT STD_LOGIC;
	mode		: OUT INTEGER
	);
END ALU_control;

ARCHITECTURE behavior OF ALU_control IS

BEGIN
	control_process : PROCESS(op_in, funct_in) IS

	BEGIN
		case op_in is
			when "000000" =>
				choose1 <= '0'; --CHOOSE THE REGISTER DATA FOR ALL R OPS
				choose2 <= '0';
				case funct_in is
					when "000000" => --SLL
						mode <= 0;
					when "100000" => --ADD
						mode <= 1;
					when "100100" => --AND
						mode <= 2;
					when "011010" => --DIV
						mode <= 3;
					when "001000" => --JR
						mode <= 4;
					when "010000" => --MFHI
						mode <= 5;
					when "010010" => --MFLO
						mode <= 6;
					when "011000" => --MULT
						mode <= 7;
					when "100101" => --OR
						mode <= 8;
					when "101010" => --SLT
						mode <= 9;
					when "000011" => --SRA
						mode <= 10;
					when "000010" => --SRL
						mode <= 11;
					when "100011" => --SUB
						mode <= 12;
					when "100110" => --XOR
						mode <= 13;
					when "100111" => --NOR
						mode <= 14;
					when others =>
						mode <= 100;
				end case;
			when "001000" => --ADDI
				choose1 <= '0';
				choose2 <= '1'; --CHOOSE THE IMMEDIATE VALUE
				mode <= 15;
			when "001100" => --ANDI
				choose1 <= '0';
				choose2 <= '1';
				mode <= 16;
			when "000100" => --BEQ
				choose1 <= '1'; --CHOOSE THE PC VALUE
				choose2 <= '1';
				mode <= 17;
			when "000101" => --BNE
				choose1 <= '1';
				choose2 <= '1';
				mode <= 18;
			when "000010" => --J
				mode <= 19;
			when "000011" => --JAL
				mode <= 20;
			when "001111" => --LUI
				choose1 <= '0';
				choose2 <= '1';
				mode <= 21;
			when "100011" => --LW
				choose1 <= '0';
				choose2 <= '1';
				mode <= 22;
			when "001101" => --ORI
				choose1 <= '0';
				choose2 <= '1';
				mode <= 23;
			when "001010" => --SLTI
				choose1 <= '0';
				choose2 <= '1';
				mode <= 24;
			when "101011" => --SW
				choose1 <= '0';
				choose2 <= '1';
				mode <= 25;
			when "001110" => --XORI
				choose1 <= '0';
				choose2 <= '1';
				mode <= 26;
			when others =>
				choose1 <= '0';
				choose2 <= '0';
				mode <= 100;
		end case;
	END PROCESS;
END behavior;