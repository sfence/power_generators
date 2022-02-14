
local S = power_generators.translator

local node_sounds = nil
if minetest.get_modpath("default") then
  node_sounds = default.node_sound_metal_defaults()
end
if minetest.get_modpath("hades_sounds") then
  node_sounds = hades_sounds.node_sound_metal_defaults()
end
if minetest.get_modpath("sounds") then
  node_sounds = sounds.node_metal()
end  

minetest.register_node("power_generators:framework", {
  description = S("Framework"),
  tiles = {
    "power_generators_frame_steel.png",
  },
  
  paramtype2 = "facedir",
  paramtype = "light",
  drawtype = "mesh",
  mesh = "power_generators_frame.obj",
  sunlight_propagates = true,
  is_ground_content = false,
  groups = {snappy = 2, choppy = 2},
  sounds = node_sounds,
})

