
power_generators = {
  translator = minetest.get_translator("power_generators")
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/power_supply.lua")

appliances.register_craft_type("power_generators_fuel", {
    description = "Generator fuel",
    width = 1,
    height = 1,
  })

dofile(modpath.."/emergency_generator.lua")

dofile(modpath.."/craftitems.lua")
dofile(modpath.."/crafting.lua")

