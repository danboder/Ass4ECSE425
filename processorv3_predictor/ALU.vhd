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
	final_result		: OUT STD_LOGIC_VECTOR(31 downto 0);
	predicted_outcome   : OUT STD_LOGIC
	);
END ALU;

ARCHITECTURE behavior OF ALU is
	signal LO, HI	: STD_LOGIC_VECTOR(31 downto 0);
	signal HI_temp, s_temp, t_temp	: INTEGER;
	signal shamt_bit: INTEGER;
	signal overflow : STD_LOGIC_VECTOR(32 downto 0);
	signal result	: STD_LOGIC_VECTOR(31 downto 0);

	COMPONENT predictor IS
        PORT (
		reset: in std_logic;
		clk  : in std_logic;
     		taken: in std_logic;
     		predicted_outcome: out std_logic
        );
    END COMPONENT;

	signal taken : STD_LOGIC;
	signal reset : STD_LOGIC := '0';
	signal clk : STD_LOGIC := '1';




BEGIN

 branch_predictor: predictor
                PORT MAP(
                    reset,
                    clk,
                    taken,
                    predicted_outcome
                );



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
				--report "S value is" & integer'image(to_integer(unsigned(t_data)));
			when 15 => --ADDI
				report "ADDI";
				--report "S value is" & integer'image(to_integer(unsigned(s_data)));
				--report "T value is" & integer'image(to_integer(unsigned(t_data)));
				result <= (s_data + t_data);
				--report "Result value is" & integer'image(to_integer(unsigned(result)));
			when 22 => --LW
				result <= (s_data + t_data);
			when 2 => --AND
				result <= (s_data AND t_data);
			when 16 => --ANDI
				result <= (s_data AND t_data);
			when 3 => --DIV
				s_temp <= to_integer(signed(s_data));
				t_temp <= to_integer(signed(t_data));
				--LO <= std_logic_vector(to_signed((s_temp/t_temp),32));
				--HI_temp <= (s_temp mod t_temp);
				--HI <= STD_LOGIC_VECTOR(to_unsigned(HI_temp,32));
				report "LAST INSTRUCTION";

			when 4 => --JR
				result <= s_data;
			when 5 => --MFHI
				result <= HI;
			when 6 => --MFLO
				result <= LO;
			when 7 => --MULT
				--LO <= (s_data*t_data);
				--LO <= std_logic_vector(to_unsigned(signed(s_data) * signed(t_data),32));
				LO <= std_logic_vector(to_signed((to_integer(signed(s_data))*to_integer(signed(t_data))),32));
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
					taken <= '1';
					
					result <= t_data;
				else
					taken <= '0';
					
				end if;
			when 18 => --BNE
				if equal = '0' then
					taken <= '1';
					
					result <= t_data;
				else
					taken <= '0';
					
				end if;
	--		when 19 => --J
	--			result <= ("000000" & jump_addr);
	--		when 20 => --JAL
				
			when 21 => --LUI
				result <= (t_data(15 downto 0) & "0000000000000000");
			when 25 => --SW
				result <= (s_data + t_data);
			when others =>
		end case;

		

	end process;

	--predicted_outcome <= '1';

	final_result <= result;
end behavior;

