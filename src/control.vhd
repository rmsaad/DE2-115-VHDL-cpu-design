library ieee;
use ieee.std_logic_1164.ALL;
ENTITY control IS
	PORT(
		clk, mclk : IN STD_LOGIC;
		enable : IN STD_LOGIC;
		statusC, statusZ : IN STD_LOGIC;
		INST : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		A_Mux, B_Mux : OUT STD_LOGIC;
		IM_MUX1, REG_Mux : OUT STD_LOGIC;
		IM_MUX2, DATA_Mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALU_op : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		inc_PC, ld_PC : OUT STD_LOGIC;
		clr_IR : OUT STD_LOGIC;
		ld_IR : OUT STD_LOGIC;
		clr_A, clr_B, clr_C, clr_Z : OUT STD_LOGIC;
		ld_A, ld_B, ld_C, ld_Z : OUT STD_LOGIC;
		T : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		wen, en : OUT STD_LOGIC);
END control;

ARCHITECTURE description OF control IS
	TYPE STATETYPE IS (state_0, state_1, state_2);
	SIGNAL present_state: STATETYPE;
BEGIN
-------- OPERATION DECODER ---------
PROCESS (present_state, INST, statusC, statusZ, enable)
BEGIN
	case enable is
	when '0' =>
		A_Mux <= '0';
		B_Mux <= '0';
		IM_MUX1 <= '0';
		REG_Mux <= '0';
		IM_MUX2 <= "00";
		DATA_Mux <= "00";
		ALU_op <= "000";
		inc_PC <= '0';
		ld_PC <= '0';
		clr_IR <= '0';
		ld_IR <= '0';
		clr_A <= '0';
		clr_B <= '0';
		clr_C <= '0';
		clr_Z <= '0';
		ld_A <= '0';
		ld_B <= '0';
		ld_C <= '0';
		ld_Z <= '0';
	when '1' =>
		case present_state is
		when state_0 =>
			A_Mux <= '0';
		   B_Mux <= '0';
			IM_MUX1 <= '0';
			REG_Mux <= '0';
			IM_MUX2 <= "00";
			DATA_Mux <= "00";
			ALU_op <= "000";
			inc_PC <= '0';
			ld_PC <= '0';
			clr_IR <= '0';
			ld_IR <= '1';
			clr_A <= '0';
			clr_B <= '0';
			clr_C <= '0';
			clr_Z <= '0';
			ld_A <= '0';
			ld_B <= '0';
			ld_C <= '0';
			ld_Z <= '0';
		when state_1 =>
			
			ld_IR <= '0';
			ld_PC <= '1';
			inc_PC <= '1';
			
			if(INST(31 downto 28) = "0010") then -- STA
				REG_Mux <= '0';
		   elsif(INST(31 downto 28) = "0011") then -- STB
				REG_Mux <= '1';
			end if;	
			
		when state_2 =>
			ld_PC <= '0';
			inc_PC <= '0';
			
			
			if(INST(31 downto 28) = "0000") then -- LDAI
				A_Mux <= '1';
		      B_Mux <= '0';
				IM_MUX1 <= '0';
				REG_Mux <= '0';
				IM_MUX2 <= "00";
				DATA_Mux <= "00";
				ALU_op <= "000";
				clr_IR <= '0';
				ld_IR <= '0';
				clr_A <= '0';
				clr_B <= '0';
				clr_C <= '0';
				clr_Z <= '0';
				ld_A <= '1';
				ld_B <= '0';
				ld_C <= '0';
				ld_Z <= '0';
			elsif(INST(31 downto 28) = "0001") then -- LDBI
				A_Mux <= '0';
		      B_Mux <= '1';
				IM_MUX1 <= '0';
				REG_Mux <= '0';
				IM_MUX2 <= "00";
				DATA_Mux <= "00";
				ALU_op <= "000";
				clr_IR <= '0';
				ld_IR <= '0';
				clr_A <= '0';
				clr_B <= '0';
				clr_C <= '0';
				clr_Z <= '0';
				ld_A <= '0';
				ld_B <= '1';
				ld_C <= '0';
				ld_Z <= '0';
			elsif(INST(31 downto 28) = "0010") then -- STA
				A_Mux <= '0';
		      B_Mux <= '0';
				IM_MUX1 <= '0';
				REG_Mux <= '0';
				IM_MUX2 <= "00";
				DATA_Mux <= "00";
				ALU_op <= "000";
				clr_IR <= '0';
				ld_IR <= '0';
				clr_A <= '0';
				clr_B <= '0';
				clr_C <= '0';
				clr_Z <= '0';
				ld_A <= '0';
				ld_B <= '0';
				ld_C <= '0';
				ld_Z <= '0';
			elsif(INST(31 downto 28) = "0011") then -- STB
				A_Mux <= '0';
		      B_Mux <= '0';
				IM_MUX1 <= '0';
				REG_Mux <= '1';
				IM_MUX2 <= "00";
				DATA_Mux <= "00";
				ALU_op <= "000";
				clr_IR <= '0';
				ld_IR <= '0';
				clr_A <= '0';
				clr_B <= '0';
				clr_C <= '0';
				clr_Z <= '0';
				ld_A <= '0';
				ld_B <= '0';
				ld_C <= '0';
				ld_Z <= '0';
			elsif(INST(31 downto 28) = "1001") then -- LDA
				A_Mux <= '0';
		      B_Mux <= '0';
				IM_MUX1 <= '0';
				REG_Mux <= '0';
				IM_MUX2 <= "00";
				DATA_Mux <= "01";
				ALU_op <= "000";
				clr_IR <= '0';
				ld_IR <= '0';
				clr_A <= '0';
				clr_B <= '0';
				clr_C <= '0';
				clr_Z <= '0';
				ld_A <= '1';
				ld_B <= '0';
				ld_C <= '0';
				ld_Z <= '0';
			elsif(INST(31 downto 28) = "1010") then -- LDB
				A_Mux <= '0';
		      B_Mux <= '0';
				IM_MUX1 <= '0';
				REG_Mux <= '1';
				IM_MUX2 <= "00";
				DATA_Mux <= "01";
				ALU_op <= "000";
				clr_IR <= '0';
				ld_IR <= '0';
				clr_A <= '0';
				clr_B <= '0';
				clr_C <= '0';
				clr_Z <= '0';
				ld_A <= '0';
				ld_B <= '1';
				ld_C <= '0';
				ld_Z <= '0';
			elsif(INST(31 downto 28) = "0100") then -- LUI
				A_Mux <= '0';
		      B_Mux <= '0';
				IM_MUX1 <= '1';
				REG_Mux <= '0';
				IM_MUX2 <= "00";
				DATA_Mux <= "10";
				ALU_op <= "001";
				clr_IR <= '0';
				ld_IR <= '0';
				clr_A <= '0';
				clr_B <= '1';
				clr_C <= '0';
				clr_Z <= '0';
				ld_A <= '1';
				ld_B <= '0';
				ld_C <= '1';
				ld_Z <= '1';
			elsif(INST(31 downto 28) = "0101") then -- JMP
				A_Mux <= '0';
		      B_Mux <= '0';
				IM_MUX1 <= '0';
				REG_Mux <= '0';
				IM_MUX2 <= "00";
				DATA_Mux <= "00";
				ALU_op <= "000";
				clr_IR <= '0';
				ld_IR <= '0';
				clr_A <= '0';
				clr_B <= '0';
				clr_C <= '0';
				clr_Z <= '0';
				ld_A <= '0';
				ld_B <= '0';
				ld_C <= '0';
				ld_Z <= '0';
			elsif(INST(31 downto 28) = "0110") then -- BEQ
				if(statusZ = '1') then
					A_Mux <= '0';
					B_Mux <= '0';
					IM_MUX1 <= '0';
					REG_Mux <= '0';
					IM_MUX2 <= "00";
					DATA_Mux <= "00";
					ALU_op <= "011";
					inc_PC <= '0';
					ld_PC <= '1';
					clr_IR <= '0';
					ld_IR <= '0';
					clr_A <= '0';
					clr_B <= '0';
					clr_C <= '0';
					clr_Z <= '0';
					ld_A <= '0';
					ld_B <= '0';
					ld_C <= '0';
					ld_Z <= '0';
				end if;
			elsif(INST(31 downto 28) = "1000") then -- BNE
				if(statusZ = '0') then
					A_Mux <= '0';
					B_Mux <= '0';
					IM_MUX1 <= '0';
					REG_Mux <= '0';
					IM_MUX2 <= "00";
					DATA_Mux <= "00";
					ALU_op <= "011";
					inc_PC <= '0';
					ld_PC <= '1';
					clr_IR <= '0';
					ld_IR <= '0';
					clr_A <= '0';
					clr_B <= '0';
					clr_C <= '0';
					clr_Z <= '0';
					ld_A <= '0';
					ld_B <= '0';
					ld_C <= '0';
					ld_Z <= '0';
				end if;
			elsif(INST(31 downto 28) = "0111") then
				CASE INST(27 downto 24) is
					when "0000" => -- ADD
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "10";
						ALU_op <= "010";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';
					when "0001" => -- ADDI
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "01";
						DATA_Mux <= "10";
						ALU_op <= "010";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';
					when "0010" => -- SUB
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "10";
						ALU_op <= "110";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';
					when "0011" => -- INCA
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "10";
						DATA_Mux <= "10";
						ALU_op <= "010";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';	
					when "0100" => -- ROL
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "10";
						ALU_op <= "100";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';
					when "0101" => -- CLRA
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "00";
						ALU_op <= "000";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '1';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';
					when "0110" => -- CLRB
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "00";
						ALU_op <= "000";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '1';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';
					when "0111" => -- CLRC
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "00";
						ALU_op <= "000";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '1';
						clr_Z <= '0';
						ld_A <= '0';
						ld_B <= '0';	
					when "1000" => -- CLRZ
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "00";
						ALU_op <= "000";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '1';
						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';	
					when "1001" => -- ANDI
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "01";
						DATA_Mux <= "10";
						ALU_op <= "000";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';
					when "1010" => -- TSTZ
						if(statusZ = '1') then
							A_Mux <= '0';
							B_Mux <= '0';	
							IM_MUX1 <= '0';
							REG_Mux <= '0';
							IM_MUX2 <= "00";
							DATA_Mux <= "00";
							ALU_op <= "000";
							inc_PC <= '1';
							ld_PC <= '1';
							clr_IR <= '0';
							ld_IR <= '0';
							clr_A <= '0';
							clr_B <= '0';
							clr_C <= '0';
							clr_Z <= '0';
							ld_A <= '0';
							ld_B <= '0';
							ld_C <= '0';
							ld_Z <= '0';
						end if;
					when "1011" => -- AND
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "10";
						ALU_op <= "000";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';
					when "1100" => -- TSTC
						if(statusC = '1') then
							A_Mux <= '0';
							B_Mux <= '0';	
							IM_MUX1 <= '0';
							REG_Mux <= '0';
							IM_MUX2 <= "00";
							DATA_Mux <= "00";
							ALU_op <= "000";
							inc_PC <= '1';
							ld_PC <= '1';
							clr_IR <= '0';
							ld_IR <= '0';
							clr_A <= '0';
							clr_B <= '0';
							clr_C <= '0';
							clr_Z <= '0';
							ld_A <= '0';
							ld_B <= '0';
							ld_C <= '0';
							ld_Z <= '0';
						end if;
					when "1101" => -- ORI
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "01";
						DATA_Mux <= "10";
						ALU_op <= "001";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';
					when "1110" => -- DECA
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "10";
						DATA_Mux <= "10";
						ALU_op <= "110";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';	
					when "1111" => -- ROR
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "10";
						ALU_op <= "101";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '1';
						ld_B <= '0';
						ld_C <= '1';
						ld_Z <= '1';
					when others =>
						A_Mux <= '0';
						B_Mux <= '0';
						IM_MUX1 <= '0';
						REG_Mux <= '0';
						IM_MUX2 <= "00";
						DATA_Mux <= "00";
						ALU_op <= "000";
						clr_IR <= '0';
						ld_IR <= '0';
						clr_A <= '0';
						clr_B <= '0';
						clr_C <= '0';
						clr_Z <= '0';
						ld_A <= '0';
						ld_B <= '0';
						ld_C <= '0';
						ld_Z <= '0';
				end case;
			end if;
		when others =>
			A_Mux <= '0';
		   B_Mux <= '0';
			IM_MUX1 <= '0';
			REG_Mux <= '0';
			IM_MUX2 <= "00";
			DATA_Mux <= "00";
			ALU_op <= "000";
			ld_PC <= '0';
			inc_PC <= '0';
			clr_IR <= '0';
			ld_IR <= '1';
			clr_A <= '0';
			clr_B <= '0';
			clr_C <= '0';
			clr_Z <= '0';
			ld_A <= '0';
			ld_B <= '0';
			ld_C <= '0';
			ld_Z <= '0';
		end case;
	end case;
END process;

-------- STATE MACHINE ---------
PROCESS (clk, enable)
    begin
        IF (clk'EVENT AND clk='1' AND enable='1') THEN
            CASE present_state IS
                WHEN state_0 =>
                    T <= "010";
                    present_state <= state_1;
                WHEN state_1 =>
                    T <= "100";
                    present_state <= state_2;
                WHEN state_2 =>
                    T <= "001";
                    present_state <= state_0;
            END CASE;
        ELSIF (clk='1' AND clk'EVENT) THEN
            T <= "001";
            present_state <= state_0;
        END IF;
END process;

-------- DATA MEMORY INSTRUCTIONS ---------
PROCESS (mclk, clk, INST)
BEGIN

	IF(mclk'EVENT and mclk = '0') THEN
		IF(present_state = state_1 AND clk = '0') THEN
			if(INST(31 downto 28) = "0010") then -- STA
				en <= '1';
				wen <= '1';
			elsif(INST(31 downto 28) = "0011") then -- STB
				en <= '1';
				wen <= '1';
			elsif(INST(31 downto 28) = "1001") then -- LDA
				en <= '1';
				wen <= '0';
			elsif(INST(31 downto 28) = "1010") then -- LDB
				en <= '1';
				wen <= '0';
			else
				en <= '0';
				wen <= '0';
			end if;
			
		ELSIF(present_state = state_2 AND clk = '1') THEN
			if(INST(31 downto 28) = "0010") then -- STA
				en <= '0';
				wen <= '0';
			elsif(INST(31 downto 28) = "0011") then -- STB
				en <= '0';
				wen <= '0';
			elsif(INST(31 downto 28) = "1001") then -- LDA
				en <= '0';
				wen <= '0';
			elsif(INST(31 downto 28) = "1010") then -- LDB
				en <= '0';
				wen <= '0';
			else
				en <= '0';
				wen <= '0';
			end if;	
			
		ELSIF(present_state = state_1) THEN
			if(INST(31 downto 28) = "0010") then -- STA
				en <= '1';
				wen <= '1';
			elsif(INST(31 downto 28) = "0011") then -- STB
				en <= '1';
				wen <= '1';
			elsif(INST(31 downto 28) = "1001") then -- LDA
				en <= '1';
				wen <= '0';
			elsif(INST(31 downto 28) = "1010") then -- LDB
				en <= '1';
				wen <= '0';
			else
				en <= '0';
				wen <= '0';
			end if;

		END IF;
	END IF;
END process;
END description;