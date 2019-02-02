def make_cc_options(copts=[], linkopts=[], deps=[]):
    return {
        "copts": copts,
        "linkopts": linkopts,
        "deps": deps,
    }

def conditional_cc_options_add(condition, options, copts=[], linkopts=[], deps=[]):
    if condition:
        return {
            "copts": options["copts"] + copts,
            "linkopts": options["linkopts"] + linkopts,
            "deps": options["deps"] + deps,
        }
    return options
