void main() {
    char *io = 1245184;
    for (int i = 0; i < 127; i = i + 1) {
        *io = i;
    }
}
