library ieee;
use ieee.std_logic_1164.all;

entity controlunit is
    port(
        clk, mclk : in std_logic;
        enable : in std_logic;
        statusc, statusz : in std_logic;
        inst : in std_logic_vector(31 downto 0);
        a_mux, b_mux : out std_logic;
        im_mux1, reg_mux : out std_logic;
        im_mux2, data_mux : out std_logic_vector(1 downto 0);
        alu_op : out std_logic_vector(2 downto 0);
        inc_pc, ld_pc : out std_logic;
        clr_ir : out std_logic;
        ld_ir : out std_logic;
        clr_a, clr_b, clr_c, clr_z : out std_logic;
        ld_a, ld_b, ld_c, ld_z : out std_logic;
        t : out std_logic_vector(2 downto 0);
        wen, en : out std_logic);
end entity;

architecture description of controlunit is
    type state_type is (state_0, state_1, state_2);
    signal present_state: state_type := state_0;

    subtype slv4 is std_logic_vector(3 downto 0);
    alias mem_inst: slv4 is inst(31 downto 28);
    constant do_arith : slv4 := "0111";
    alias arith_inst: slv4 is inst(27 downto 24);
    type arith_type is ( op_add, op_addi, op_sub, op_inca, op_rol, op_clra, op_clrb, op_clrc, op_clrz,
        op_andi, op_and, op_checkz, op_checkc, op_ori, op_deca, op_ror );
    signal arith_op: arith_type;
    use ieee.numeric_std.all;
begin
    arith_op <= arith_type'val(to_integer(unsigned(arith_inst)));
    -------- operation decoder ---------
    op_decoder: process (present_state, inst, statusc, statusz, enable) begin
        -- default assignment
        clr_ir <= '0';
        ld_ir <= '0';
        ld_pc <= '0';
        clr_a <= '0';
        ld_a <= '0';
        clr_b <= '0';
        ld_b <= '0';
        clr_c <= '0';
        ld_c <= '0';
        clr_z <= '0';
        ld_z <= '0';
        alu_op <= (others => '0');
        a_mux <= '0';
        b_mux <= '0';
        reg_mux <= '0';
        data_mux <= (others => '0');
        im_mux1 <= '0';
        im_mux2 <= (others => '0');

        -------- you fill in what goes in here (don't forget to check for enable)
        -------- output assignments
        if enable = '1' then
            case present_state is
                -- state t0
                when state_0 => --ir <= m[inst]
                    ld_ir <= '1';
                    --a_mux <= 'X'; -- what is this!!?!??!? never assign 'X'!
                    --b_mux <= 'X';
                    --reg_mux <= 'X';
                -- state t1
                when state_1 =>
                    case mem_inst is
                        when "0000" => --ldai
                            ld_a <= '1';
                            a_mux <= '1';
                            --reg_mux <= 'X';
                        when "0001" => --ldbi
                            b_mux <= '1';
                            ld_b <= '1';
                            b_mux <= '1';
                            b_mux <= '1';
                        --when "0010" => --sta
                        --    null;
                        when "0011" => --stb
                            reg_mux <= '1';
                        when others =>
                            null;
                    end case;
                    inc_pc <= '1';
                    ld_pc <= '1';
                -- state t2
                when state_2 =>
                    b_mux <= '1';
                    case mem_inst is
                        when "0100" => --lui
                            ld_a <= '1';
                            clr_b <= '1';
                            alu_op <= "001";
                            data_mux <= "10";
                            im_mux1 <= '1';
                        when "0101" => --jmp
                            ld_pc <= '1';
                        when "0110" => --beq
                            if (statusz = '1') then
                                ld_pc <= '1';
                            end if;
                        when do_arith => -- arithmetic
                            case arith_op is
                                when op_add =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    alu_op <= "010";
                                    data_mux <= "10";
                                when op_addi =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    alu_op <= "010";
                                    data_mux <= "10";
                                    im_mux2 <= "01";
                                when op_sub =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    alu_op <= "110";
                                    data_mux <= "10";
                                when op_inca =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    alu_op <= "010";
                                    data_mux <= "10";
                                    im_mux2 <= "10";
                                when op_rol =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    alu_op <= "100";
                                    data_mux <= "10";
                                when op_clra =>
                                    clr_a <= '1';
                                when op_clrb =>
                                    clr_b <= '1';
                                when op_clrc =>
                                    clr_c <= '1';
                                when op_clrz =>
                                    clr_z <= '1';
                                when op_andi =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    data_mux <= "10";
                                    im_mux2 <= "01";
                                when op_and =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    data_mux <= "10";
                                when op_checkz =>
                                    if (statusz = '1') then
                                        inc_pc <= '1';
                                    end if;
                                when op_checkc =>
                                    if (statusc = '1') then
                                        inc_pc <= '1';
                                    end if;
                                when op_ori =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    alu_op <= "001";
                                    data_mux <= "10";
                                    im_mux2 <= "01";
                                when op_deca =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    alu_op <= "110";
                                    data_mux <= "10";
                                    im_mux2 <= "10";
                                when op_ror =>
                                    ld_a <= '1';
                                    ld_c <= '1';
                                    ld_z <= '1';
                                    alu_op <= "111";
                                    data_mux <= "10";
                                when others =>
                                    null;
                            end case;
                        when "1000" => --bne
                            if (statusz = '0') then
                                ld_pc <= '1';
                            end if;
                        when "1001" => --lda
                            ld_a <= '1';
                            data_mux <= "01";
                        when "1010" => --ldb
                            ld_b <= '1';
                            data_mux <= "01";
                        when others =>
                            null;
                    end case;
            end case;
        end if;
    end process;

    -------- state machine ---------
    state_machine: process (clk) begin
        if rising_edge(clk) then
            if enable = '1' then
                case present_state is
                    when state_0 =>
                        present_state <= state_1;
                    when state_1 =>
                        present_state <= state_2;
                    when state_2 =>
                        present_state <= state_0;
                    when others =>
                        present_state <= state_0;
                end case;
            else
                present_state <= state_0;
            end if;
        end if;
    end process;

    -- t seems to be directly related to the state
    assign_t: process (present_state) begin
        t <= (others => '0');
        t(state_type'pos(present_state) + 1) <= '1';
    end process;

    -------- data memory instructions ---------
    data_mem_inst: process (mclk) begin
        if rising_edge(mclk) then
            if (present_state = state_1 and clk = '0') or
               (present_state = state_2 and clk = '1') then
                case mem_inst is
                -- lda and ldb signals
                    when "1001" | "1010" =>
                        en <= '1';
                        wen <= '0';
                -- sta and stb signals
                    when "0010" | "0011" =>
                        en <= '1';
                        wen <= '1';
                -- default case signals
                    when others =>
                        en <= '0';
                        wen <= '0';
                end case;
            elsif present_state = state_1 then -- or alternatively just an else statement
    -- fill in
                en  <= '0';
                wen <= '0';
            end if;
        end if;
    end process;
end architecture;