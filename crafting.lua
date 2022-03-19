
local items = {
  iron_ingot = "default:steel_ingot",
  strong_ingot = "default:steel_ingot",
  metal_ingot = "default:steel_ingot",
  copper_ingot = "default:copper_ingot",
  mese_fragment = "default:mese_crystal_fragment",
  metal_block = "default:steelblock",
  string = "farming:string",
  
  plastic_sheet = "basic_materials:plastic_sheet",
  plastic_strip = "basic_materials:plastic_strip",
  steel_strip = "basic_materials:steel_strip",
  copper_wire = "basic_materials:copper_wire",
  empty_spool = "basic_materials:empty_spool",
  controller = "basic_materials:ic",
  
  gear = "basic_materials:gear_steel",
  electric_motor = "basic_materials:motor",
  transformer = "basic_materials:gold_wire",
  
  magnet = "default:mese_crystal_fragment",
  glow_crystal = "default:mese_crystal_fragment",
  
  dye_yellow = "dye:yellow",
}

if minetest.get_modpath("hades_core") then
  items.iron_ingot = "hades_core:steel_ingot"
  items.strong_ingot = "hades_core:steel_ingot"
  items.metal_ingot = "hades_core:steel_ingot"
  items.copper_ingot = "hades_core:copper_ingot"
  items.mese_fragment = "hades_core:mese_crystal_fragment"
  items.metal_block = "hades_core:steelblock"
  items.string = "hades_farming:cotton"
  
  items.plastic_sheet = "hades_extramaterials:plastic_sheet"
  items.plastic_strip = "hades_extramaterials:plastic_strip"
  items.steel_strip = "hades_extramaterials:steel_strip"
  items.copper_wire = "hades_extramaterials:copper_wire"
  items.empty_spool = "hades_extramaterials:empty_spool"
  items.controller = "hades_extramaterials:ic"
  
  items.gear = "hades_extramaterials:gear_steel"
  items.electric_motor = "hades_extramaterials:motor"
  items.transformer = "hades_extramaterials:gold_wire"
  
  items.magnet = "hades_core:mese_crystal_fragment"
  items.glow_crystal = "glowcrystals:glowcrystal"
end

if minetest.get_modpath("technic") then
  items.strong_ingot = "technic:stainless_steel_ingot"
  items.metal_ingot = "technic:carbon_steel_ingot"
  items.metal_block = "technic:carbon_steel_ingot"
  items.controller = "technic:control_logic_unit"
  
  items.transformer = "technic:lv_transformer"
end

if minetest.get_modpath("hades_technic") then
  items.strong_ingot = "hades_technic:stainless_steel_ingot"
  items.metal_ingot = "hades_technic:carbon_steel_ingot"
  items.metal_block = "hades_technic:carbon_steel_ingot"
  items.controller = "hades_technic:control_logic_unit"
  
  items.transformer = "hades_technic:lv_transformer"
end

minetest.register_craft({
    output = "power_generators:electric_cableS 6",
    recipe = {
      {items.plastic_sheet, items.dye_yellow, ""},
      {"", items.copper_wire, ""},
      {"", "", items.plastic_sheet},
    },
    replacements = {{items.copper_wire, items.empty_spool}},
  })

minetest.register_craft({
    output = "power_generators:junction_box",
    recipe = {
      {"power_generators:electric_cableS", "power_generators:electric_cableS", "power_generators:electric_cableS"},
      {items.plastic_sheet, items.metal_block, items.plastic_sheet},
      {items.transformer, items.transformer, items.transformer},
    },
    replacements = {{items.copper_wire,items.empty_spool}},
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_piston",
    recipe = {
      {items.strong_ingot, items.strong_ingot, items.strong_ingot},
      {"", items.strong_ingot, ""},
      {"", items.strong_ingot, ""},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_cylinder_body",
    recipe = {
      {items.strong_ingot, "", items.strong_ingot},
      {items.strong_ingot, "", items.strong_ingot},
      {items.strong_ingot, items.strong_ingot, items.strong_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_crankshaft 2",
    recipe = {
      {"", items.strong_ingot, items.strong_ingot},
      {"", items.strong_ingot, ""},
      {items.strong_ingot, items.strong_ingot, ""},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_spark_plug",
    recipe = {
      {items.copper_ingot, items.copper_wire, items.copper_ingot},
      {"", items.mese_fragment, ""},
    },
    replacements = {{items.copper_wire,items.empty_spool}},
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_2",
    recipe = {
      {"power_generators:combustion_engine_spark_plug", items.metal_ingot, "power_generators:combustion_engine_spark_plug"},
      {"power_generators:combustion_engine_piston", "", "power_generators:combustion_engine_piston"},
      {"power_generators:combustion_engine_cylinder_body", "power_generators:combustion_engine_crankshaft", "power_generators:combustion_engine_cylinder_body"},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_2_controlled",
    recipe = {
      {"power_generators:combustion_engine_spark_plug", items.metal_ingot, "power_generators:combustion_engine_spark_plug"},
      {"power_generators:combustion_engine_piston", items.controller, "power_generators:combustion_engine_piston"},
      {"power_generators:combustion_engine_cylinder_body", "power_generators:combustion_engine_crankshaft", "power_generators:combustion_engine_cylinder_body"},
    }
  })

--[[
minetest.register_craft({
    output = "power_generators:combustion_engine_body_4",
    recipe = {
      {items.metal_ingot, items.metal_ingot, items.metal_ingot},
      {"power_generators:combustion_engine_body_2","power_generators:combustion_engine_body_2"},
      {"power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft"},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_6",
    recipe = {
      {items.metal_ingot, items.metal_ingot, items.metal_ingot},
      {"power_generators:combustion_engine_body_2","power_generators:combustion_engine_body_2", "power_generators:combustion_engine_body_2"},
      {"power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft"},
    }
  })
--]]

minetest.register_craft({
    output = "power_generators:combustion_engine_two_cylinders",
    recipe = {
      {items.metal_ingot, "", items.metal_ingot},
      {items.copper_wire, "power_generators:combustion_engine_body_2", items.copper_wire},
      {items.metal_ingot, "power_generators:shaft", items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_two_cylinders_controlled",
    recipe = {
      {items.metal_ingot, items.controller, items.metal_ingot},
      {items.copper_wire, "power_generators:combustion_engine_body_2_controlled", items.copper_wire},
      {items.metal_ingot, "power_generators:shaft", items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_gearbox",
    recipe = {
      {items.metal_ingot, items.gear, items.metal_ingot},
      {items.metal_ingot, items.gear, items.metal_ingot},
      {items.metal_ingot, items.gear, items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_alternator",
    recipe = {
      {"", items.transformer, ""},
      {"", items.electric_motor, ""},
      {items.metal_ingot, "", items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_fuel_tank",
    recipe = {
      {items.metal_ingot, items.metal_ingot, items.metal_ingot},
      {items.metal_ingot, "", items.metal_ingot},
      {items.metal_ingot, items.metal_ingot, items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:emergency_generator",
    recipe = {
      {items.metal_ingot, "power_generators:combustion_engine_fuel_tank", items.metal_ingot},
      {"power_generators:combustion_engine_two_cylinders", "power_generators:combustion_engine_gearbox", "power_generators:combustion_engine_alternator"},
      {items.metal_ingot, "", items.metal_ingot},
    },
  })

minetest.register_craft({
    output = "power_generators:emergency_generator_2",
    recipe = {
      {items.metal_ingot, "power_generators:combustion_engine_fuel_tank", items.metal_ingot},
      {"power_generators:combustion_engine_two_cylinders_controlled", "power_generators:combustion_engine_gearbox", "power_generators:combustion_engine_alternator"},
      {items.metal_ingot, "", items.metal_ingot},
    },
  })

minetest.register_craft({
    output = "power_generators:shaft 3",
    recipe = {
      {items.strong_ingot,},
      {items.strong_ingot,},
      {items.strong_ingot,},
    }
  })

if minetest.get_modpath("technic") or minetest.get_modpath("hades_technic") then
  minetest.register_craft({
      output = "power_generators:carbon_steel_bar 6",
      recipe = {
        {"","",items.metal_ingot},
        {"",items.metal_ingot,""},
        {items.metal_ingot,"",""},
      }
    })
end

minetest.register_craft({
    output = "power_generators:framework_base",
    recipe = {
      {"","power_generators:carbon_steel_bar",""},
      {"power_generators:carbon_steel_bar","", "power_generators:carbon_steel_bar"},
      {"","power_generators:carbon_steel_bar",""},
    }
  })

minetest.register_craft({
    type = "shapeless",
    output = "power_generators:framework",
    recipe = {
      "power_generators:carbon_steel_bar",
      "power_generators:carbon_steel_bar",
      "power_generators:carbon_steel_bar",
      "power_generators:carbon_steel_bar",
      "power_generators:framework_base",
      "power_generators:framework_base",
      "power_generators:carbon_steel_bar",
    }
  })

minetest.register_craft({
    output = "power_generators:block_of_3coils",
    recipe = {
      {items.copper_wire,items.copper_wire,items.copper_wire},
      {items.plastic_strip,items.plastic_strip,items.plastic_strip},
    },
    replacements = {
      {items.copper_wire,items.empty_spool},
      {items.copper_wire,items.empty_spool},
      {items.copper_wire,items.empty_spool}},
  })

minetest.register_craft({
    output = "power_generators:block_of_3magnets",
    recipe = {
      {items.magnet,items.magnet,items.magnet},
      {items.plastic_strip,items.plastic_strip,items.plastic_strip},
    },
  })

minetest.register_craft({
    output = "power_generators:electric_engine_p6",
    recipe = {
      {items.steel_strip,"power_generators:block_of_3coils",items.steel_strip},
      {"power_generators:block_of_3magnets","power_generators:shaft", "power_generators:block_of_3magnets"},
      {items.steel_strip,"power_generators:block_of_3coils",items.steel_strip},
    }
  })

minetest.register_craft({
    output = "power_generators:block_of_6coils",
    recipe = {
      {items.copper_wire,items.copper_wire,items.copper_wire},
      {items.plastic_strip,items.plastic_strip,items.plastic_strip},
      {items.copper_wire,items.copper_wire,items.copper_wire},
    },
    replacements = {
      {items.copper_wire,items.empty_spool},
      {items.copper_wire,items.empty_spool},
      {items.copper_wire,items.empty_spool},
      {items.copper_wire,items.empty_spool},
      {items.copper_wire,items.empty_spool},
      {items.copper_wire,items.empty_spool}},
  })

minetest.register_craft({
    output = "power_generators:block_of_6magnets",
    recipe = {
      {items.magnet,items.magnet,items.magnet},
      {items.plastic_strip,items.plastic_strip,items.plastic_strip},
      {items.magnet,items.magnet,items.magnet},
    },
  })

minetest.register_craft({
    output = "power_generators:electric_engine_p12",
    recipe = {
      {items.steel_strip,"power_generators:block_of_6coils",items.steel_strip},
      {"power_generators:block_of_6magnets","power_generators:shaft", "power_generators:block_of_6magnets"},
      {items.steel_strip,"power_generators:block_of_6coils",items.steel_strip},
    }
  })

minetest.register_craft({
    output = "power_generators:block_of_12coils",
    recipe = {
      {"power_generators:block_of_6coils",items.plastic_strip,"power_generators:block_of_6coils"},
    },
  })

minetest.register_craft({
    output = "power_generators:block_of_12magnets",
    recipe = {
      {"power_generators:block_of_6magnets",items.plastic_strip,"power_generators:block_of_6magnets"},
    },
  })

minetest.register_craft({
    output = "power_generators:electric_engine_p24",
    recipe = {
      {items.steel_strip,"power_generators:block_of_12coils",items.steel_strip},
      {"power_generators:block_of_12magnets","power_generators:shaft", "power_generators:block_of_12magnets"},
      {items.steel_strip,"power_generators:block_of_12coils",items.steel_strip},
    }
  })

minetest.register_craft({
    output = "power_generators:electric_engine_200",
    recipe = {
      {"power_generators:framework",items.iron_ingot,"power_generators:electric_cableS"},
      {items.iron_ingot,"power_generators:electric_engine_p6",items.iron_ingot},
      {"",items.iron_ingot,""},
    }
  })

minetest.register_craft({
    output = "power_generators:electric_engine_400",
    recipe = {
      {"power_generators:framework",items.iron_ingot,"power_generators:electric_cableS"},
      {items.iron_ingot,"power_generators:electric_engine_p12",items.iron_ingot},
      {"",items.iron_ingot,""},
    }
  })

minetest.register_craft({
    output = "power_generators:electric_engine_800",
    recipe = {
      {"power_generators:framework",items.iron_ingot,"power_generators:electric_cableS"},
      {items.iron_ingot,"power_generators:electric_engine_p24",items.iron_ingot},
      {"",items.iron_ingot,""},
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_hor",
    recipe = {
      {"power_generators:framework","power_generators:shaft"},
    }
  })
minetest.register_craft({
    output = "power_generators:shaft_ver",
    recipe = {
      {"power_generators:shaft"},
      {"power_generators:framework",}
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_horLeft",
    recipe = {
      {"power_generators:framework",items.iron_ingot,"power_generators:shaft"},
      {items.iron_ingot,"power_generators:shaft",items.iron_ingot},
      {items.gear,items.iron_ingot,items.gear},
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_horTop",
    recipe = {
      {"power_generators:framework",items.iron_ingot,items.gear},
      {items.iron_ingot,"power_generators:shaft",items.iron_ingot},
      {items.gear,items.iron_ingot,"power_generators:shaft"},
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_verFront",
    recipe = {
      {items.gear,items.iron_ingot,"power_generators:shaft"},
      {items.iron_ingot,"power_generators:shaft",items.iron_ingot},
      {"power_generators:framework",items.iron_ingot,items.gear},
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_switch",
    recipe = {
      {"power_generators:framework",items.iron_ingot,"power_generators:carbon_steel_bar"},
      {items.iron_ingot,"power_generators:shaft",items.iron_ingot},
      {items.gear,items.iron_ingot,items.gear},
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_gearbox",
    recipe = {
      {"power_generators:framework",items.iron_ingot,items.gear},
      {items.iron_ingot,"power_generators:shaft",items.iron_ingot},
      {items.gear,items.iron_ingot,items.gear},
    }
  })

minetest.register_craft({
    output = "power_generators:rpm_meter",
    recipe = {
      {"power_generators:framework",items.controller,"power_generators:electric_cableS"},
      {items.glow_crystal,"",items.mese_fragment},
      {items.iron_ingot,"power_generators:shaft",items.iron_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:rpm_meter_watt",
    recipe = {
      {"power_generators:carbon_steel_bar","","power_generators:carbon_steel_bar"},
      {items.string,"power_generators:shaft",items.plastic_sheet},
      {"power_generators:carbon_steel_bar","","power_generators:carbon_steel_bar"},
    }
  })

