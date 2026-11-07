// Disk test for ZaC-3 emulator

// 0x0100 - 0x0200: Hard disk
// 0x0100 = Hard disk LBA address (32-bit but only low 24-bits used)
// 0x0104 = Hard disk 512-byte address pointer in memory
// 0x0108 = Start read 512 block command
// 0x010C = Start write 512 block command
// 0x0110 = Read 32-bit word from disk (128 32-bit words per seconds, or 512 bytes) (io_in)
// 0x0110 = Write 32-bit word to disk (128 32-bit words per seconds, or 512 bytes) (io_out)
// 0x0114 = Read status register

#include "stdio.h"

asm(".org 131072");

void diskRead(int *buffer, int LBA_address) {
    int *disk_io = 1245440;
    char *output_str = "DiskRead test\n";
    printString(output_str);
    //debug();
    *disk_io = LBA_address;
    *(disk_io + 2) = 1; // start read to disk
    for (int i = 0; i < 128; i = i + 1) {
        *(buffer + i) = *(disk_io + 4);
    }
}

void diskWrite(char *buffer, int LBA_address) {
    int *disk_io = 1245440;
    char *output_str = "DiskWrite test\n";
    printString(output_str);

    *disk_io = LBA_address;
    *(disk_io + 3) = 1; // start write to disk
    for (int i = 0; i < 128; i = i + 1) {
       *(disk_io + 4) = *(buffer + i);
    }
}


void main() {
    int *disk_io = 1245440;
    int *disk_test_buffer_int = 65536;
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

    print_bcd(FAT_start);
    cr();
    print_bcd(root_start);
    cr();
    print_bcd(data_start);
    cr();

    diskRead(disk_test_buffer_int, root_start);
    cr();
    for (int i = 0; i < 512; i = i + 32) {
        int dir_attrib = *(disk_test_buffer + i + 11);
        int first_dir_char = *(disk_test_buffer + i);
        if ((dir_attrib != 15) && (first_dir_char < 128) && (first_dir_char > 0)) {
            cr();
            for (int j = 0; j < 11; j = j + 1) {
                printChar(*(disk_test_buffer + i + j));
            }
        } 
    }

    cr();
    exit();

}
