import re
from z3 import *

# Class that define a machine with arrival_joltage, start_joltage which is identical for all machines and a list of operations
class Machine:
    def __init__(self, arrival_joltage, operation_list):
        self.arrival_joltage = arrival_joltage
        self.operation_list = operation_list
        self.start_joltage = [0]*len(arrival_joltage)

# Function that open a file and transform it into a list of Machine
def open_file(pathname):
    machine_list = []
    with open(pathname, "r") as file:
        lines = file.readlines()
        
    for line in lines:
        if not line.strip():
            continue

        match = re.search(r"\{([\d,]+)\}", line)
        if not match:
            continue
        arrival_joltage = [int(x) for x in match.group(1).split(',')]

        operation_list = []
        operations = re.findall(r"\(([\d,]+)\)", line)

        for operation in operations:    
            indexes = [int(number) for number in operation.split(',')]
            operation_list.append(indexes)
        
        machine = Machine(arrival_joltage, operation_list)
        machine_list.append(machine)
    return machine_list


# Function that calculate the minimum of operations to have the arrival joltage using equations with Z3
def calculate_machine(machine):
    optimizer = Optimize()

    number_of_operation = len(machine.operation_list)

    operation_presses = [
        Int(f'button_{index}')
        for index in range(number_of_operation)
    ]

    for operation in operation_presses:
        optimizer.add(operation >= 0)

    for index, value in enumerate(machine.arrival_joltage):
        total = 0

        for operation_index, operation in enumerate(machine.operation_list):
            if index in operation:
                total += operation_presses[operation_index]

        optimizer.add(total == value)

    optimizer.minimize(Sum(operation_presses))

    if optimizer.check() == sat:
        solution = optimizer.model()
        return sum(solution[press].as_long() for press in operation_presses)

# Function that calculate the sum of all equations results
def calculate_sum(machine_list):
    total = 0
    for machine in machine_list:
        total += calculate_machine(machine)
    return total

# Final result
machine_list = open_file("input.txt")
print(f"Total: {calculate_sum(machine_list)}")