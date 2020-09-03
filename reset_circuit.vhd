LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY reset_circuit IS
	PORT
	(
		Reset : 		IN STD_LOGIC;
		Clk : 		IN STD_LOGIC;
		Enable_PD : OUT STD_LOGIC;
		Clr_PC : 	OUT STD_LOGIC
		);
END reset_circuit;

ARCHITECTURE description OF reset_circuit IS
signal count: integer:=0;
BEGIN
	process(Reset,Clk,count)
	begin	
	
		if(Clk'event and Clk = '1') then
			case Reset is
			when '1' =>
				Enable_PD <= '0';
				Clr_PC <= '1';
				count <= 1;
			when '0'=>
				if(count = 0) then
					Enable_PD <= '1';
					Clr_PC <= '0';
				end if;
				if(count >= 1 and count <=3) then
					count <= count + 1;
				end if;
				if(count = 4) then
					Enable_PD <= '1';
					Clr_PC <= '0';
					count <= 0;
				end if;
			end case;
		end if;
	end process;
end description;