---------------------
---- LAYER RULES ----
---------------------

-- See https://wiki.hypr.land/configuring/core/rules/layer-rules/

-- SwayNC Blur Rules
hl.layer_rule({
    name = "blur-swaync",
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "blur-swaync-notifs",
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0.5,
})
