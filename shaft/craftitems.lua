
local S = power_generators.translator

minetest.register_craftitem("power_generators:shaft", {
    description = S("Shaft"),
    inventory_image = "power_generators_shaft_inv.png",
  })

minetest.register_craftitem("power_generators:block_of_3coils", {
    description = S("Block of 3 Coils"),
    inventory_image = "power_generators_block_of_3coild.png",
  })

minetest.register_craftitem("power_generators:block_of_3magnets", {
    description = S("Block of 3 Magnets"),
    inventory_image = "power_generators_block_of_3magnets.png",
  })

minetest.register_craftitem("power_generators:electric_engine_p6", {
    description = S("Electric Motor (9 coils and magnets)"),
    inventory_image = "power_generators_electric_engine_p6.png",
  })

