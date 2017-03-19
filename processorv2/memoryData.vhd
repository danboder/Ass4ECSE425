--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE STD.textio.all;

ENTITY memoryData IS
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
		done: IN STD_LOGIC;
		waitrequest: OUT STD_LOGIC
	);
END memoryData;

ARCHITECTURE rtl OF memoryData IS
	TYPE MEM IS ARRAY(ram_size-1 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram_block: MEM;
	SIGNAL read_address_reg: INTEGER RANGE 0 to ram_size-1;
	SIGNAL write_waitreq_reg: STD_LOGIC := '1';
	SIGNAL read_waitreq_reg: STD_LOGIC := '1';
BEGIN
	--This is the main section of the SRAM model
	mem_process: PROCESS (clock)
	BEGIN
		--This is a cheap trick to initialize the SRAM in simulation
		IF(now < 1 ps)THEN
			For i in 0 to ram_size-1 LOOP
				ram_block(i) <= std_logic_vector(to_unsigned(0,32));
			END LOOP;
		end if;

		--This is the actual synthesizable SRAM block
		IF (clock'event AND clock = '1') THEN
			IF (memwrite = '1') THEN
				ram_block(address) <= writedata;
			END IF;
		read_address_reg <= address;
		END IF;

		--report "B value is" & std_logic'image(done);



	END PROCESS;
	readdata <= ram_block(read_address_reg);


	--The waitrequest signal is used to vary response time in simulation
	--Read and write should never happen at the same time.
	waitreq_w_proc: PROCESS (memwrite)
	BEGIN
		IF(memwrite'event AND memwrite = '1')THEN
			write_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;

		END IF;
	END PROCESS;

	waitreq_r_proc: PROCESS (memread)
	BEGIN
		IF(memread'event AND memread = '1')THEN
			read_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;
		END IF;
	END PROCESS;
	waitrequest <= write_waitreq_reg and read_waitreq_reg;



	export: process (clock)
		file file_pointer : text;
        	variable line_content : string(1 to 32);
        	variable current_value  : std_logic_vector(31 downto 0);
        	variable line_num : line;
       		variable i : integer := 0;
			--variable temp : STD_LOGIC;
	begin
	--temp := done;
	if (done = '1') then -- export datamemory to memory.txt
		file_open(file_pointer, "memory.txt", write_mode);
		for i in 0 to 8191 loop
			current_value := ram_block(i);
			for x in 0 to 31 loop
				if(current_value(x) = '0') then
					line_content(32-x) := '0';
				else
					line_content(32-x) := '1';
				end if;
			end loop;
			--REPORT "hehe";
			write(line_num, line_content);
			writeline(file_pointer, line_num);
			--wait for 1* ns;

		end loop;
		file_close(file_pointer);
		--wait;
	end if;
	end process;

END rtl;
