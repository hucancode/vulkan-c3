import re
import urllib.request as req
from tokenize import tokenize
from io import BytesIO
import os.path
import math

vulkan_include_root = "https://raw.githubusercontent.com/KhronosGroup/Vulkan-Headers/main/include/"
file_and_urls = [
    ("vk_platform.h",    'vulkan/vk_platform.h',    True),
    ("vulkan_core.h",    'vulkan/vulkan_core.h',    False),
    ("vk_layer.h",       'vulkan/vk_layer.h',       True),
    ("vk_icd.h",         'vulkan/vk_icd.h',         True),
    ("vulkan_win32.h",   'vulkan/vulkan_win32.h',   False),
    ("vulkan_metal.h",   'vulkan/vulkan_metal.h',   False),
    ("vulkan_macos.h",   'vulkan/vulkan_macos.h',   False),
    ("vulkan_ios.h",     'vulkan/vulkan_ios.h',     False),
    ("vulkan_wayland.h", 'vulkan/vulkan_wayland.h', False),
    ("vulkan_xlib.h",    'vulkan/vulkan_xlib.h',    False),
    ("vulkan_xcb.h",     'vulkan/vulkan_xcb.h',     False),
    # Vulkan Video
    ("vulkan_video_codec_av1std.h",         'vk_video/vulkan_video_codec_av1std.h', False),
    ("vulkan_video_codec_av1std_decode.h",  'vk_video/vulkan_video_codec_av1std_decode.h', False),
    ("vulkan_video_codec_av1std_encode.h",  'vk_video/vulkan_video_codec_av1std_encode.h', False),
    ("vulkan_video_codec_h264std.h",        'vk_video/vulkan_video_codec_h264std.h', False),
    ("vulkan_video_codec_h264std_decode.h", 'vk_video/vulkan_video_codec_h264std_decode.h', False),
    ("vulkan_video_codec_h264std_encode.h", 'vk_video/vulkan_video_codec_h264std_encode.h', False),
    ("vulkan_video_codec_h265std.h",        'vk_video/vulkan_video_codec_h265std.h', False),
    ("vulkan_video_codec_h265std_decode.h", 'vk_video/vulkan_video_codec_h265std_decode.h', False),
    ("vulkan_video_codec_h265std_encode.h", 'vk_video/vulkan_video_codec_h265std_encode.h', False),
]

for file, url, _ in file_and_urls:
    if not os.path.isfile(file):
        with open(file, 'w', encoding='utf-8') as f:
            f.write(req.urlopen(vulkan_include_root+ url).read().decode('utf-8'))

src = ""
for file, _, skip in file_and_urls:
    if skip: continue
    with open(file, 'r', encoding='utf-8') as f:
        src += f.read()


def no_vk(t):
    t = t.replace('PFN_vk_icd', 'Procicd')
    t = t.replace('PFN_vk', 'Proc')
    t = t.replace('PFN_', 'Proc')
    t = t.replace('PFN_', 'Proc')

    t = re.sub('(?:Vk|VK_)?(\\w+)', '\\1', t)

    # Vulkan Video
    t = re.sub('(?:Std|STD_|VK_STD)?(\\w+)', '\\1', t)
    return t

OPAQUE_STRUCTS = """
distinct WLSurface = any;// @extern("wl_surface"); // Opaque struct defined by Wayland
distinct WLDisplay = any;// @extern("wl_display"); // Opaque struct defined by Wayland
distinct XCBConnection = any;// @extern("xcb_connection_t"); // Opaque struct defined by xcb
distinct IOSurfaceRef = any; // Opaque struct defined by Apple’s CoreGraphics framework

"""

def convert_type(t):
    table = {
        "Bool32":      'uint',
        "float":       'float',
        "double":      'double',
        "size_t":      'usz',
        'int8_t':     'ichar',
        'int16_t':     'short',
        'int32_t':     'int',
        'int64_t':     'long',
        'int':         'CInt',
        'uint8_t':     'char',
        "uint16_t":    'ushort',
        "uint32_t":    'uint',
        "uint64_t":    'ulong',
        "char":        "ichar",
        "void":        "void",
        "void*":       "any",
        "void *":      "any",
        "char*":       'ZString',
        'uint8_t*':     'ZString',
        "uint32_t* const*": "uint*[]",
        "char* const*": 'ZString*',
        "ObjectTableEntryNVX* const*": "ObjectTableEntryNVX**",
        "void* const *": "any*",
        "AccelerationStructureGeometryKHR* const*": "AccelerationStructureGeometryKHR**",
        "AccelerationStructureBuildRangeInfoKHR* const*": "AccelerationStructureBuildRangeInfoKHR**",
        "MicromapUsageEXT* const*": "MicromapUsageEXT*[]",
        "struct BaseOutStructure": "BaseOutStructure",
        "struct BaseInStructure":  "BaseInStructure",
        "struct wl_display": "WLDisplay",
        "struct wl_surface": "WLSurface",
        "Display": "XlibDisplay",
        "Window": "XlibWindow",
        "VisualID": "XlibVisualID",
        "xcb_visualid_t": "XCBVisualID",
        "xcb_connection_t": "XCBConnection",
        "xcb_window_t": "XCBWindow",
        "HANDLE": "Win32_HANDLE",
        "HINSTANCE": "Win32_HINSTANCE",
        "HWND": "Win32_HWND",
        "HMONITOR": "Win32_HMONITOR",
        "DWORD": "Win32_DWORD",
        "LPCWSTR": "Win32_LPCWSTR",
        "SECURITY_ATTRIBUTES": "Win32_SECURITY_ATTRIBUTES",
        "LPCSTR": "Win32_LPCSTR",
        'v': '',
    }
    if t in table.keys():
        return table[t]
    elif t.startswith("const"):
        return convert_type(t[6:])
    elif t.endswith("*"):
        return convert_type(t[:-1]) + "*"
    return t

def parse_array(n, t):
    name, length = n.split('[', 1)
    length = no_vk(length[:-1])
    type_ = "{}[{}]".format(do_type(t), length)
    return name, type_

def remove_prefix(text, prefix):
    if text.startswith(prefix):
        return text[len(prefix):]
    return text
def extract_proc_name_camel(text):
    if text.startswith("Proc"):
        return text[4].lower() + text[5:]
    return text
def remove_suffix(text, suffix):
    if text.endswith(suffix):
        return text[:-len(suffix)]
    return text

def flatten_array(arr):
    value_map = {name: value for name, value in arr}
    def resolve_value(value):
        if not is_int(value) and value in value_map:
            return resolve_value(value_map[value])
        return value
    return [(name, resolve_value(value)) for name, value in arr]

def to_snake_case(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

ext_suffixes = ["KHR", "EXT", "AMD", "NV", "NVX", "GOOGLE", "KHX"]
ext_suffixes_title = [ext.title() for ext in ext_suffixes]


def fix_arg(arg):
    name = arg

    # Remove useless pointer identifier in field name
    for p in ('s_', 'p_', 'pp_', 'pfn_'):
        if name.startswith(p):
            name = name[len(p)::]
    if name in ('module', 'any'):
        name += '_'
    name = name.replace("__", "_")
    return name


def fix_ext_suffix(name):
    for ext in ext_suffixes_title:
        if name.endswith(ext):
            start = name[:-len(ext)]
            end = name[-len(ext):].upper()
            return start+end
    return name

def to_int(x):
    if x.startswith('0x'):
        return int(x, 16)
    return int(x)

def is_int(x):
    try:
        int(x)
        return True
    except ValueError:
        return False

def fix_enum_arg(name, is_flag_bit=False):
    # name = name.title()
    name = fix_ext_suffix(name)
    if len(name) > 0 and name[0].isdigit() and not name.startswith("0x") and not is_int(name):
        if name[1] == "D":
            name = name[1] + name[0] + (name[2:] if len(name) > 2 else "")
        else:
            name = "_"+name
    if is_flag_bit:
        name = name.replace("_BIT", "")
    if name in ('module', 'any', "MODULE", "ANY"):
        name += "_"
    return name

def do_type(t):
    return convert_type(no_vk(t)).replace("FlagBits", "Flags")

def parse_handles_def(f):
    f.write("// Handles types\n")
    handles = [h for h in re.findall(r"VK_DEFINE_HANDLE\(Vk(\w+)\)", src, re.S)]

    max_len = max(len(h) for h in handles)
    for h in handles:
        f.write("distinct {} = Handle;\n".format(h.ljust(max_len)))

    handles_non_dispatchable = [h for h in re.findall(r"VK_DEFINE_NON_DISPATCHABLE_HANDLE\(Vk(\w+)\)", src, re.S)]
    max_len = max(len(h) for h in handles_non_dispatchable)
    for h in handles_non_dispatchable:
        f.write("distinct {} = NonDispatchableHandle;\n".format(h.ljust(max_len)))


flags_defs = set()

def parse_flags_def(f):
    names = [n for n in re.findall(r"typedef VkFlags Vk(\w+?);", src)]

    global flags_defs
    flags_defs = set(names)


class FlagError(ValueError):
    pass
class IgnoreFlagError(ValueError):
    pass

def fix_enum_name(name, prefix, suffix, is_flag_bit):
    name = remove_prefix(name, prefix)
    if suffix:
        name = remove_suffix(name, suffix)
    if name.startswith("0x"):
        if is_flag_bit:
            i = int(name, 16)
            if i == 0:
                raise IgnoreFlagError(i)
            v = int(math.log2(i))
            if 2**v != i:
                raise FlagError(i)
            return str(v)
        return name
    elif is_flag_bit:
        ignore = False
        try:
            if int(name) == 0:
                ignore = True
        except:
            pass
        if ignore:
            raise IgnoreFlagError()
    elif name.startswith("_"):
        name = "X"+name

    return fix_enum_arg(name, is_flag_bit)


def fix_enum_value(value, prefix, suffix, is_flag_bit):
    v = no_vk(value)
    g = tokenize(BytesIO(v.encode('utf-8')).readline)
    tokens = [val for _, val, _, _, _ in g]
    assert len(tokens) > 2
    token = ''.join([t for t in tokens[1:-1] if t])
    token = fix_enum_name(token, prefix, suffix, is_flag_bit)
    return token

def parse_constants(f):
    f.write("// General Constants\n")
    all_data = re.findall(r"#define VK_(\w+)\s*(.*?)U?\n", src, re.S)
    allowed_names = (
        "HEADER_VERSION",
        "MAX_DRIVER_NAME_SIZE",
        "MAX_DRIVER_INFO_SIZE",
    )
    allowed_data = [nv for nv in all_data if nv[0] in allowed_names]
    max_len = max(len(name) for name, value in allowed_data)
    for name, value in allowed_data:
        f.write("const {} = {};\n".format(name.upper().rjust(max_len), value))

    f.write("\n// Vulkan Video Constants\n")
    vulkan_video_data = re.findall(r"#define STD_(\w+)\s*(.*?)U?\n", src, re.S)
    max_len = max(len(name) for name, value in vulkan_video_data)
    for name, value in vulkan_video_data:
        f.write("const {}{} = {};\n".format(name.upper(), "".rjust(max_len-len(name)), value))

    f.write("\n// Vulkan Video Codec Constants\n")
    vulkan_video_codec_allowed_suffixes = (
        "_EXTENSION_NAME",
    )
    vulkan_video_codec_data = re.findall(r"#define VK_STD_(\w+)\s*(.*?)U?\n", src, re.S)
    vulkan_video_codec_allowed_data = [nv for nv in vulkan_video_codec_data if nv[0].endswith(vulkan_video_codec_allowed_suffixes)]
    max_len = max(len(name) for name, value in vulkan_video_codec_allowed_data)
    for name, value in vulkan_video_codec_allowed_data:
        f.write("const {}{} = {};\n".format(name.upper(), "".rjust(max_len-len(name)), value))

    f.write("\n// Vendor Constants\n")
    fixes = '|'.join(ext_suffixes)
    inner = r"((?:(?:" + fixes + r")\w+)|(?:\w+" + fixes + r"))"
    pattern = r"#define\s+VK_" + inner + r"\s*(.*?)\n"
    data = re.findall(pattern, src, re.S)

    number_suffix_re = re.compile(r"(\d+)[UuLlFf]")

    max_len = max(len(name) for name, value in data)
    for name, value in data:
        value = remove_prefix(value, 'VK_')
        v = number_suffix_re.findall(value)
        if v:
            value = v[0]
        f.write("const {} = {};\n".format(name.upper().ljust(max_len), value))
    f.write("\n")


def parse_enums(f):
    f.write("import std::core::cinterop;\nimport std::collections::bitset;\n\n")
    f.write("// Enums\n")

    data = re.findall(r"typedef enum (\w+) {(.+?)} \w+;", src, re.S)
    data = [(no_vk(n), f) for n, f in data]

    data.sort(key=lambda x: x[0])

    generated_flags = set()

    for name, fields in data:
        enum_name = name

        is_flag_bit = False
        if "FlagBits" in enum_name:
            is_flag_bit = True
            enum_name = enum_name.replace("FlagBits", "Flags")
            generated_flags.add(enum_name)


        if is_flag_bit:
            f.write("bitstruct {} : Flags @overlap {{\n".format(enum_name))
        else:
            f.write("distinct {} = CInt;\n".format(name))

        prefix = to_snake_case(name).upper()
        suffix = None
        for ext in ext_suffixes:
            prefix_new = remove_suffix(prefix, "_"+ext)
            assert suffix is None
            if prefix_new != prefix:
                suffix = "_"+ext
                prefix = prefix_new
                break


        prefix = prefix.replace("_FLAG_BITS", "")
        prefix += "_"

        ff = []

        names_and_values = re.findall(r"VK_(\w+?) = (.*?)(?:,|})", fields, re.S)

        groups = []
        flags = {}

        for name, value in names_and_values:
            if is_flag_bit:
                n = fix_enum_name(name, prefix, suffix, is_flag_bit)
            else:
                n = name
            try:
                if is_flag_bit:
                    v = fix_enum_value(value, prefix, suffix, is_flag_bit)
                else:
                    v = no_vk(value)
            except FlagError as e:
                v = int(str(e))
                groups.append((n, v))
                continue
            except IgnoreFlagError as e:
                groups.append((n, 0))
                continue

            if n == v:
                continue
            try:
                flags[int(v)] = n
            except ValueError as e:
                pass

            if v == "NONE":
                continue

            if n.startswith("_"):
                n = "N"+n
            if v.startswith("_"):
                v = "N"+v
            ff.append((n.upper(), v.upper()))

        if is_flag_bit:
            ff = flatten_array(ff)

        max_flag_value = max([int(v) for n, v in ff if is_int(v)] + [0])
        max_group_value = max([int(v) for n, v in groups if is_int(v)] + [0])
        if max_flag_value < max_group_value:
            if (1<<max_flag_value)+1 < max_group_value:
                ff.append(('_MAX', 31))
                flags[31] = '_MAX'
                pass

        max_len = max([len(n) for n, v in ff] + [0])

        flag_names = set([n for n, v in ff])

        for n, v in ff:
            if is_flag_bit and not is_int(v) and v not in flag_names:
                print("Ignoring", n, "=", v)
                continue
            if is_flag_bit:
                f.write("\tbool {} : {};".format(n.ljust(max_len).lower(), v))
            else:
                f.write("const {} {} = {};".format(enum_name, n.ljust(max_len), v))
            if n == "_MAX":
                f.write(" // Needed for the *_ALL bit set")
            f.write("\n")

        if is_flag_bit:
            f.write("}\n\n")
        else:
            f.write("\n")

        for n, v in groups:
            used_flags = []
            for i in range(0, 32):
                if 1<<i & v != 0:
                    if i in flags:
                        used_flags.append('.'+flags[i])
                    else:
                        used_flags.append('{}({})'.format(enum_name, i))
            # Make sure the 's' is after Flags and not the extension name.
            ext_suffix = ''
            for suffix in ext_suffixes:
                if not enum_name.endswith(suffix):
                    continue

                ext_suffix = suffix
                enum_name = remove_suffix(enum_name, ext_suffix)
                break
            s = "const {enum_name}s{ext_suffix}_{n} = {enum_name}s{ext_suffix}{{".format(enum_name=enum_name, ext_suffix=ext_suffix, n=n)
            s += ', '.join(used_flags)
            s += "};\n"
            print("Ignoring", s)
            # f.write(s)

        if len(groups) > 0:
            f.write("\n\n")


    unused_flags = [flag for flag in flags_defs if flag not in generated_flags]
    unused_flags.sort()

    max_len = max(len(flag) for flag in unused_flags)
    for flag in unused_flags:
        f.write("bitstruct {} : uint {{}}\n".format(flag.ljust(max_len)))

def parse_fake_enums(f):
    data = re.findall(r"static const Vk(\w+FlagBits2) VK_(\w+?) = (\w+);", src, re.S)

    data.sort(key=lambda x: x[0])

    fake_enums = {}

    for type_name, name, value in data:
        if type_name in fake_enums:
            fake_enums[type_name].append((name,value))
        else:
            fake_enums[type_name] = [(name, value)]

    for name in fake_enums.keys():
        flags_name = name.replace("FlagBits", "Flags")
        f.write("bitstruct {} : Flags64 @overlap {{\n".format(flags_name))

        prefix = to_snake_case(name).upper()
        suffix = None
        for ext in ext_suffixes:
            prefix_new = remove_suffix(prefix, "_"+ext)
            assert suffix is None
            if prefix_new != prefix:
                suffix = "_"+ext
                prefix = prefix_new
                break


        prefix = prefix.replace("_FLAG_BITS2", "_2")
        prefix += "_"

        ff = []

        groups = []
        flags = {}

        names_and_values = fake_enums[name]

        for name, value in names_and_values:
            value = value.replace("ULL", "")
            n = fix_enum_name(name, prefix, suffix, True)
            try:
                v = fix_enum_value(value, prefix, suffix, True)
            except FlagError as e:
                v = int(str(e))
                groups.append((n, v))
                continue
            except IgnoreFlagError as e:
                groups.append((n, 0))
                continue

            if n == v:
                continue
            try:
                flags[int(v)] = n
            except ValueError as e:
                pass

            if v == "NONE":
                continue

            ff.append((n.upper(), v))

        max_flag_value = max([int(v) for n, v in ff if is_int(v)] + [0])
        max_group_value = max([int(v) for n, v in groups if is_int(v)] + [0])
        if max_flag_value < max_group_value:
            if (1<<max_flag_value)+1 < max_group_value:
                ff.append(('_MAX', 31))
                flags[31] = '_MAX'
                pass

        max_len = max([len(n) for n, v in ff] + [0])

        flag_names = set([n for n, v in ff])

        ff = flatten_array(ff)

        for n, v in ff:
            if not is_int(v) and v not in flag_names:
                print("Ignoring", n, "=", v)
                continue
            f.write("\tbool {} : {};".format(n.ljust(max_len).lower(), v))
            if n == "_MAX":
                f.write(" // Needed for the *_ALL bit set")
            f.write("\n")

        f.write("}\n\n")

def parse_structs(f):
    data = re.findall(r"typedef (struct|union) Vk(\w+?) {(.+?)} \w+?;", src, re.S)
    data += re.findall(r"typedef (struct|union) Std(\w+?) {(.+?)} \w+?;", src, re.S)

    for _type, name, fields in data:
        fields = re.findall(r"\s+(.+?)[\s:]+([_a-zA-Z0-9[\]]+);", fields)
        f.write(f"{_type} {name} {{\n")
        ffields = []
        for type_, fname in fields:
            # If the field name only has a number in it, then it is a C bit field.
            if is_int(fname):
                comment = None
                bit_field = type_.split(' ')
                # Get rid of empty spaces
                bit_field = list(filter(bool, bit_field))
                # [type, fieldname]
                assert len(bit_field) == 2, "Failed to parse the bit field!"
                bit_field_type = do_type(bit_field[0])
                bit_field_name = bit_field[1]
                comment = " // TODO: Make this field {} bit width".format(fname)
                ffields.append(tuple([bit_field_name, bit_field_type, comment]))
                continue

            if '[' in fname:
                fname, type_ = parse_array(fname, type_)
            comment = None
            n = fix_arg(fname)
            if "Flag_Bits" in type_:
                continue
            t = do_type(type_)
            ffields.append(tuple([n, t, comment]))

        max_len = max([len(t) for _, t, _ in ffields], default=0)
        max_len_name = max([len(n) for n, _, _ in ffields], default=0)

        for name, type, comment in ffields:
            name = name[0].lower() + name[1:]
            if name == "module":
                name += "_"
            f.write("\t{} {}; {}\n".format(type.ljust(max_len), name.ljust(max_len_name), comment or ""))
        f.write("}\n\n")

    f.write("// Opaque structs\n")
    f.write(OPAQUE_STRUCTS)

    f.write("// Aliases\n")
    data = re.findall(r"typedef Vk(\w+?) Vk(\w+?);", src, re.S)
    aliases = []
    for _type, name in data:
        if _type == "Flags":
            continue
        if "FlagBits" in _type:
            continue
        if name.endswith("Flag2") or name.endswith("Flags2"):
            continue
        name = name.replace("FlagBits", "Flag")
        aliases.append((name, _type))

    max_len = max([len(n) for n, _ in aliases] + [0])
    for n, t in aliases:
        k = max_len
        f.write("def {} = {};\n".format(n.ljust(k), t))



procedure_map = {}

def parse_procedures(f):
    data = re.findall(r"typedef (\w+\*?) \(\w+ \*(\w+)\)\((.+?)\);", src, re.S)

    group_ff = {"Loader":[], "Misc":[], "Instance":[], "Device":[]}

    for rt, name, fields in data:
        proc_name = no_vk(name)
        pf = []
        prev_name = ""
        for type_, fname, array_len in re.findall(r"(?:\s*|)(.+?)\s*(\w+)(?:\[(\d+)\])?(?:,|$)", fields):
            curr_name = fix_arg(fname)
            ty = do_type(type_)
            if array_len != "":
                ty = f"{ty}*[{array_len}]"
            pf.append((ty, curr_name))
            prev_name = curr_name

        data_fields = ', '.join(["{} {}".format(t, n) for t, n in pf if t != ""])

        params = "({})".format(data_fields)
        rt_str = do_type(rt)
        procedure_map[proc_name] = (rt_str, params)

        fields_types_name = [do_type(t) for t in re.findall(r"(?:\s*|)(.+?)\s*\w+(?:,|$)", fields)]
        table_name = fields_types_name[0]
        nn = (name, proc_name, rt_str, params)
        if table_name in ('Device', 'Queue', 'CommandBuffer') and proc_name != 'GetDeviceProcAddr':
            group_ff["Device"].append(nn)
        elif table_name in ('Instance', 'PhysicalDevice') or proc_name == 'GetDeviceProcAddr':
            group_ff["Instance"].append(nn)
        elif table_name in ('rawptr', '', 'DebugReportFlagsEXT') or proc_name == 'GetInstanceProcAddr':
            group_ff["Misc"].append(nn)
        else:
            group_ff["Loader"].append(nn)


    f.write("import std::core::cinterop;\n\n")
    for group_name, ff in group_ff.items():
        ff.sort()
        f.write("// {} Procedure Types\n".format(group_name))
        max_len = max(len(n) for n in ff)
        for (cname, proc_name, rt, params) in ff:
            f.write("def {} = fn {}{};\n".format(proc_name.ljust(max_len), rt, params))
        f.write("\n")

group_map = {"Loader":[], "Instance":[], "Device":[]}

def group_functions():
    data = re.findall(r"typedef (\w+\*?) \(\w+ \*(\w+)\)\((.+?)\);", src, re.S)

    for rt, vkname, fields in data:
        fields_types_name = [do_type(t) for t in re.findall(r"(?:\s*|)(.+?)\s*\w+(?:,|$)", fields)]
        table_name = fields_types_name[0]
        name = no_vk(vkname)

        nn = (fix_arg(name), fix_ext_suffix(name))

        if table_name in ('Device', 'Queue', 'CommandBuffer') and name != 'GetDeviceProcAddr':
            group_map["Device"].append(nn)
        elif table_name in ('Instance', 'PhysicalDevice') and name != 'ProcGetInstanceProcAddr' or name == 'GetDeviceProcAddr':
            group_map["Instance"].append(nn)
        elif table_name in ('rawptr', '', 'DebugReportFlagsEXT') or name == 'GetInstanceProcAddr':
            # Skip the allocation function and the dll entry point
            pass
        else:
            group_map["Loader"].append(nn)
    for _, group in group_map.items():
        group.sort()

def make_function_declarations(f):
    for group_name, group_lines in group_map.items():
        f.write("// {} Procedures\n".format(group_name))
        max_len = max(len(name) for name, _ in group_lines)
        for type, vk_name in group_lines:
            name = extract_proc_name_camel(type)
            f.write('{} {};\n'.format(type.ljust(max_len), name))
        f.write("\n")

def make_proc_loader(f):
    f.write("fn void loadProcAddressesCustom(SetProcAddressFnType setProcAddr) {\n")
    for group_name, group_lines in group_map.items():
        f.write("\t// {} Procedures\n".format(group_name))
        max_len = max(len(name) for name, _ in group_lines)
        for name, vk_name in group_lines:
            k = max_len - len(name)
            f.write('\tsetProcAddr(&{}, {}"vk{}");\n'.format(
                extract_proc_name_camel(name),
                "".ljust(k),
                remove_prefix(vk_name, 'Proc'),
            ))
        f.write("\n")
    f.write("}\n\n")

    f.write("fn void loadProcAddressesDevice(Device device) {\n")
    max_len = max(len(name) for name, _ in group_map["Device"])
    for name, vk_name in group_map["Device"]:
        f.write('\t{} = ({}) getDeviceProcAddr(device, "vk{}");\n'.format(
            extract_proc_name_camel(name).ljust(max_len),
            name,
            remove_prefix(vk_name, 'Proc'),
        ))
    f.write("}\n\n")

    f.write("fn void loadProcAddressesInstance(Instance instance) {\n")
    max_len = max(len(name) for name, _ in group_map["Instance"])
    for name, vk_name in group_map["Instance"]:
        f.write('\t{} = ({}) getInstanceProcAddr(instance, "vk{}");\n'.format(
            extract_proc_name_camel(name).ljust(max_len),
            name,
            remove_prefix(vk_name, 'Proc'),
        ))
    f.write("\n\t// Device Procedures (may call into dispatch)\n")
    max_len = max(len(name) for name, _ in group_map["Device"])
    for name, vk_name in group_map["Device"]:
        k = max_len - len(name)
        f.write('\t{} = ({}) getInstanceProcAddr(instance, "vk{}");\n'.format(
            extract_proc_name_camel(name).ljust(max_len),
            name,
            remove_prefix(vk_name, 'Proc'),
        ))
    f.write("}\n\n")

    f.write("fn void loadProcAddressesGlobal(void* vkGetInstanceProcAddr) {\n")
    f.write("\tgetInstanceProcAddr = vkGetInstanceProcAddr;\n\n")
    max_len = max(len(name) for name, _ in group_map["Loader"])
    for name, vk_name in group_map["Loader"]:
        k = max_len - len(name)
        f.write('\t{} = ({}) getInstanceProcAddr(null, "vk{}");\n'.format(
            extract_proc_name_camel(name).ljust(max_len),
            name,
            remove_prefix(vk_name, 'Proc'),
        ))
    f.write("}\n\n")

BASE = """
//
// Vulkan wrapper generated from "https://raw.githubusercontent.com/KhronosGroup/Vulkan-Headers/master/include/vulkan/vulkan_core.h"
//
module vk;
"""[1::]


with open("../core.c3i", 'w', encoding='utf-8') as f:
    f.write(BASE)
    f.write("""
// Core API
macro int @make_version($major, $minor, $patch) {
\treturn (($major << 22U) | ($minor << 12U) | $patch);
}
const API_VERSION_1_0 = @make_version(1, 0, 0);
const API_VERSION_1_1 = @make_version(1, 1, 0);
const API_VERSION_1_2 = @make_version(1, 2, 0);
const API_VERSION_1_3 = @make_version(1, 3, 0);
const API_VERSION_1_4 = @make_version(1, 4, 0);

// Base types
def Flags         = uint;
def Flags64       = ulong;
distinct DeviceSize    = ulong;
distinct DeviceAddress = ulong;
distinct SampleMask    = uint;

distinct Handle                 = any;
distinct NonDispatchableHandle  = ulong;

def SetProcAddressFnType = fn void(any, ZString);

distinct RemoteAddressNV = any; // Declared inline before MemoryGetRemoteAddressInfoNV

// Base constants
const LOD_CLAMP_NONE                        = 1000.0;
const REMAINING_MIP_LEVELS                  = ~(uint)0;
const REMAINING_ARRAY_LAYERS                = ~(uint)0;
const WHOLE_SIZE                            = ~(ulong)0;
const ATTACHMENT_UNUSED                     = ~(uint)0;
const TRUE                                  = 1;
const FALSE                                 = 0;
const QUEUE_FAMILY_IGNORED                  = ~(uint)0;
const SUBPASS_EXTERNAL                      = ~(uint)0;
const MAX_PHYSICAL_DEVICE_NAME_SIZE         = 256;
const MAX_SHADER_MODULE_IDENTIFIER_SIZE_EXT = 32;
const UUID_SIZE                             = 16;
const MAX_MEMORY_TYPES                      = 32;
const MAX_MEMORY_HEAPS                      = 16;
const MAX_EXTENSION_NAME_SIZE               = 256;
const MAX_DESCRIPTION_SIZE                  = 256;
const MAX_DEVICE_GROUP_SIZE                 = 32;
const LUID_SIZE_KHX                         = 8;
const LUID_SIZE                             = 8;
const MAX_QUEUE_FAMILY_EXTERNAL             = ~(uint)1;
const MAX_GLOBAL_PRIORITY_SIZE              = 16;
const MAX_GLOBAL_PRIORITY_SIZE_EXT          = MAX_GLOBAL_PRIORITY_SIZE;
const QUEUE_FAMILY_EXTERNAL                 = MAX_QUEUE_FAMILY_EXTERNAL;

// Vulkan Video API Constants
const VULKAN_VIDEO_CODEC_AV1_DECODE_API_VERSION_1_0_0  = @make_version(1, 0, 0);
const VULKAN_VIDEO_CODEC_AV1_ENCODE_API_VERSION_1_0_0  = @make_version(1, 0, 0);
const VULKAN_VIDEO_CODEC_H264_ENCODE_API_VERSION_1_0_0 = @make_version(1, 0, 0);
const VULKAN_VIDEO_CODEC_H264_DECODE_API_VERSION_1_0_0 = @make_version(1, 0, 0);
const VULKAN_VIDEO_CODEC_H265_DECODE_API_VERSION_1_0_0 = @make_version(1, 0, 0);
const VULKAN_VIDEO_CODEC_H265_ENCODE_API_VERSION_1_0_0 = @make_version(1, 0, 0);

const VULKAN_VIDEO_CODEC_AV1_DECODE_SPEC_VERSION  = VULKAN_VIDEO_CODEC_AV1_DECODE_API_VERSION_1_0_0;
const VULKAN_VIDEO_CODEC_AV1_ENCODE_SPEC_VERSION  = VULKAN_VIDEO_CODEC_AV1_ENCODE_API_VERSION_1_0_0;
const VULKAN_VIDEO_CODEC_H264_ENCODE_SPEC_VERSION = VULKAN_VIDEO_CODEC_H264_ENCODE_API_VERSION_1_0_0;
const VULKAN_VIDEO_CODEC_H264_DECODE_SPEC_VERSION = VULKAN_VIDEO_CODEC_H264_DECODE_API_VERSION_1_0_0;
const VULKAN_VIDEO_CODEC_H265_DECODE_SPEC_VERSION = VULKAN_VIDEO_CODEC_H265_DECODE_API_VERSION_1_0_0;
const VULKAN_VIDEO_CODEC_H265_ENCODE_SPEC_VERSION = VULKAN_VIDEO_CODEC_H265_ENCODE_API_VERSION_1_0_0;

"""[1::])
    parse_constants(f)
    parse_handles_def(f)
    f.write("\n\n")
    parse_flags_def(f)
with open("../enums.c3i", 'w', encoding='utf-8') as f:
    f.write(BASE)
    f.write("\n")
    parse_enums(f)
    parse_fake_enums(f)
    f.write("\n\n")
with open("../structs.c3i", 'w', encoding='utf-8') as f:
    f.write(BASE)
    f.write("""
import std::core::cinterop;
import std::os::win32;
distinct Win32_HINSTANCE            @if(!env::WIN32) = any;
distinct Win32_HANDLE               @if(!env::WIN32) = any;
distinct Win32_HWND                 @if(!env::WIN32) = Win32_HANDLE;
distinct Win32_HMONITOR             @if(!env::WIN32) = Win32_HANDLE;
distinct Win32_LPCWSTR              @if(!env::WIN32) = short;
distinct Win32_SECURITY_ATTRIBUTES  @if(!env::WIN32) = any;
distinct Win32_DWORD                @if(!env::WIN32) = uint;
distinct Win32_LONG                 @if(!env::WIN32) = int;
distinct Win32_LUID                 @if(!env::WIN32) = any;

/* @if(xlib.IS_SUPPORTED) {
def XlibDisplay  = xlib.Display;
def XlibWindow   = xlib.Window;
def XlibVisualID = xlib.VisualID;
}
*/
distinct XlibDisplay  = any; // Opaque struct defined by Xlib
distinct XlibWindow   = CULong;
distinct XlibVisualID = CULong;

distinct XCBVisualID  = uint;
distinct XCBWindow    = uint;
distinct CAMetalLayer = any;

distinct MTLBuffer_id       = any;
distinct MTLTexture_id      = any;
distinct MTLSharedEvent_id  = any;
distinct MTLDevice_id       = any;
distinct MTLCommandQueue_id = any;

/********************************/
""")
    f.write("\n")
    parse_structs(f)
    f.write("\n\n")

with open("../procedures.c3i", 'w', encoding='utf-8') as f:
    f.write(BASE)
    f.write("\n")
    parse_procedures(f)
    group_functions()
    make_function_declarations(f)
    f.write("\n")
with open("../function-loader.c3", 'w', encoding='utf-8') as f:
    f.write(BASE)
    f.write("\n")
    make_proc_loader(f)
    f.write("\n")
