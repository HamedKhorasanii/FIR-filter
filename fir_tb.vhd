library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity fir_tb is
end fir_tb;

architecture Behavioral of fir_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal x_in : signed(7 downto 0) := (others => '0');
    signal y_out : signed(9 downto 0);
    
    file output_file : text open write_mode is "output.txt";
    
    -- ???? ????? ?? ??? ?????? ??? (50 ?????? ????? 50)
    type sine_table_type is array (0 to 49) of integer;
    constant sine_table : sine_table_type := (
        0, 6, 12, 18, 24, 29, 34, 38, 42, 45,
        48, 49, 50, 49, 48, 45, 42, 38, 34, 29,
        24, 18, 12, 6, 0, -6, -12, -18, -24, -29,
        -34, -38, -42, -45, -48, -49, -50, -49, -48, -45,
        -42, -38, -34, -29, -24, -18, -12, -6, 0, 0
    );
    
begin
    clk <= not clk after 10 ns;
    
    UUT: entity work.fir_filter
        port map (
            clk => clk,
            rst => rst,
            x_in => x_in,
            y_out => y_out
        );
    
    process
        variable line_out : line;
        variable clean_val : integer;
        variable noise_val : integer;
        variable noisy_int : integer;
        variable rand_seed : integer := 12345;
    begin
        rst <= '1';
        wait for 40 ns;
        rst <= '0';
        wait for 20 ns;
        
        for i in 0 to 199 loop
            -- ?????? ???? ?? ???? (????? ?? 50 ?????)
            clean_val := sine_table(i mod 50);
            
            -- ????? ???? ?????????? (?????? -30 ?? +30)
            rand_seed := (rand_seed * 1103515245 + 12345) mod 2147483647;
            noise_val := (rand_seed mod 61) - 30;
            
            -- ??? ?????? ? ????
            noisy_int := clean_val + noise_val;
            
            -- ????? ???? ?? -128 ?? 127
            if noisy_int > 127 then 
                noisy_int := 127; 
            elsif noisy_int < -128 then 
                noisy_int := -128; 
            end if;
            
            x_in <= to_signed(noisy_int, 8);
            wait for 20 ns;
            
            -- ????? ?? ????
            write(line_out, to_integer(x_in));
            write(line_out, string'(" "));
            write(line_out, to_integer(y_out));
            writeline(output_file, line_out);
        end loop;
        
        report "Simulation finished!";
        wait;
    end process;
    
end Behavioral;

