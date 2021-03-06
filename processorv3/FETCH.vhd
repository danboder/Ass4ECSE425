LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY FETCH IS
	PORT(
		clk, enable, reset	: IN STD_LOGIC;
		if_branch	: IN STD_LOGIC;
		branch_addr	: IN STD_LOGIC_VECTOR (31 downto 0);
		count, instruction : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END FETCH;

ARCHITECTURE behavior OF FETCH IS
	
	COMPONENT memoryINS IS
	GENERIC(
		ram_size : INTEGER := 8192;
		mem_delay : time := 1 ns;
		clock_period : time := 1 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address: IN INTEGER RANGE 0 TO ram_size-1;
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC
	);
END COMPONENT;
	

	--signal PC_value, addend : INTEGER := 0;
	signal PC_value : INTEGER := 0;
	signal writedata, count_temp : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
	signal memwrite : STD_LOGIC := '0';
	signal memread: STD_LOGIC := '1';
	signal waitrequest : STD_LOGIC := '0';
	signal readdata : STD_LOGIC_VECTOR (31 downto 0);
	signal flush : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000100000";
	signal branch_stay : STD_LOGIC := '0';
	signal branch_stay_2 : STD_LOGIC := '0';
BEGIN
	dut: memoryINS GENERIC MAP(
            ram_size => 8192
                )
                PORT MAP(
                    clk,
                    writedata,
                    PC_value,
                    memwrite,
                    memread,
                    readdata,
                    waitrequest
                );
	
	process (clk)
	variable stall : INTEGER := 0;
	variable branch_stall : INTEGER := 2;
	
	begin
		
		if clk = '1' then
			memread <= '1';
			
			if PC_value < 8190 then
				if stall > 0 then
					instruction <= flush;
					stall := stall - 1;
				end if;
				if stall = 0 then
					if if_branch = '0' then
						
						PC_value <= PC_value + 1;
						instruction <= readdata;
						count <= std_logic_vector(to_unsigned(PC_value + 1,32));
						stall := 8;
					end if;

					if branch_stay = '1' then
						--report "HAHAHAHAHAHAHAHAHAHAH";
						branch_stay_2 <= '1';
						branch_stay <= '0';
						PC_value <=PC_value + 1 + to_integer(unsigned(branch_addr));
						instruction <= flush;
						stall := 2;
					end if;

					if branch_stay_2 = '1' then
						branch_stay_2 <= '0';
						PC_value <= PC_value + 1;
						instruction <= readdata;
						stall := 8;
						
						--report "PC" & integer'image(PC_value);

					end if;
						

				end if;
				
			end if;
		end if;
		if clk = '0' then
			memread <= '0';
		end if;

		if (if_branch = '1') then
			branch_stay <= '1';
		end if;
	

	
    
    --report "INST value is" & integer'image(to_integer(unsigned(readdata)));
	--report "STALL value is" & integer'image(stall);
	--report "Branch value is" & std_logic'image(if_branch);

	--if if_branch = '1' then
		--report "BRANCH value is" & integer'image(to_integer(unsigned(branch_addr)));
		--report "PC" & integer'image(PC_value);
	--end if;


	end process;
	
	
END behavior;
