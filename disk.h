void diskRead(int *buffer, int LBA_address) {
    int *disk_io = 1245440;
    char *output_str = "DiskRead test\n";
    //printString(output_str);
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
    //printString(output_str);

    *disk_io = LBA_address;
    *(disk_io + 3) = 1; // start write to disk
    for (int i = 0; i < 128; i = i + 1) {
       *(disk_io + 4) = *(buffer + i);
    }
}