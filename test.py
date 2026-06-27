import subprocess

pass_count = 0
units = 2

subprocess.run(["zcc.exe", "./unit_tests/io_test.c"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
expected_output_file = open("./unit_tests/io_test.asm")
expected_output = expected_output_file.read()

output_file = open("c_program.asm")
output_asm = output_file.read()

if output_asm == expected_output:
    print("PASS")
    pass_count += 1
else:
    print("FAIL")

subprocess.run(["zcc.exe", "./unit_tests/operator_test.c"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
expected_output_file = open("./unit_tests/operator_test.asm")

output_file = open("c_program.asm")
output_asm = output_file.read()
expected_output = expected_output_file.read()

if output_asm == expected_output:
    print("PASS")
    pass_count += 1
else:
    print("FAIL")

print("")
print("Units passed: " + str(pass_count) + " out of " + str(units))
if pass_count == units:
    print("Total: PASS")
else:
    print("Total: FAIL")
