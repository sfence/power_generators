
local S = power_generators.translator

if minetest.get_modpath("technic") or minetest.get_modpath("hades_technic") then
  minetest.register_craftitem("power_generators:carbon_steel_bar", {
      description = S("Carbon Steel Bar"),
      inventory_image = "power_generators_carbon_steel_bar.png",
    })
else
  if minetest.get_modpath("basic_materials") then
    minetest.register_alias("power_generators:carbon_steel_bar", "basic_materials:steel_bar")
  end
end

minetest.register_craftitem("power_generators:framework_base", {
    description = S("Framework Base"),
    inventory_image = "power_generators_framework_base.png",
  })

