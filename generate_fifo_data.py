# ECE 520: Lab 3 - BRAM FIFO
# Python script for generating test input for BRAM FIFO lab

def generate_fifo_data(mem_depth=32):

    data_file_name = "input_data.txt"

    with open(data_file_name, 'w') as f:

        # Test Case 0: Assert srst, fill some memory, then reassert srst
        # We will track the flags and address pointers to confirm function
        srst = 1
        r_en = 0
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000
        f.write(f"{prebits:01X}{din:04X}\n")

        srst = 0
        r_en = 0
        w_en = 1
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x1111
        for i in range(5):
            f.write(f"{prebits:01X}{din:04X}\n")

        srst = 1
        r_en = 0
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000
        f.write(f"{prebits:01X}{din:04X}\n")

        # Test Case 1a: Write all 1's
        srst = 0
        r_en = 0
        w_en = 1
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0xFFFF
        f.write(f"{prebits:01X}{din:04X}\n")

        # Test Case 1b: Read all 1's
        srst = 0
        r_en = 1
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000 # reset din
        f.write(f"{prebits:01X}{din:04X}\n")

        # Test Case 2a: Write all 0's
        srst = 0
        r_en = 0
        w_en = 1
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000
        f.write(f"{prebits:01X}{din:04X}\n")

        # Test Case 2b: Read all 0's
        srst = 0
        r_en = 1
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000 # reset din
        f.write(f"{prebits:01X}{din:04X}\n")

        # Test Case 3: Write/Read alternating bit pattern 0xAAAA
        srst = 0
        r_en = 0
        w_en = 1
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0xAAAA
        f.write(f"{prebits:01X}{din:04X}\n")

        r_en = 1
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000 # reset din
        f.write(f"{prebits:01X}{din:04X}\n")


        # Test Case 4: Write to every address, then read every address
        srst = 1
        r_en = 0
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000
        f.write(f"{prebits:01X}{din:04X}\n")

        srst = 0
        r_en = 0
        w_en = 1
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x5555
        for i in range(mem_depth):
            f.write(f"{prebits:01X}{din:04X}\n")

        r_en = 1
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000 # reset din
        for i in range(mem_depth):
            f.write(f"{prebits:01X}{din:04X}\n")

        # Test Case 5: Fill memory, then try to write
        srst = 1
        r_en = 0
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000
        f.write(f"{prebits:01X}{din:04X}\n")

        srst = 0
        r_en = 0
        w_en = 1
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x5555
        for i in range(mem_depth):
            f.write(f"{prebits:01X}{din:04X}\n")

        din = 0x1111
        f.write(f"{prebits:01X}{din:04X}\n")

        r_en = 1
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000
        f.write(f"{prebits:01X}{din:04X}\n")

        # Test Case 6: Simultaneous Read/Write
        srst = 1
        r_en = 0
        w_en = 0
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x0000
        f.write(f"{prebits:01X}{din:04X}\n")

        srst = 0
        r_en = 0
        w_en = 1
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0xAAAA
        for i in range(5):
            f.write(f"{prebits:01X}{din:04X}\n")

        srst = 0
        r_en = 1
        w_en = 1
        prebits = srst << 2 | r_en << 1 | w_en
        din = 0x5555
        f.write(f"{prebits:01X}{din:04X}\n")

if __name__ == "__main__":
    generate_fifo_data()
