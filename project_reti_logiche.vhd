library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
    port (
        i_clk : in STD_LOGIC;
        i_rst : in STD_LOGIC;
        i_start : in STD_LOGIC;
        i_w : in STD_LOGIC;
        o_z0 : out STD_LOGIC_VECTOR(7 downto 0);
        o_z1 : out STD_LOGIC_VECTOR(7 downto 0);
        o_z2 : out STD_LOGIC_VECTOR(7 downto 0);
        o_z3 : out STD_LOGIC_VECTOR(7 downto 0);
        o_done : out STD_LOGIC;
        o_mem_addr : out STD_LOGIC_VECTOR(15 downto 0);
        i_mem_data : in STD_LOGIC_VECTOR(7 downto 0);
        o_mem_we : out STD_LOGIC;
        o_mem_en : out STD_LOGIC
        );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
component datapath is
    port (
        i_clk : in STD_LOGIC;
        i_rst : in STD_LOGIC;
        i_start : in STD_LOGIC;
        i_w : in STD_LOGIC;
        o_mem_addr : out STD_LOGIC_VECTOR(15 downto 0);
        i_mem_data : in STD_LOGIC_VECTOR(7 downto 0);
        rsel_load : in STD_LOGIC;
        r0_load : in STD_LOGIC;
        r1_load : in STD_LOGIC;
        r2_load : in STD_LOGIC;
        r3_load : in STD_LOGIC;
        update_demux : in STD_LOGIC;
        to_zero : in STD_LOGIC;
        head : in STD_LOGIC;
        o_z0 : out STD_LOGIC_VECTOR(7 downto 0);
        o_z1 : out STD_LOGIC_VECTOR(7 downto 0);
        o_z2 : out STD_LOGIC_VECTOR(7 downto 0);
        o_z3 : out STD_LOGIC_VECTOR(7 downto 0);
        o_done : out STD_LOGIC;
        i_done : in STD_LOGIC
        );                      
end component;

signal rsel_load : STD_LOGIC;
signal r0_load : STD_LOGIC;
signal r1_load : STD_LOGIC;
signal r2_load : STD_LOGIC;
signal r3_load : STD_LOGIC;
signal head : STD_LOGIC;
signal i_done : STD_LOGIC;
signal update_demux : STD_LOGIC;
signal to_zero : STD_LOGIC;
type S is (S0,S1,S2,S3,S4,S5,S6);
signal cur_state, next_state : S;

begin
    DATAPATH0: datapath port map(
        i_clk,
        i_rst,
        i_start,
        i_w,
        o_mem_addr,
        i_mem_data,
        rsel_load,
        r0_load,
        r1_load,
        r2_load,
        r3_load,
        update_demux,
        to_zero,
        head,
        o_z0,
        o_z1,
        o_z2,
        o_z3,
        o_done,
        i_done
    );

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
        elsif rising_edge(i_clk) then
            cur_state <= next_state;
        end if;
    end process;
    
    process(cur_state, i_start)
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                if i_start = '1' then
                    next_state <= S3;
                else
                    next_state <= S4;
                end if;
            when S3 =>
                if i_start = '0' then
                    next_state <= S4;
                end if;
            when S4 =>
                next_state <= S5;
            when S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S0;
        end case;
    end process;
    
    process(cur_state)
    begin
        rsel_load <= '0';
        r0_load <= '0';
        r1_load <= '0';
        r2_load <= '0';
        r3_load <= '0';
        update_demux <= '0';
        to_zero <= '0';
        head <= '0';
        i_done <= '0';
        o_mem_en <= '0';
        o_mem_we <= '0';
        case cur_state is
            when S0 =>
                i_done <= '0';
            when S1 =>
            when S2 =>
                head <= '1';
            when S3 =>
                head <= '1';
            when S4 =>
                rsel_load <= '1';
                o_mem_en <= '1';
            when S5 =>
                r0_load <= '1';
                r1_load <= '1';
                r2_load <= '1';
                r3_load <= '1';
                update_demux <= '1';
            when S6 =>
                i_done <= '1';
                to_zero <= '1';
        end case;
    end process;
end Behavioral;

-- DATAPATH DECLARATION

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
    port (
        i_clk : in STD_LOGIC;
        i_rst : in STD_LOGIC;
        i_start : in STD_LOGIC;
        i_w : in STD_LOGIC;
        o_mem_addr : out STD_LOGIC_VECTOR(15 downto 0);
        i_mem_data : in STD_LOGIC_VECTOR(7 downto 0);
        rsel_load : in STD_LOGIC;
        r0_load : in STD_LOGIC;
        r1_load : in STD_LOGIC;
        r2_load : in STD_LOGIC;
        r3_load : in STD_LOGIC;
        update_demux : in STD_LOGIC;
        to_zero : in STD_LOGIC;
        head : in STD_LOGIC;
        o_z0 : out STD_LOGIC_VECTOR(7 downto 0);
        o_z1 : out STD_LOGIC_VECTOR(7 downto 0);
        o_z2 : out STD_LOGIC_VECTOR(7 downto 0);
        o_z3 : out STD_LOGIC_VECTOR(7 downto 0);
        o_done : out STD_LOGIC;
        i_done : in STD_LOGIC
        );                      
end datapath;

architecture Behavioral of datapath is
signal addr : STD_LOGIC_VECTOR(15 downto 0);
signal sel_demux : STD_LOGIC_VECTOR(1 downto 0);
signal o_demux0 : STD_LOGIC_VECTOR(7 downto 0);
signal o_demux1 : STD_LOGIC_VECTOR(7 downto 0);
signal o_demux2 : STD_LOGIC_VECTOR(7 downto 0);
signal o_demux3 : STD_LOGIC_VECTOR(7 downto 0);
signal o_rsel : STD_LOGIC_VECTOR(1 downto 0);
signal o_reg0 : STD_LOGIC_VECTOR(7 downto 0);
signal o_reg1 : STD_LOGIC_VECTOR(7 downto 0);
signal o_reg2 : STD_LOGIC_VECTOR(7 downto 0);
signal o_reg3 : STD_LOGIC_VECTOR(7 downto 0);

begin

    process(i_start, i_clk, i_rst, head, to_zero)
    begin
        if(i_rst = '1' or to_zero = '1') then
            sel_demux <= (others => '0');
            addr <= (others => '0');
        elsif rising_edge(i_clk) and i_start = '1' then
            if head = '0' then 
                -- shift
                sel_demux <= sel_demux(0) & i_w;
            else
                addr <= addr(14 downto 0) & i_w;
            end if;
        end if;
    end process;
    
    o_mem_addr <= addr;
    
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_rsel <= (others => '0');
        elsif rising_edge(i_clk) then
            if rsel_load = '1' then
                o_rsel <= sel_demux;
            end if;
        end if;
    end process;
    
    process(i_mem_data, update_demux, o_rsel, o_reg0, o_reg1, o_reg2, o_reg3)
    begin
        if(update_demux='1' and o_rsel="00") then
            o_demux0 <= i_mem_data;
            o_demux1 <= o_reg1;
            o_demux2 <= o_reg2;
            o_demux3 <= o_reg3;
        elsif(update_demux='1' and o_rsel="01") then
            o_demux0 <= o_reg0;
            o_demux1 <= i_mem_data;
            o_demux2 <= o_reg2;
            o_demux3 <= o_reg3;
        elsif (update_demux='1' and o_rsel="10") then
            o_demux0 <= o_reg0;
            o_demux1 <= o_reg1;
            o_demux2 <= i_mem_data;
            o_demux3 <= o_reg3;
        elsif (update_demux='1' and o_rsel="11") then
            o_demux0 <= o_reg0;
            o_demux1 <= o_reg1;
            o_demux2 <= o_reg2;
            o_demux3 <= i_mem_data;
        else
            o_demux0 <= "XXXXXXXX";
            o_demux1 <= "XXXXXXXX";
            o_demux2 <= "XXXXXXXX";
            o_demux3 <= "XXXXXXXX";
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_reg0 <= (others => '0');
            o_reg1 <= (others => '0');
            o_reg2 <= (others => '0');
            o_reg3 <= (others => '0');      
        elsif rising_edge(i_clk) then
            if r0_load = '1' then
                o_reg0 <= o_demux0;
            end if;
            if r1_load = '1' then
                o_reg1 <= o_demux1;
            end if;
            if r2_load = '1' then
                o_reg2 <= o_demux2;
            end if;
            if r3_load = '1' then
                o_reg3 <= o_demux3;
            end if;
        end if;
    end process;
    
    process(i_done, o_reg0, o_reg1, o_reg2, o_reg3)
    begin
        case i_done is
            when '0' =>
                o_z0 <= "00000000";
                o_z1 <= "00000000";
                o_z2 <= "00000000";
                o_z3 <= "00000000";
            when '1' =>
                o_z0 <= o_reg0;
                o_z1 <= o_reg1;
                o_z2 <= o_reg2;
                o_z3 <= o_reg3;
            when others =>
        end case;
    end process;
    
    o_done <= i_done;

end Behavioral;