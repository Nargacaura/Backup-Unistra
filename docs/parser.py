import os
import sys
import getopt
import re
from docstring_parser import parse
from enum import Enum

REF_TYPES = [
    "Action",
    "Board",
    "Bot",
    "Card",
    "Player_Base",
    "Player",
]

TABLE_TYPE = {
    "property": {
        "slug-plural": "properties",
        "sec-name": "Properties",
    },
    "constant": {
        "slug-plural": "constants",
        "sec-name": "Constants",
    },
    "enum": {
        "slug-plural": "enums",
        "sec-name": "Enumerations",
    },
    "method": {
        "slug-plural": "methods",
        "sec-name": "Methods",
    },
    "static_method": {
        "slug-plural": "static_methods",
        "sec-name": "Static Methods",
    },
    "signal": {
        "slug-plural": "signals",
        "sec-name": "Signals",
    },
}


def get_categorie(prev_line, line):
    line.strip()
    prev_line = prev_line.strip()
    if prev_line.startswith("var ") or line.split(":")[0].upper().startswith("PROPERTY"):
        return "properties"
    if prev_line.startswith("const ") or line.split(":")[0].upper().startswith("CONST"):
        return "constants"
    if prev_line.startswith("enum ") or line.split(":")[0].upper().startswith("ENUM"):
        return "enums"
    if prev_line.startswith("func ") or line.split(":")[0].upper().startswith("METHOD"):
        return "methods"
    if prev_line.startswith("static func ") or line.split(":")[0].upper().startswith("STATIC METHOD"):
        return "static_methods"
    if prev_line.startswith("signal ") or line.split(":")[0].upper().startswith("SIGNAL"):
        return "signals"
    return ""


def parse_one_line(line, prev_line, data):
    property_name = ""
    signal_name = ""
    type_name = ""
    default_value = ""
    docstring_to_parse = ""
    desc = line.strip()[3:-3].strip()
    if "SKIP_DOC" in desc:
        data["skip_file"] = True
        return data

    # Parse Inheritence
    if desc.upper().startswith("INHERITED BY"):
        classes_names = desc.split(":")[1]
        for class_name in classes_names.split(","):
            class_name = class_name.strip()
            data["inherited_by"].append(class_name)
        return data

    # Remove multiple consecutives spaces
    prev_line = re.sub(' +', ' ', prev_line)
    if get_categorie(prev_line, line) in ["properties", "constants"]:
        # Remove 'var '
        cp_prev_line = prev_line[4:]
        if get_categorie(prev_line, line) == "constants":
            cp_prev_line = prev_line[5:]
        # Parse property
        property_name = cp_prev_line.split(' ')[0].strip()
        if ':' in prev_line:
            # The property is typed
            property_name = cp_prev_line.split(':')[0].strip()
            cp_prev_line = cp_prev_line.split(':')[1].strip()
            type_name = cp_prev_line.split(' ')[0].strip()
            if '=' in prev_line:
                type_name = cp_prev_line.split('=')[0].strip()
                default_value = cp_prev_line.split('=')[1].strip()
        elif '=' in prev_line:
            # The property has default value
            default_value = cp_prev_line.split('=')[1].strip()
        docstring_to_parse = "{}\n\n{}\n\n:param {} {}: {}".format(
            desc, "Not used", type_name, property_name, default_value)
        data[get_categorie(prev_line, line)].append(parse(docstring_to_parse))
    elif get_categorie(prev_line, line) == "signals":
        # Remove 'signal '
        cp_prev_line = prev_line[7:]
        signal_name = cp_prev_line.split('(')[0].strip()
        if ' ' in signal_name:
            signal_name = cp_prev_line.split(' ')[0].strip()
        docstring_to_parse = "{}\n\n{}\n".format(signal_name, desc)
        if '(' in cp_prev_line and ')' in cp_prev_line:
            if '()' not in cp_prev_line:
                args = cp_prev_line.split('(')[1].strip().split(')')[0]
                for arg in args.split(','):
                    docstring_to_parse += "\n:param {}:".format(arg.strip())
        data["signals"].append(parse(docstring_to_parse))

    return data


def parse_file(filepath):
    data = {
        "skip_file": False,
        "class_name": "",
        "extends": "",
        "inherited_by": [],
        "properties": [],
        "constants": [],
        "enums": [],
        "methods": [],
        "static_methods": [],
        "signals": [],
    }
    prev_line = ""

    with open(filepath, 'r') as file:
        line = file.readline()
        while line:
            if data["skip_file"]:
                file.close()
                break
            # Remove
            striped_line = line.strip()
            # Add extends to data dictionary
            if striped_line.startswith("extends"):
                data["extends"] = re.sub(
                    ' +', ' ', striped_line).split(' ')[1]
            # Add class_name to data dictionary
            if striped_line.startswith("class_name"):
                data["class_name"] = re.sub(
                    ' +', ' ', striped_line).split(' ')[1]
            docstr = ""
            # If docstring comment
            if striped_line.startswith('"""'):
                # Its a one line comment
                if striped_line[3:].endswith('"""'):
                    data = parse_one_line(line, prev_line, data)
                else:
                    # Skip the line with '''
                    line = file.readline()
                    striped_line = line.strip()
                    categorie = get_categorie(prev_line, striped_line)
                    # Remove "Const: ", "Method: ", "Signal: ", etc in multiple lines docstring
                    if ":" in striped_line:
                        line = striped_line.split(":")[1].strip()
                    while not striped_line.startswith('"""'):
                        docstr += line
                        line = file.readline()
                        striped_line = line.strip()
                    data[categorie].append(parse(docstr))
            prev_line = line
            line = file.readline()
        file.close()

    return data


def get_class_type_ref(type_str, is_bold=False):
    return ":ref:`{}<class_{}>`".format(type_str, type_str) if type_str in REF_TYPES else ("**" + type_str + "**") if is_bold else type_str


def get_Clike_params(params, is_signal=False):
    params_str = ""
    i = 1
    for param in params:
        if is_signal:
            params_str += "{}".format(param.arg_name)
        else:
            params_str += "{} {}".format(
                get_class_type_ref(param.type_name, param.type_name not in REF_TYPES), param.arg_name)
        if i < len(params):
            params_str += ", "
        i += 1
    return params_str


def get_Clike_function_ref(method, is_signal=False):
    method_name = method.short_description
    if is_signal:
        methods_desc_str = "**{} (** ".format(method_name)
    else:
        methods_desc_str = "{} **{} (** ".format(
            get_class_type_ref(method.returns.type_name), method_name)

    methods_desc_str += get_Clike_params(method.params)

    methods_desc_str += " **)**"
    methods_desc_str = re.sub(' +', ' ', methods_desc_str)

    return methods_desc_str


def get_function_ref(docstring, class_str, func_type="method"):
    function_name = docstring.short_description.strip()
    function_str = ":ref:`{}<class_{}_{}_{}>` **(** ".format(
        function_name, class_str, func_type, function_name)

    function_str += get_Clike_params(docstring.params)

    function_str += " **)**"
    function_str = re.sub(' +', ' ', function_str)

    return function_str


def get_table_refs(docstring, class_name, table_type="property", is_bold=False):
    return_left_str = ""
    return_right_str = ""
    left_name = ""
    right_name = ""

    if table_type == "property" or table_type == "constant":
        left_name = docstring.params[0].type_name.strip()
        right_name = docstring.params[0].arg_name.strip()
        return_right_str = ":ref:`{}<class_{}_{}_{}>`".format(
            right_name, class_name, table_type, right_name)
    elif table_type == "method" or table_type == "static_method":
        left_name = docstring.returns.type_name.strip()
        return_right_str = get_function_ref(docstring, class_name, table_type)
    elif table_type == "signal":
        left_name = "signal"
        return_right_str = get_function_ref(docstring, class_name, table_type)
    elif table_type == "enum":
        left_name = "enum"
        right_name = docstring.short_description
        return_right_str = ":ref:`{}<class_{}_{}_{}>`".format(
            right_name, class_name, table_type, right_name)

    return_left_str = get_class_type_ref(left_name, is_bold=is_bold)
    return return_left_str, return_right_str


def make_params_description(params, title=""):
    doc_str = ""
    if params != []:
        doc_str += title
        for param in params:
            if param.description != "" or param.description != None:
                doc_str += "\n- {}**{}**: {}".format(
                    get_class_type_ref(param.type_name) + " " if param.type_name != None else "", param.arg_name, param.description)
        doc_str += "\n"
    return doc_str


def make_table(docstrings, class_name, table_type="property"):
    if docstrings == None or docstrings == []:
        return ""

    doc_str = "\n\n.. _class_{}_{}:".format(
        class_name, TABLE_TYPE[table_type]["slug-plural"])
    doc_str += "\n\n{}\n{}\n\n".format(
        TABLE_TYPE[table_type]["sec-name"], "-"*len(TABLE_TYPE[table_type]["sec-name"]))

    max_left_col_len = 0
    max_right_col_len = 0
    for docstring in docstrings:
        left_elem_str, right_elem_str = get_table_refs(
            docstring, class_name, table_type)
        if len(left_elem_str) > max_left_col_len:
            max_left_col_len = len(left_elem_str)
        if len(right_elem_str) > max_right_col_len:
            max_right_col_len = len(right_elem_str)

    doc_str += "+-{}-+-{}-+\n".format("-" *
                                      max_left_col_len, "-"*max_right_col_len)

    for docstring in docstrings:
        left_elem_str, right_elem_str = get_table_refs(
            docstring, class_name, table_type)
        doc_str += "| {:{left_width}} | {:{right_width}} |\n".format(
            left_elem_str, right_elem_str, left_width=max_left_col_len, right_width=max_right_col_len)
        doc_str += "+-{}-+-{}-+\n".format("-" *
                                          max_left_col_len, "-" * max_right_col_len)

    return doc_str


def make_description(docstrings, class_name, table_type="property"):
    if docstrings == None or docstrings == []:
        return ""

    doc_str = "\n\n.. _class_{}_{}_description:".format(
        class_name, TABLE_TYPE[table_type]["slug-plural"])
    doc_str += "\n\n{}\n{}\n".format(
        TABLE_TYPE[table_type]["sec-name"] + " Descriptions", "-"*len(TABLE_TYPE[table_type]["sec-name"] + " Descriptions"))

    i = 1
    for docstring in docstrings:
        if table_type in ["property", "constant"]:
            main_name = docstring.params[0].arg_name.strip()
            type_name = docstring.params[0].type_name.strip()
            doc_str += "\n.. _class_{}_{}_{}:\n\n".format(
                class_name, table_type, main_name)
            doc_str += "- {}{} **{}**\n\n".format(
                "const " if table_type == "constant" else "", get_class_type_ref(type_name), main_name)
            if docstring.long_description != "Not used":
                doc_str += docstring.long_description + "\n"
            else:
                doc_str += docstring.short_description + "\n"
        elif table_type in ["method", "static_method", "signal"]:
            doc_str += "\n.. _class_{}_{}_{}:\n\n".format(
                class_name, table_type, docstring.short_description.strip())
            doc_str += "- {}{}\n\n".format("static "if table_type == "static_method" else "",
                                           get_Clike_function_ref(docstring, table_type == "signal"))
            doc_str += "**Description:** {}\n".format(
                docstring.long_description)
            doc_str += make_params_description(docstring.params,
                                               title="\n\n**{} parameters:**\n\n".format("Signal" if table_type == "signal" else "Method"))
        elif table_type == "enum":
            doc_str += "\n.. _class_{}_{}_{}:\n\n".format(
                class_name, table_type, docstring.short_description.strip())
            doc_str += "enum **{}**:\n".format(
                docstring.short_description.strip())
            doc_str += "\n**Description:** {}\n".format(
                docstring.long_description)
            doc_str += make_params_description(docstring.params)

        if i < len(docstrings):
            doc_str += "\n----\n"
        i += 1

    return doc_str


def make_doc_file(filename):
    data = parse_file(filename)
    if data["skip_file"]:
        return ""
    # Base Link
    doc_str = ".. _class_{}:\n\n".format(data["class_name"])
    # Page Title
    doc_str += "{}\n{}\n".format(data["class_name"],
                                 "="*len(data["class_name"]))
    # Inherits
    if data["extends"] != "":
        doc_str += "\n**Inherits:** {}\n".format(
            get_class_type_ref(data["extends"]))
    if data["inherited_by"] != []:
        doc_str += "\n**Inherited By:** "
        i = 1
        for class_name in data["inherited_by"]:
            doc_str += get_class_type_ref(class_name)
            if i < len(data["inherited_by"]):
                doc_str += ", "
            i += 1
        doc_str += "\n"

    doc_str += make_table(data["constants"], data["class_name"], "constant")
    doc_str += make_table(data["properties"], data["class_name"], "property")
    doc_str += make_table(data["methods"], data["class_name"], "method")
    doc_str += make_table(data["static_methods"],
                          data["class_name"], "static_method")
    doc_str += make_table(data["signals"],
                          data["class_name"], "signal")
    doc_str += make_table(data["enums"],
                          data["class_name"], "enum")

    doc_str += make_description(data["constants"],
                                data["class_name"], "constant")
    doc_str += make_description(data["properties"],
                                data["class_name"], "property")
    doc_str += make_description(data["methods"], data["class_name"], "method")
    doc_str += make_description(data["static_methods"],
                                data["class_name"], "static_method")
    doc_str += make_description(data["signals"], data["class_name"], "signal")
    doc_str += make_description(data["enums"], data["class_name"], "enum")

    return doc_str


def generate_dir_doc(directory_path, doc_destination_dir, prefix_file="class_client_"):
    files = os.listdir(directory_path)
    if files == []:
        return

    for file_name in files:
        if file_name.endswith(".gd"):
            doc_filename = doc_destination_dir + \
                prefix_file + file_name[:-3].lower() + ".rst"
            file_to_parse = directory_path + file_name
            doc = make_doc_file(file_to_parse)
            if doc != "":
                with open(doc_filename, 'w') as file:
                    file.write(doc)
                    file.close()


def main(argv):
    input_dir = ''
    output_dir = ''
    try:
        opts, args = getopt.getopt(argv, "hi:o:", ["input_dir=", "onput_dir="])
    except getopt.GetoptError:
        print('parser.py -i <inputfile> -o <outputfile> <file_prefix>')
        sys.exit(1)
    for opt, arg in opts:
        if opt == '-h':
            print('parser.py -i <inputfile> -o <outputfile> <file_prefix>')
            sys.exit(2)
        elif opt in ("-i", "--input_dir"):
            input_dir = arg
        elif opt in ("-o", "--output_dir"):
            output_dir = arg
    if len(args) != 1:
        print('parser.py -i <inputfile> -o <outputfile> <file_prefix>')
        sys.exit(2)

    generate_dir_doc(input_dir, output_dir,
                     prefix_file=args[0])


if __name__ == "__main__":
    main(sys.argv[1:])
