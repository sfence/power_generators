
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

if minetest.get_modpath("farming") then
  if minetest.registered_items["farming:hemp_oil"] then
    minetest.override_item("farming:hemp_oil", {
        _agrease = 1,
        _qgrease = 0.5,
        on_use = power_generators.apply_grease,
      })
  end
end

if minetest.get_modpath("hades_extrafarming") then
  minetest.override_item("hades_extrafarming:hemp_oil", {
      _agrease = 1,
      _qgrease = 0.5,
      on_use = power_generators.apply_grease,
    })
end
