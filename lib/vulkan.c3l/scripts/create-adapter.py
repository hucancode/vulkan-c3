import re

def parse_function_definitions(code):
    function_defs = {}
    function_ptrs = []

    lines = code.splitlines()
    for line in lines:
        line = line.strip()

        # Match function definitions
        match_def = re.match(r'def\s+(\w+)\s*=\s*fn\s+(\w+)\((.*?)\);', line)
        if match_def:
            name, return_type, params = match_def.groups()
            function_defs[name] = (return_type, params)
            continue

        # Match function pointers
        match_ptr = re.match(r'(\w+)\s+(\w+);', line)
        if match_ptr:
            type_name, var_name = match_ptr.groups()
            function_ptrs.append((type_name, var_name))

    return function_defs, function_ptrs

def is_array_return_function(params):
    if not params:
        return False, None, None

    param_list = [p.strip() for p in params.split(',')]
    if len(param_list) < 2:
        return False, None, None

    # Check last two parameters
    count_param = param_list[-2].split()
    array_param = param_list[-1].split()

    if len(count_param) != 2 or len(array_param) != 2:
        return False, None, None

    # Check parameter name patterns
    count_param_name = count_param[1]
    array_param_name = array_param[1]

    if not (count_param_name.startswith('p') and count_param_name.endswith('Count') and
            array_param_name.startswith('p') and array_param_name.endswith('s')):
        return False, None, None

    # Check if both are pointers
    if not count_param[0].endswith('*') or not array_param[0].endswith('*'):
        return False, None, None

    # Extract base types
    count_type = count_param[0][:-1]  # Remove *
    array_type = array_param[0][:-1]  # Remove *

    return True, count_type, array_type

def get_param_names(params):
    if not params:
        return []
    return [p.split()[-1] for p in params.split(',')]

def generate_adapters(function_defs, function_ptrs):
    output = []

    output.append("module vk;")
    output.append("import std::core::cinterop;")
    output.append("")

    for type_name, var_name in function_ptrs:
        if type_name not in function_defs:
            continue  # Skip if function definition is missing

        return_type, params = function_defs[type_name]
        is_array, count_type, array_type = is_array_return_function(params)

        if is_array:
            # Get base parameters (excluding count and array parameters)
            base_params_full = [p.strip() for p in params.split(',')[:-2]]
            base_params_def = ', '.join(base_params_full)
            base_param_names = get_param_names(base_params_def)
            base_param_names_str = ', '.join(base_param_names)

            # Determine if function returns Result
            returns_result = (return_type == "Result")
            array_return_type = f"{array_type}[]{'!' if returns_result else ''}"

            # Add function declaration
            output.append(f"fn {array_return_type} {var_name}({base_params_def}) {{")
            output.append(f"\t{count_type} n;")

            # Generate function calls with proper parameter handling
            call_params = [base_param_names_str] if base_param_names_str else []
            call_params.extend(['&n', 'null'])
            call_str = ', '.join(call_params)

            if returns_result:
                output.append(f"\tvk::check(internal::{var_name}({call_str}))!;")
            else:
                output.append(f"\tinternal::{var_name}({call_str});")

            output.append(f"\t{array_type}* ret = ({array_type}*) malloc(n * {array_type}.sizeof);")

            call_params = [base_param_names_str] if base_param_names_str else []
            call_params.extend(['&n', 'ret'])
            call_str = ', '.join(call_params)

            if returns_result:
                output.append(f"\tvk::check(internal::{var_name}({call_str}))!;")
            else:
                output.append(f"\tinternal::{var_name}({call_str});")

            output.append(f"\treturn ret[:n];")
        else:
            # Handle regular functions
            param_names = get_param_names(params)
            param_str = ', '.join(param_names)

            if return_type == "Result":
                output.append(f"fn void! {var_name}({params}) {{")
                output.append(f"\tvk::check(internal::{var_name}({param_str}))!;")
            elif return_type == "void":
                output.append(f"fn void {var_name}({params}) {{")
                output.append(f"\tinternal::{var_name}({param_str});")
            else:
                output.append(f"fn {return_type} {var_name}({params}) {{")
                output.append(f"\treturn internal::{var_name}({param_str});")

        output.append("}")
        output.append("")  # Blank line for readability

    return '\n'.join(output)

# Read from procedures.c3i
with open('../procedures.c3i', 'r', encoding='utf-8') as f:
    input_code = f.read()

function_defs, function_ptrs = parse_function_definitions(input_code)
output_code = generate_adapters(function_defs, function_ptrs)

# Write to public-procedures.c3i
with open('../public-procedures.c3', 'w', encoding='utf-8') as f:
    f.write(output_code)
