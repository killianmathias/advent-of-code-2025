import re
from collections import deque

# Class that define a machine with arrival_state, start_state which is identical for all machines and a list of operations
class Machine:
    def __init__(self,arrival_state, operation_list ):
        self.arrival_state = tuple(arrival_state)
        self.operation_list = operation_list
        self.start_state = tuple([False]*len(arrival_state))

# Function that open a file and transform it into a list of Machine
def open_file(pathname):
    machine_list = []
    with open(pathname, "r") as file:
        lines = file.readlines()
    for line in lines:
        arrival_state = []
        arrival = re.search(r"\[([.#]+)\]", line).group(0).strip("[]")
        print(arrival)
        for i in range(0,len(arrival)):
            if arrival[i]== ".":
                arrival_state.append(False)
            else:
                arrival_state.append(True)
        operation_list = []
        operations = re.findall(r"\(([\d,]+)\)", line)

        for operation in operations:    
            indexes = [int(number) for number in operation.split(',')]
            operation_list.append(indexes)
        
        machine =  Machine(arrival_state, operation_list)
        machine_list.append(machine)
    return machine_list
    

# Function that calculate the minimum of operations to have the arrival state with BFS
def bfs(machine):
    q = deque()
    q.append((machine.start_state,0))

    visited = set()
    visited.add(machine.start_state)

    while q:
        state, number = q.popleft()

        if (state==machine.arrival_state):
            return number
        
        for operation in machine.operation_list:

            new_state = list(state)
            for index in operation:
                new_state[index] = not new_state[index]
            
            next_state = tuple(new_state)

            if next_state not in visited:
                visited.add(next_state)
                q.append((next_state,number+1))
    return -1

# Function that calculate the sum of all bfs' results
def calculate_sum(machine_list):
    sum = 0
    for machine in machine_list:
        sum+= bfs(machine)
    return sum

# Final result
machine_list = open_file("input.txt")
total = calculate_sum(machine_list)
print(f"Number of operation : {total}")
