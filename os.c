// OS for ZaC-3

// Todo:
// - When in the write command, only accept number-letter inputs, if it's a space or enter or whatever, then skip it. This is to allow simple
//   copy-pasting of HEX files into the terminal if you want to quickly load programs and data.
//
// - Change the "exit" key from write command from an enter to esc.
//
// - Implement run command, this would use my C-compiler specific "run" keyword which sets the program counter to the specified address.
//   Normally in modern C you would use a function pointer, but I don't have function pointers implemented in my C compiler, so I use this
//   method instead of just making my own special keywords.

#include "bios.h"
#include "stdio.h"

int get_int(char *shell_buf) {
    int shell_buf_offset = 0;
    int result = 0;
    int int_length = 0;
    //cr();
    while (*(shell_buf + shell_buf_offset) > 32) {
        //print_char(*(shell_buf + shell_buf_offset));
        shell_buf_offset = shell_buf_offset + 1;
        int_length = int_length + 1;
    }
    int_length = int_length << 2;
    for (int i = 0; i < int_length; i = i + 4) {
        shell_buf_offset = shell_buf_offset - 1;
        result = result + (get_hex_int(*(shell_buf + shell_buf_offset)) << i);
        
    }
    
    return result;
}

int compare_fixed_string(char *str_a, char *str_b, int size) {
    int i = 0;
    //printChar(43);
    while ((i < size) && (*(str_a + i) == *(str_b + i))) {
        i = i + 1;
        //printChar(42);
    }
    if (i == size) {
        return 1;
    }
    return 0;
}

int compare_string(char *str_a, char *str_b) {
    int i = 0;

    while (*(str_a + i) == *(str_b + i)) {
        i = i + 1;
        if (*(str_b + i) == 0) {
            return 1;
        }
        
        if (*(str_a + i) == 32) {
            return 1;
        }
    }
    return 0;
}

void reset_shell(char *shell_buf) {
    int shell_buf_offset = 0;
    while (shell_buf_offset < 256) {
        *(shell_buf + shell_buf_offset) = 0;
        shell_buf_offset = shell_buf_offset + 1;
    }
    char *prompt = ">";
    printString(prompt);
}

int read_halfword_hex(char *string_buf) {
    int offset = 0;
    offset = offset + 1;
    int input_a = 0;
    char current_char = *(string_buf + offset);
    input_a = (*(string_buf + offset) - 48) << 12;
    offset = offset + 1;
    input_a = input_a + ((*(string_buf + offset) - 48) << 8);
    offset = offset + 1;
    input_a = input_a + ((*(string_buf + offset) - 48) << 4);
    offset = offset + 1;
    input_a = input_a + (*(string_buf + offset) - 48);
    offset = offset + 1;
    return input_a;
}

int skip_space_old(char *shell_buf) {
    int offset = 0;
    while (*(shell_buf + offset) < 33) {
        offset = offset + 1;
    }
    return offset;
}

int skip_non_space(char *shell_buf, int shell_buf_offset) {
    int offset = shell_buf_offset;
    while (*(shell_buf + offset) > 32) {
        offset = offset + 1;
    }
    return offset;
}

void dump_command(char *shell_buf, int shell_buf_offset) {
    char *cr = "\n";
    char *space = " ";
    char *dump_success = "dump command detected\n";
    char *offset_str = "shell_buf_offset: ";
    char *debug = 9000000;
    //printString(dump_success);
    //printString(offset_str);
    //print_hex(shell_buf_offset);
    //printString(cr);
    shell_buf_offset = shell_buf_offset + 1;
    int input_a = 0;
    char current_char = *(shell_buf + shell_buf_offset);

    
    input_a = get_int(shell_buf + shell_buf_offset);
    shell_buf_offset = skip_non_space(shell_buf, shell_buf_offset);
    //print_int_hex(input_a);
    shell_buf_offset = shell_buf_offset + 1;

    int input_b = 0;
    input_b = get_int(shell_buf + shell_buf_offset);
    //cr();
    //print_int_hex(input_b);
    //cr();
    char *dump_ptr = input_a;
    int col_ctr = 0;
    while (dump_ptr < input_a + input_b) {
        if (((col_ctr - 1) & 7) == 7) {
            print_char(32);
        }
        if (((col_ctr - 1) & 15) == 15) {
            printString(cr);
            print_int_hex(dump_ptr);
            print_char(58);
            print_char(32);
            print_char(32);
            
        }
        print_hex_byte(*dump_ptr);
        print_char(32);
        col_ctr = col_ctr + 1;
        dump_ptr = dump_ptr + 1;
        if ((dump_ptr > input_a) && (((col_ctr - 1) & 15) == 15)) {
            //printString(cr);
            col_ctr = 0;
            while (col_ctr < 16) {
                char dump_char = *(dump_ptr + col_ctr - 16);
                if (dump_char > 31 && dump_char < 127) {
                    print_char(dump_char);
                }
                if (dump_char < 32 || dump_char > 126) {
                    print_char(46);
                }
                col_ctr = col_ctr + 1;
            }
        }
    }
    printString(cr);
}

void write_command(char *shell_buf, int shell_buf_offset) {
    char *write_str = "write command detected\n";
    char *cr = "\n";
    printString(write_str);
    shell_buf_offset = shell_buf_offset + 1;
    int input_a = 0;
    char current_char = *(shell_buf + shell_buf_offset);
    // 32-bit address input

    //for (int i = 32; i > 0; i = i - 4) {
    //    input_a = input_a + get_hex_int(*(shell_buf + shell_buf_offset)) << (i - 4);
    //    shell_buf_offset = shell_buf_offset + 1;
    //}

    input_a = get_int(shell_buf + shell_buf_offset);

    char *write_ptr = input_a;
    int display_ptr = write_ptr;
    char write_value = 0;
    int run = 1;
    char input_char_a = 0;
    char input_char_b = 0;
    char input_char_c = 0;
    char *hex_to_dec = "0123456789       :;<=>?";
    while (run == 1) {
        display_ptr = write_ptr;
        print_int_hex(display_ptr);
        print_char(58);
        print_char(32);
        if (run == 1) {
            input_char_a = get_char();
        }
        if (input_char_a == 13) {
            run = 0;
        }
        if (run == 1) {
            print_char(input_char_a);
            input_char_b = get_char();
            print_char(input_char_b);
        }
        input_char_c = get_char();
        if (input_char_c == 13) {
            run = 0;
        }
        if (run == 1) {
            write_value = 0;
            write_value = get_hex_int(input_char_a) << 4;
            write_value = write_value + get_hex_int(input_char_b);
            *write_ptr = write_value;
            write_ptr = write_ptr + 1;
        }


        //print_hex_byte(write_value);
        printString(cr);
    }
}

void run_command(char *shell_buf, int shell_buf_offset) {
    char *run_str = "run command detected\n";
    int run_address = 131072;
    //char *debug = 9000000;
    printString(run_str);
    //$run run_address;
    asm("addi r1, r0, 0");
    asm("lui r1, 2");
    asm("jr r1");
}

int multiply(int a, int b) {
    int result = 0;
    for (int i = 0; i < b; i = i + 1) {
        result = result + a;
    }
    return result;
}

int divide(int a, int b) {
    int result = 0;
    int diff = a;
    while (diff < 32768) {
        diff = diff - b;
        result = result + 1;
    }
    return result;
}

int mod(int a, int b) {
    int result = 0;
    int diff = a;
    while (diff < 32768) {
        diff = diff - b;
        result = result + 1;
    }
    result = diff + b;
    return result;
}



void system_call() {
    //print_bcd(func_number);
    //char *syscall_str = "System call test\n";
    //char *print_test_str = "print call test\n";
    //printString(syscall_str);
    // function_number in r17
    // arguments and returns in r17,r18,r19,r20

    

    static int func_number;
    static int arg0;
    static int arg1;
    static int arg2;
    static int arg3;
    asm("movi [dp + system_call_func_number], r16");
    asm("movi [dp + system_call_arg0], r17");
    asm("movi [dp + system_call_arg1], r18");
    asm("movi [dp + system_call_arg2], r19");
    asm("movi [dp + system_call_arg3], r20");

    char *debug = 9000000;
    //*debug = 0;

    static int return_value = 0;

    if (func_number == 0) {
        print_char(arg0);
    }
    if (func_number == 1) {
        return_value = get_char();
    }
    if (func_number == 2) {
        printString(arg0);
    }

    if (func_number == 10) {
        //char *reset_str = "Return to system call\n";
        //printString(reset_str);
        asm("addi r1, r0, _shell");
        asm("jr r1");
    }

    asm("movi r17, [dp + system_call_return_value]"); // return int goes into r17
}

int setMountValues(int mount_values) {
    // mount_values: xxxxxxxxAAAAAAAABBBBBBBBCCCCCCCC, A = data_start, B = root_start, C = FAT_start
    int *mount_values_ptr = 459008;
    *mount_values_ptr = mount_values;
}

int getMountValues() {
    // mount_values: xxxxxxxxAAAAAAAABBBBBBBBCCCCCCCC, A = data_start, B = root_start, C = FAT_start
    int *mount_values_ptr = 459008;
    int mount_values = *mount_values_ptr;
    char *error = "Disk not mounted!\n";

    if (mount_values == 0) {
        printString(error);
        exit();
    }

    return mount_values;
}

int getFileInstanceTable() {
    return 458752;
}

int getMountValuesBase() {
    return 459008;
}

int getSectorsPerCluster() {
    char *mount_values_base = getMountValuesBase();
    int sectors_per_cluster = *(mount_values_base+4);
    return sectors_per_cluster;
}

int mount_command() {
    // 0x00070100: Mount variables
    int *disk_io = 1245440;
    char *mount_values_base = getMountValuesBase();
    int *disk_test_buffer_int = getDiskBufferBase();
    char *disk_test_buffer = disk_test_buffer_int;
    char *output_str = "Disk test\n";
    printString(output_str);


    diskRead(disk_test_buffer_int, 0);

    int sectors_per_cluster;
    int BPB_number_of_fats;
    int root_dir_count;
    int BPB_FATSz;
    int BPB_ResvdSecCnt;
    int BPB_RootEntCnt;
    int BPB_BytsPerSec = 512;

    sectors_per_cluster = *(disk_test_buffer + 13);
    BPB_number_of_fats = *(disk_test_buffer + 16);
    root_dir_count = *(disk_test_buffer + 17) + (*(disk_test_buffer + 18) << 8);
    BPB_FATSz = *(disk_test_buffer + 22) + (*(disk_test_buffer + 23) << 8);
    BPB_ResvdSecCnt = *(disk_test_buffer + 14) + (*(disk_test_buffer + 15) << 8);
    BPB_RootEntCnt = *(disk_test_buffer + 17) + (*(disk_test_buffer + 18) << 8);

    *(mount_values_base+4) = sectors_per_cluster;
    
    int FAT_start;
    int root_start;
    int data_start;

    FAT_start = BPB_ResvdSecCnt;
    int FatSectors;
    FatSectors = BPB_FATSz << 1;
    
    root_start = FAT_start + FatSectors;

    int RootDirSectors;

    RootDirSectors = ((BPB_RootEntCnt << 5) + BPB_BytsPerSec - 1) >> 9;

    //print_bcd(RootDirSectors);

    data_start = root_start + RootDirSectors;

    char *FAT_str = "FAT offset: ";
    char *root_str = "Root offset: ";
    char *data_str = "Data offset: ";
    char *sectors_per_cluster_str = "Sectors per cluster: ";

    printString(FAT_str);
    print_bcd(FAT_start);
    cr();
    printString(root_str);
    print_bcd(root_start);
    cr();
    printString(data_str);
    print_bcd(data_start);
    cr();
    printString(sectors_per_cluster_str);
    print_bcd(sectors_per_cluster);
    cr();

    int return_value = FAT_start + (root_start << 8) + (data_start << 16); // hacky way to return 3 8-bit integers, just store them in a 32-bit word shifted accross.

    setMountValues(return_value);


    return return_value;
}

int getDiskIOBase() {
    return 1245440;
}

int getDiskBufferBase() {
    return 524288;
}

int dir_command() {
    int mount_values = getMountValues();


    int *disk_io = 1245440;
    int *disk_test_buffer_int = getDiskBufferBase();
    char *disk_test_buffer = disk_test_buffer_int;
    char *output_str = "Disk test\n";

    int FAT_start;
    int root_start;
    int data_start;

    FAT_start = mount_values & 255;
    root_start = (mount_values >> 8) & 255;
    data_start = (mount_values >> 16) & 255;

    if (mount_values == 0) {
        char *error = "Disk not mounted!\n";
        printString(error);
        return 0;
    }

    
    //cr();
    int number_of_files = 0;
    for (int sectors = root_start; sectors < data_start; sectors = sectors + 1) {
        diskRead(disk_test_buffer_int, sectors);
        
        for (int i = 0; i < 512; i = i + 32) {
            int dir_attrib = *(disk_test_buffer + i + 11);
            int first_dir_char = *(disk_test_buffer + i);

            if ((dir_attrib != 15) && (first_dir_char < 128) && (first_dir_char > 0)) {
                
                if (number_of_files > 0) {
                if (dir_attrib != 8) {
                        printChar(32);
                        printChar(58);
                        printChar(32);
                }
                }

                if ((dir_attrib & 16) == 16) {
                    printChar(42);
                }

                if (dir_attrib == 8) {
                    
                    char *volume_msg = "Volume name: ";
                    printString(volume_msg);
                }
                if (dir_attrib != 8) {
                    number_of_files = number_of_files + 1;
                }
                for (int j = 0; j < 11; j = j + 1) {
                    printChar(*(disk_test_buffer + i + j));
                }
                if (dir_attrib == 8) {
                    //cr();
                    cr();
                }
            } 
        }
    }
    cr();
    char *number_of_files_str = " file(s)\n";
    printChar(9);
    print_bcd(number_of_files);
    printString(number_of_files_str);
    cr();
    return 0;
}

void searchfile_command(char *shell_buf, int shell_buf_offset) {
    int dir_value = searchFile(shell_buf + shell_buf_offset);
    int lba_offset = dir_value >> 9;
    int buf_offset = dir_value & 511;

    print_hex(lba_offset);
    cr();
    print_hex(buf_offset);
    cr();
}

int getDirectoryStart(int mount_values) {
    return (mount_values >> 8) & 255;
}

int getDataStart(int mount_values) {
    return (mount_values >> 16) & 255;
}

int getFATStart(int mount_values) {
    return mount_values & 255;
}

void makeUppercase(char *string) {
    int i = 0;
    while ((i < 256) && ((*(string + i) != 0))) {
        if ((*(string + i) > 96) && (*(string + i) < 123)) {
            *(string + i) = *(string + i) - 32;
        }
        i = i + 1;
    }
}

int searchFile(char *filename_str) {
    // Search file
    // inputs: char *filename_str: filename string
    // returns: 0-0xFFFE = File index in root, 0xFFFFFFFF = File not found

    // filename_str requires dot separator and filename extension (e.g. "filename.txt")
    int mount_values = getMountValues();
    int dir_start = getDirectoryStart(mount_values);
    int data_start = getDataStart(mount_values);
    char *filename_main = "        ";
    char *filename_ext  = "   ";
    char *filename_total = "           ";
    //debug();

    makeUppercase(filename_str);


    int i = 0;
    for (i = 0; i < 8; i = i + 1) {
        *(filename_main + i) = 32;
    }
    for (i = 0; i < 3; i = i + 1) {
        *(filename_ext + i) = 32;
    }
    i = 0;
    while ((i < 8) && (*(filename_str + i) != 46) && (*(filename_str + i) > 0)) {
        *(filename_main + i) = *(filename_str + i);
        i = i + 1;
    }
    i = i + 1;
    int j = 0;
    while ((i < 11) && ((*(filename_str + i) != 0) || (*(filename_str + i) != 32)) && (*(filename_str + i) > 0)) {
        *(filename_ext + j) = *(filename_str + i);
        i = i + 1;
        j = j + 1;
    }

    for (i = 0; i < 8; i = i + 1) {
        *(filename_total + i) = *(filename_main + i);
    }
    j = i;

    for (i = 0; i < 3; i = i + 1) {
        *(filename_total + j) = *(filename_ext + i);
        j = j + 1;
    }

    //printString(filename_main);
    //cr();
    //printString(filename_ext);
    //cr();
    //printString(filename_total);
    //cr();

    char *disk_test_buffer = getDiskBufferBase();
    


    // now compare filename_total to directory entry filenames
   int number_of_files = 0;
   int FILENAME_FIXED_SIZE = 11;
    for (int sectors = dir_start; sectors < data_start; sectors = sectors + 1) {
        diskRead(disk_test_buffer, sectors);
        
        for (i = 0; i < 512; i = i + 32) {
            int dir_attrib = *(disk_test_buffer + i + 11);
            int first_dir_char = *(disk_test_buffer + i);

            if ((dir_attrib != 15) && (first_dir_char < 128) && (first_dir_char > 0)) {
                number_of_files = number_of_files + 1;
                int result = compare_fixed_string(disk_test_buffer + i, filename_total, FILENAME_FIXED_SIZE);
                if (result == 1) {
                    //print_bcd(number_of_files);
                    return (sectors << 9) + i; // AAAAAAAA BBBBBBBBB: A = LBA offset, B = buffer offset in sector
                }
            }
        }
    }
    return 65536;
}

int openFile(char *filename_str) {
    // openFile function
    // opens a file
    // inputs: char *filename_str = asciiz filename string
    // outputs: filehandle 32-bit integer

    // 0x00070000 - 0x000700FF: Open file instance list
    // 0x00070100: Mount variables
    // Byte offset (0:F)
    // 0:3 = 32-bit filesize
    // 4:7 = 32-bit file seek offset
    // 8:9 = current FAT16 cluster number
    // A = Open file valid (0 = closed, 1 = open)
    // B:F = reserved

    // get all the first_cluster information for the file
    char *file_instance_list = getFileInstanceTable();
    int *file_instance_list_int = file_instance_list;
    int mount_values = getMountValues();
    int root_start = getDirectoryStart(mount_values);
    int FAT_start = getFATStart(mount_values);
    int dir_position;

    dir_position = searchFile(filename_str);
    if (dir_position == 65536) {
        return 255;
    }
    int lba_offset = dir_position >> 9;
    int buf_offset = dir_position & 511;
    int disk_buffer_base = getDiskBufferBase();
    char *dir_offset = disk_buffer_base + buf_offset;
    diskRead(disk_buffer_base, lba_offset);

    int cluster_offset = (*(dir_offset + 26)) + (*(dir_offset + 27) << 8);
    int filesize = (*(dir_offset + 28)) + (*(dir_offset + 29) << 8) + (*(dir_offset + 30) << 16) + (*(dir_offset + 31) << 24);

    // now create file instance
    int i = 0;
    while ((i < 256) && (*(file_instance_list + i + 10) != 0)) {
        i = i + 16;
    }
    if (i == 256) {
        return 256;
    }

    // now write to file instance table
    *(file_instance_list + i + 0) = filesize & 255;
    *(file_instance_list + i + 1) = (filesize >> 8) & 255;
    *(file_instance_list + i + 2) = (filesize >> 16) & 255;
    *(file_instance_list + i + 3) = (filesize >> 24) & 255;
    
    *(file_instance_list + i + 4) = 0;
    *(file_instance_list + i + 5) = 0;
    *(file_instance_list + i + 6) = 0;
    *(file_instance_list + i + 7) = 0;

    *(file_instance_list + i + 8) = cluster_offset & 255;
    *(file_instance_list + i + 9) = (cluster_offset >> 8) & 255;

    *(file_instance_list + i + 10) = 1; // set file open attribute to true
    return i;
}

int closeFile(int filehandle) {
    char *file_instance_list = getFileInstanceTable();

    if (filehandle > 240) {
        return 1;
    }
    for (int i = 0; i < 16; i = i + 1) {
        *(file_instance_list + filehandle + i) = 0;
    }
    return 0;
}

int isFileOpen(int filehandle) {
    char *file_instance_list = getFileInstanceTable();
    return *(file_instance_list + filehandle + 10);
}

void checkFileHandleValid(int filehandle) {
    if (filehandle > 240) {
        char *error_1 = "Invalid filehandle\n";
        printString(error_1);
        exit();
    }
    if (isFileOpen(filehandle) == 0) {
        char *error = "File not open!\n";
        printString(error);
        exit();
    }
}

int getFileSeek(int filehandle) {
    checkFileHandleValid(filehandle);
    char *file_instance_list = getFileInstanceTable();
    int seek = 0;

    seek = *(file_instance_list + filehandle + 4) = 0;
    seek = seek + (*(file_instance_list + filehandle + 5) << 8);
    seek = seek + (*(file_instance_list + filehandle + 6) << 16);
    seek = seek + (*(file_instance_list + filehandle + 7) << 24);

    return seek;
}

void setFileSeek(int seek, int filehandle) {
}

int getCurrentFileCluster(int filehandle) {
    checkFileHandleValid(filehandle);
    char *file_instance_list = getFileInstanceTable();
    int current_cluster = 0;
    current_cluster = (*(file_instance_list + 8)) + (*(file_instance_list + 9) << 8);
    return current_cluster;
}

void setCurrentFileCluster(int cluster, int filehandle) {
}

int getFileHandleSize(int filehandle) {
    checkFileHandleValid(filehandle);
    char *file_instance_list = getFileInstanceTable();
    int size = 0;
    size = (*(file_instance_list + 0)) + (*(file_instance_list + 1) << 8) + (*(file_instance_list + 2) << 16) + (*(file_instance_list + 3) << 24);
    return size;
}

void setFileHandleSize(int filehandle) {
}

int readFile(char *buffer, int count, int filehandle) {
    checkFileHandleValid(filehandle);
    int seek = getFileSeek(filehandle);
    int current_cluster = getCurrentFileCluster(filehandle);
    int size = getFileHandleSize(filehandle);
    char *disk_buffer = getDiskBufferBase();
    int mount_values = getMountValues();
    char *FAT_region = getFATStart(mount_values);
    int data_region = getDataStart(mount_values);
    int sectors_per_cluster = getSectorsPerCluster(mount_values);

    //print_bcd(sectors_per_cluster);
    //cr();

    //print_bcd(seek);
    //cr();
    //print_hex(current_cluster);
    //cr();
    //print_bcd(size);
    //cr();

    int current_cluster_sector = data_region + ((current_cluster - 2) << 6);
    //print_int_hex(current_cluster_sector);
    //cr();

    int byte_count = 0;
    int cluster_count = 0;

    //print_bcd(count);
    //cr();

    while (byte_count < count) {
        if (count - byte_count < 512) {
            // manual copying when less than 512 bytes to read
            //print_char(42);
            diskRead(disk_buffer, current_cluster_sector);
            for (int i = 0; i < count - byte_count; i = i + 1) {
                *(buffer + byte_count + i) = *(disk_buffer + i);
            }
            byte_count = byte_count + 512;
            return 0;
        }

        if (count - byte_count > 511) {
            // fast direct sector read
            //print_char(43);
            diskRead(buffer + byte_count, current_cluster_sector);
            byte_count = byte_count + 512;
            cluster_count = cluster_count + 1;
            current_cluster_sector = current_cluster_sector + 1;
        }

        if (cluster_count > sectors_per_cluster) {
            // fetch next FAT cluster
            cluster_count = 0;
            
            if (current_cluster == 65536) {
                return 0;
            }
            current_cluster = *(FAT_region + (current_cluster << 1)) + (*(FAT_region + (current_cluster << 1) + 1) << 8);
            current_cluster_sector = data_region + ((current_cluster - 2) << 6);


            // todo
            return 0;
        }
    }
}

int writeFile(char *buffer, int count, int filehandle) {
}

int open_command(char *shell_buf, int shell_buf_offset) {
    // open_command
    // opens a file instance
    // inputs: char *filename_str = filename string
    // returns: file handle


    int cluster_offset = openFile(shell_buf + shell_buf_offset);
    print_hex(cluster_offset);
    cr();

}

void close_command(char *shell_buf, int shell_buf_offset) {
    int filehandle = get_int(shell_buf + shell_buf_offset);
    closeFile(filehandle);
}

void filerd_command(char *shell_buf, int shell_buf_offset) {
    shell_buf_offset = skip_space(shell_buf, shell_buf_offset);
    int buffer = get_int(shell_buf + shell_buf_offset);
    shell_buf_offset = skip_non_space(shell_buf, shell_buf_offset);
    shell_buf_offset = skip_space(shell_buf, shell_buf_offset);
    int count = get_int(shell_buf + shell_buf_offset);
    shell_buf_offset = skip_non_space(shell_buf, shell_buf_offset);
    shell_buf_offset = skip_space(shell_buf, shell_buf_offset);
    int filehandle = get_int(shell_buf + shell_buf_offset);
    //print_int_hex(filehandle);
    //cr();
    //print_int_hex(buffer);
    //cr();
    //print_int_hex(count);
    //cr();
    
    readFile(buffer, count, filehandle);
}

void filewr_command(char *shell_buf, int shell_buf_offset) {
    
}

int skip_space(char *shell_buf, int shell_buf_offset) {
    int i = shell_buf_offset;
    while ((i < 256) && ((*(shell_buf + i)) == 32)) {
        i = i + 1;
    }
    return i;
}

void reset() {
    char *reset_start = 458752;
    for (int i = 0; i < 65536; i = i + 1) {
        *(reset_start + i) = 0;
    }
}

void shell() {
	char *dump_str = "dump";
    char *write_str = "write";
    char *run_str = "run";
    char *mount_str = "mount";
    char *dir_str = "dir";
    char *open_str = "open";
    char *close_str = "close";
    char *filerd_str = "filerd";
    char *filewr_str = "filewr";
    char *searchfile_str = "search";
    int mount_values = 0;

    char *output_str = "Typed string is: ";
    char *invalid_command_str = "Invalid command\n";
    char *cr_string = "\ncarriage return\n";
	char *shell_buf = 400000;
    char *cr = "\n";
    char space = 32;
    char bs = 8;

	int SHELL_BUF_SIZE = 256;

    int shell_buf_offset = 0;
	
    int do_loop = 1;
    reset_shell(shell_buf);
    while (do_loop == 1) {
        char temp = get_char();
        if (temp > 31) {
		    *(shell_buf + shell_buf_offset) = temp;
            print_char(temp);
            shell_buf_offset = shell_buf_offset + 1;
        }
        if (shell_buf_offset > 255) {
            shell_buf_offset = 0;
        }
        if (temp == 8) {
            if (shell_buf_offset > 0) {
                shell_buf_offset = shell_buf_offset - 1;
                *(shell_buf + shell_buf_offset) = 0;
                print_char(bs);
                print_char(space);
                print_char(bs);
            }
        }
        if (temp == 13) {
            int result = 0;
            int command_success = 0;
            shell_buf = 400000;
            
            printString(cr);
            if (shell_buf_offset > 0) {
                
                result = compare_string(shell_buf, dump_str);
                if (result == 1) {
                    shell_buf_offset = 4;
                    dump_command(shell_buf, shell_buf_offset);
                    command_success = 1;
                }
                result = compare_string(shell_buf, write_str);
                if (result == 1) {
                    shell_buf_offset = 5;
                    write_command(shell_buf, shell_buf_offset);
                    command_success = 1;
                }
                result = compare_string(shell_buf, run_str);
                if (result == 1) {
                    shell_buf_offset = 3;
                    run_command();
                    command_success = 1;
                }
                result = compare_string(shell_buf, mount_str);
                if (result == 1) {
                    shell_buf_offset = 3;
                    
                    mount_command();
                    command_success = 1;
                }
                result = compare_string(shell_buf, dir_str);
                if (result == 1) {
                    shell_buf_offset = 3;
                    dir_command();
                    command_success = 1;
                }
                result = compare_string(shell_buf, open_str);
                if (result == 1) {
                    shell_buf_offset = 4;
                    shell_buf_offset = skip_space(shell_buf, shell_buf_offset);
                    open_command(shell_buf, shell_buf_offset);
                    command_success = 1;
                }
                result = compare_string(shell_buf, close_str);
                if (result == 1) {
                    shell_buf_offset = 5;
                    shell_buf_offset = skip_space(shell_buf, shell_buf_offset);
                    close_command(shell_buf, shell_buf_offset);
                    command_success = 1;
                }
                result = compare_string(shell_buf, filerd_str);
                if (result == 1) {
                    shell_buf_offset = 6;
                    shell_buf_offset = skip_space(shell_buf, shell_buf_offset);
                    filerd_command(shell_buf, shell_buf_offset);
                    command_success = 1;
                }
                result = compare_string(shell_buf, filewr_str);
                if (result == 1) {
                    shell_buf_offset = 6;
                    shell_buf_offset = skip_space(shell_buf, shell_buf_offset);
                    filewr_command(shell_buf, shell_buf_offset);
                    command_success = 1;
                }
                result = compare_string(shell_buf, searchfile_str);
                if (result == 1) {
                    shell_buf_offset = 6;
                    shell_buf_offset = skip_space(shell_buf, shell_buf_offset);
                    searchfile_command(shell_buf, shell_buf_offset);
                    command_success = 1;
                }
                if (command_success == 0) {
                    printString(invalid_command_str);
                }
            }
            shell_buf_offset = 0;
            reset_shell(shell_buf);
        }
    }
    char *end = "end\n";
    printString(end);
}


void main() {
    asm("addi sys, r0, _system_call");
    char *x = "\nZaC-3 OS\n";
    printString(x);
    reset();
	shell();
}
