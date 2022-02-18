
local S = power_generators.translator

minetest.register_craftitem("power_generators:combustion_engine_piston", {
    description = S("Combustion Engine Piston"),
    inventory_image = "power_generators_combustion_engine_piston.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_cylinder_body", {
    description = S("Combustion Engine Cylinder Body"),
    inventory_image = "power_generators_combustion_engine_cylinder.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_crankshaft", {
    description = S("Combustion Engine Crankshaft"),
    inventory_image = "power_generators_combustion_engine_crankshaft.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_spark_plug", {
    description = S("Combustion Engine Spark"),
    inventory_image = "power_generators_combustion_engine_spark.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_body_2", {
    description = S("Combustion Engine Body 2 Without Controller"),
    inventory_image = "power_generators_combustion_engine_body_2.png",
  })
minetest.register_craftitem("power_generators:combustion_engine_body_2_controlled", {
    description = S("Combustion Engine Body 2"),
    inventory_image = "power_generators_combustion_engine_body_2.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_body_4", {
    description = S("Combustion Engine Body 4"),
    inventory_image = "power_generators_combustion_engine_body_4.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_body_6", {
    description = S("Combustion Engine Body 6"),
    inventory_image = "power_generators_combustion_engine_body_6.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_two_cylinders", {
    description = S("Combustion Engine Two Cylinders Without Controller"),
    inventory_image = "power_generators_combustion_engine_two_cylinders.png",
  })
minetest.register_craftitem("power_generators:combustion_engine_two_cylinders_controlled", {
    description = S("Combustion Engine Two Cylinders"),
    inventory_image = "power_generators_combustion_engine_two_cylinders.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_gearbox", {
    description = S("Combustion Engine Gearbox"),
    inventory_image = "power_generators_combustion_engine_gearbox.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_alternator", {
    description = S("Combustion Engine Alternator"),
    inventory_image = "power_generators_combustion_engine_alternator.png",
  })

minetest.register_craftitem("power_generators:combustion_engine_fuel_tank", {
    description = S("Combustion Engine Fuel Tank"),
    inventory_image = "power_generators_combustion_engine_fuel_tank.png",
  })

--[[
minetest.register_craftitem("power_generators:combustion_engine_", {
    description = S("Combustion Engine "),
    inventory_image = "power_generators_combustion_engine_.png",
  })
--]]

if minetest.get_modpath("technic") or minetest.get_modpath("hades_technic") then
  minetest.register_craftitem("power_generators:carbon_steel_bar", {
      description = S("Carbon Steel Bar"),
      inventory_image = "power_generators_carbon_steel_bar.png",
    })
else
  if minetest.get_modpath("basic_materials") then
    minetest.register_alias("power_generators:carbon_steel_bar", "basic_materials:steel_bar")
  else
    minetest.register_alias("power_generators:carbon_steel_bar", "hades_extramaterials:steel_bar")
  end
end

minetest.register_craftitem("power_generators:framework_base", {
    description = S("Framework Base"),
    inventory_image = "power_generators_framework_base.png",
  })

