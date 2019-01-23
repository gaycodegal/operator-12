def make_cc_options(copts=[], linkopts=[], deps=[]):
    return {
        "copts": copts,
        "linkopts": linkopts,
        "deps": deps,
    }

def conditional_cc_options_add(condition, options, copts=[], linkopts=[], deps=[]):
    if condition:
        if len(copts) > 0:
            options["copts"] += copts
        if len(linkopts) > 0:
            options["linkopts"] += linkopts
        if len(deps) > 0:
            options["deps"] += deps
