
if minetest.get_modpath("basic_materials") then
  minetest.override_item("basic_materials:gear_steel", {
      groups = {shaft_gear = 1},
    })
end
if minetest.get_modpath("hades_extramaterials") then
  minetest.override_item("hades_extramaterials:gear_steel", {
      groups = {shaft_gear = 1},
    })
end
