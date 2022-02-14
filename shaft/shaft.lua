
local S = power_generators.translator

minetest.register_node("power_generators:shaft_hor", {
    description = S("Shaft"),
    drawtype = "mesh",
    mesh = "power_generators_shaft.obj",
    tiles = {"power_generators_frame_steel.png", "power_generators_shaft_steel.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 1, shaft = 2},
    _shaft_sides = {"front","back"},
    
    on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_float("front_ratio", 1)
      meta:set_float("back_ratio", 1)
      meta:set_float("I", 1)
    end,
  })

minetest.register_node("power_generators:shaft_ver", {
    description = S("Shaft"),
    drawtype = "mesh",
    mesh = "power_generators_shaft_ver.obj",
    tiles = {"power_generators_frame_steel.png", "power_generators_shaft_steel.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 1, shaft = 2},
    _shaft_sides = {"bottom","top"},
    
    on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_float("front_ratio", 1)
      meta:set_float("back_ratio", 1)
      meta:set_float("I", 2)
    end,
  })

