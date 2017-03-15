LIBRARY ieee;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ALU IS
	PORT(
	s_data, t_data	: IN STD_LOGIC_VECTOR(31 downto 0);
	equal		: IN STD_LOGIC;
	mode		: IN INTEGER;
	shamt		: IN STD_LOGIC_VECTOR(4 downto 0);
	jump_addr	: IN STD_LOGIC_VECTOR(25 downto 0);
	final_result		: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END ALU;

ARCHITECTURE behavior OF ALU is
	signal LO, HI	: STD_LOGIC_VECTOR(31 downto 0);
	signal HI_temp	: INTEGER;
	signal shamt_bit: INTEGER;
	signal overflow : STD_LOGIC_VECTOR(32 downto 0);
	signal result	: STD_LOGIC_VECTOR(31 downto 0);
BEGIN
	compute_process : PROCESS(s_data, t_data, mode, equal, jump_addr)
	
	BEGIN
		
		case mode is
			when 0 => --SHIFT LEFT LOGICAL
				shamt_bit <= to_integer(UNSIGNED(shamt));
				result <= t_data;
				for n in 0 to shamt_bit LOOP
					result <= (result(31 downto 1) & '0');	
				end loop;
			when 1 => --ADD
				result <= (s_data + t_data);
			when 15 => --ADDI
				result <= (s_data + t_data);
			when 22 => --LW
				result <= (s_data + t_data);
			when 2 => --AND
				result <= (s_data AND t_data);
			when 16 => --ANDI
				result <= (s_data AND t_data);
			when 3 => --DIV
				LO <= STD_LOGIC_VECTOR((UNSIGNED(s_data)/UNSIGNED(t_data)));
				HI_temp <= (to_integer(UNSIGNED(s_data)) mod to_integer(UNSIGNED(t_data)));
				HI <= STD_LOGIC_VECTOR(to_unsigned(HI_temp,32));
			when 4 => --JR
				result <= s_data;
			when 5 => --MFHI
				result <= HI;
			when 6 => --MFLO
				result <= LO;
			when 7 => --MULT
				LO <= (s_data*t_data);
			when 8 => --OR
				result <= (s_data OR t_data);
			when 23 => --ORI
				result <= (s_data OR t_data);
			when 9 => --SLT
				if (s_data < t_data) then
					result <= "00000000000000000000000000000001";
				else
					result <= "00000000000000000000000000000000";
				end if;
			when 24 => --SLTI
				if (s_data < t_data) then
					result <= "00000000000000000000000000000001";
				else
					result <= "00000000000000000000000000000000";
				end if;
			when 10 => --SRA
				shamt_bit <= to_integer(UNSIGNED(shamt));
				result <= t_data;
				for n in 0 to shamt_bit LOOP
					result <= (result(31) & result(31 downto 1));	
				end loop;
			when 11 => --SRL
				shamt_bit <= to_integer(UNSIGNED(shamt));
				result <= t_data;
				for n in 0 to shamt_bit LOOP
					result <= ('0' & result(31 downto 1));	
				end loop;
			when 12 => --SUB
				result <= (s_data - t_data);
			when 13 => --XOR
				result <= (s_data XOR t_data);
			when 26 => --XORI
				result <= (s_data XOR t_data);
			when 14 => --NOR
				result <= not(s_data OR t_data);
			when 17 => --BEQ
				if equal = '1' then
					result <= t_data;
				end if;
			when 18 => --BNE
				if equal = '0' then
					result <= t_data;
				end if;
			when 19 => --J
				result <= ("000000" & jump_addr);
	--		when 20 => --JAL
				
			when 21 => --LUI
				result <= (t_data & "0000000000000000");
			when 25 => --SW
				result <= t_data;
			when others =>
		end case;
	end process;
	final_result <= result;
end behavior;

