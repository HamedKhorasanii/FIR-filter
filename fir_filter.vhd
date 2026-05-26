library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fir_filter is
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        x_in  : in  SIGNED(7 downto 0);
        y_out : out SIGNED(9 downto 0)
    );
end fir_filter;

architecture Behavioral of fir_filter is
    -- ????? ????? (????? ??? ?? 128)
    constant b0 : SIGNED(7 downto 0) := to_signed(5, 8);
    constant b1 : SIGNED(7 downto 0) := to_signed(59, 8);
    constant b2 : SIGNED(7 downto 0) := to_signed(59, 8);
    constant b3 : SIGNED(7 downto 0) := to_signed(5, 8);
    
    -- ???? ?????? ???? ??????? ????????? ?????
    signal x0, x1, x2, x3 : SIGNED(7 downto 0) := (others => '0');
    
    -- ????? ???
    signal m0, m1, m2, m3 : SIGNED(15 downto 0);
    
    -- ??? ?????
    signal sum : SIGNED(17 downto 0);
    
begin
    process(clk, rst)
    begin
        if rst = '1' then
            x0 <= (others => '0');
            x1 <= (others => '0');
            x2 <= (others => '0');
            x3 <= (others => '0');
        elsif rising_edge(clk) then
            -- ???? ????????
            x0 <= x_in;
            x1 <= x0;
            x2 <= x1;
            x3 <= x2;
        end if;
    end process;
    
    -- ??? ????? ?? ????????
    m0 <= x0 * b0;
    m1 <= x1 * b1;
    m2 <= x2 * b2;
    m3 <= x3 * b3;
    
    -- ??? ????
    sum <= resize(m0, 18) + resize(m1, 18) + resize(m2, 18) + resize(m3, 18);
    
    -- ????? (???? 7 ??? ???? ????? ?????)
    y_out <= sum(16 downto 7);
    
end Behavioral;
