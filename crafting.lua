
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
  steel_bar = "basic_materials:steel_bar",
  copper_wire = "basic_materials:copper_wire",
  empty_spool = "basic_materials:empty_spool",
  controller = "basic_materials:ic",
  
  gear = "basic_materials:gear_steel",
  electric_motor = "basic_materials:motor",
  transformer = "basic_materials:gold_wire",
  
  magnet = "default:mese_crystal_fragment",
  glow_crystal = "default:mese_crystal_fragment",
  
  dye_yellow = "dye:yellow",
  
  valve = "pipeworks:valve_off_empty",
  rubber = "mesecons_materials:fiber",
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
  items.metal_block = "technic:carbon_steel_block"
  items.controller = "technic:control_logic_unit"
  
  items.transformer = "technic:lv_transformer"
  
  items.rubber = "technic:rubber"
  
  items.steel_bar = "basic_materials:carbon_steel_bar"
end

if minetest.get_modpath("hades_technic") then
  items.strong_ingot = "hades_technic:stainless_steel_ingot"
  items.metal_ingot = "hades_technic:carbon_steel_ingot"
  items.metal_block = "hades_technic:carbon_steel_block"
  items.controller = "hades_technic:control_logic_unit"
  
  items.transformer = "hades_technic:lv_transformer"
  
  items.rubber = "hades_technic:rubber"
  
  items.steel_bar = "basic_materials:carbon_steel_bar"
end

if minetest.get_modpath("elepower_dynamics") then
  items.valve = "elepower_dynamics:servo_valve"
end

if minetest.get_modpath("techage") then
  items.valve = "techage:ta3_valve_open"
end

local adaptation = power_generators.adaptation

minetest.register_craft({
    output = "power_generators:electric_cableS 6",
    recipe = {
      {adaptation.plastic_sheet.name, adaptation.dye_yellow.name, ""},
      {"", adaptation.copper_wire.name, ""},
      {"", "", adaptation.plastic_sheet.name},
    },
    replacements = {{adaptation.copper_wire.name, adaptation.empty_spool.name}},
  })

minetest.register_craft({
    output = "power_generators:junction_box",
    recipe = {
      {"power_generators:electric_cableS", "power_generators:electric_cableS", "power_generators:electric_cableS"},
      {adaptation.plastic_sheet.name, adaptation.metal_block.name, adaptation.plastic_sheet.name},
      {adaptation.transformer.name, adaptation.transformer.name, adaptation.transformer.name},
    },
    replacements = {{adaptation.copper_wire.name,adaptation.empty_spool.name}},
  })

minetest.register_craft({
    output = "power_generators:power_meter",
    recipe = {
      {"power_generators:electric_cableS", "power_generators:electric_cableS", "power_generators:electric_cableS"},
      {adaptation.plastic_sheet.name, adaptation.plastic_strip.name, adaptation.plastic_sheet.name},
      {adaptation.transformer.name, adaptation.metal_block.name, adaptation.magnet.name},
    },
    replacements = {{adaptation.copper_wire.name,adaptation.empty_spool.name}},
  })

minetest.register_craft({
    output = "power_generators:charger",
    recipe = {
      {"power_generators:electric_cableS", "power_generators:electric_cableS", "power_generators:electric_cableS"},
      {adaptation.plastic_sheet.name, adaptation.metal_block.name, adaptation.plastic_sheet.name},
      {adaptation.transformer.name, adaptation.controller.name, adaptation.copper_wire.name},
    },
    replacements = {
      {adaptation.copper_wire.name,adaptation.empty_spool.name},
      {adaptation.copper_wire.name,adaptation.empty_spool.name},
    },
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_piston",
    recipe = {
      {adaptation.strong_ingot.name, adaptation.strong_ingot.name, adaptation.strong_ingot.name},
      {"", adaptation.strong_ingot.name, ""},
      {"", adaptation.strong_ingot.name, ""},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_cylinder_body",
    recipe = {
      {adaptation.strong_ingot.name, "", adaptation.strong_ingot.name},
      {adaptation.strong_ingot.name, "", adaptation.strong_ingot.name},
      {adaptation.strong_ingot.name, adaptation.strong_ingot.name, adaptation.strong_ingot.name},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_crankshaft 2",
    recipe = {
      {"", adaptation.strong_ingot.name, adaptation.strong_ingot.name},
      {"", adaptation.strong_ingot.name, ""},
      {adaptation.strong_ingot.name, adaptation.strong_ingot.name, ""},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_spark_plug",
    recipe = {
      {adaptation.copper_ingot.name, adaptation.copper_wire.name, adaptation.copper_ingot.name},
      {"", adaptation.mese_fragment.name, ""},
    },
    replacements = {{adaptation.copper_wire.name,adaptation.empty_spool.name}},
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_2",
    recipe = {
      {"power_generators:combustion_engine_spark_plug", adaptation.metal_ingot.name, "power_generators:combustion_engine_spark_plug"},
      {"power_generators:combustion_engine_piston", "", "power_generators:combustion_engine_piston"},
      {"power_generators:combustion_engine_cylinder_body", "power_generators:combustion_engine_crankshaft", "power_generators:combustion_engine_cylinder_body"},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_2_controlled",
    recipe = {
      {"power_generators:combustion_engine_spark_plug", adaptation.metal_ingot.name, "power_generators:combustion_engine_spark_plug"},
      {"power_generators:combustion_engine_piston", adaptation.controller.name, "power_generators:combustion_engine_piston"},
      {"power_generators:combustion_engine_cylinder_body", "power_generators:combustion_engine_crankshaft", "power_generators:combustion_engine_cylinder_body"},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_4",
    recipe = {
      {adaptation.metal_ingot.name, adaptation.metal_ingot.name},
      {"power_generators:combustion_engine_body_2","power_generators:combustion_engine_body_2"},
      {"power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft"},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_6",
    recipe = {
      {adaptation.metal_ingot.name, adaptation.metal_ingot.name, adaptation.metal_ingot.name},
      {"power_generators:combustion_engine_body_2","power_generators:combustion_engine_body_2", "power_generators:combustion_engine_body_2"},
      {"power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft"},
    }
  })


--[[
minetest.register_craft({
    output = "power_generators:combustion_engine_body_8",
    recipe = {
      {adaptation.metal_ingot, adaptation.metal_ingot},
      {"power_generators:combustion_engine_body_4","power_generators:combustion_engine_body_4"},
      {"power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft"},
    }
  })
--]]

minetest.register_craft({
    output = "power_generators:combustion_engine_two_cylinders",
    recipe = {
      {adaptation.metal_ingot.name, "", adaptation.metal_ingot.name},
      {adaptation.copper_wire.name, "power_generators:combustion_engine_body_2", adaptation.copper_wire.name},
      {adaptation.metal_ingot.name, "power_generators:shaft", adaptation.metal_ingot.name},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_two_cylinders_controlled",
    recipe = {
      {adaptation.metal_ingot.name, adaptation.controller.name, adaptation.metal_ingot.name},
      {adaptation.copper_wire.name, "power_generators:combustion_engine_body_2_controlled", adaptation.copper_wire.name},
      {adaptation.metal_ingot.name, "power_generators:shaft", adaptation.metal_ingot.name},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_six_cylinders",
    recipe = {
      {adaptation.metal_ingot.name, "", adaptation.metal_ingot.name},
      {adaptation.copper_wire.name, "power_generators:combustion_engine_body_6", adaptation.copper_wire.name},
      {adaptation.metal_ingot.name, "power_generators:shaft", adaptation.metal_ingot.name},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_gearbox",
    recipe = {
      {adaptation.metal_ingot.name, adaptation.gear.name, adaptation.metal_ingot.name},
      {adaptation.metal_ingot.name, adaptation.gear.name, adaptation.metal_ingot.name},
      {adaptation.metal_ingot.name, adaptation.gear.name, adaptation.metal_ingot.name},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_alternator",
    recipe = {
      {"", adaptation.transformer.name, ""},
      {"", adaptation.electric_motor.name, ""},
      {adaptation.metal_ingot.name, "", adaptation.metal_ingot.name},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_fuel_tank",
    recipe = {
      {adaptation.metal_ingot.name, adaptation.metal_ingot.name, adaptation.metal_ingot.name},
      {adaptation.metal_ingot.name, "", adaptation.metal_ingot.name},
      {adaptation.metal_ingot.name, adaptation.metal_ingot.name, adaptation.metal_ingot.name},
    }
  })

minetest.register_craft({
    output = "power_generators:emergency_generator",
    recipe = {
      {adaptation.metal_ingot.name, "power_generators:combustion_engine_fuel_tank", adaptation.metal_ingot.name},
      {"power_generators:combustion_engine_two_cylinders", "power_generators:combustion_engine_gearbox", "power_generators:combustion_engine_alternator"},
      {adaptation.metal_ingot.name, "", adaptation.metal_ingot.name},
    },
  })

minetest.register_craft({
    output = "power_generators:emergency_generator_2",
    recipe = {
      {adaptation.metal_ingot.name, "power_generators:combustion_engine_fuel_tank", adaptation.metal_ingot.name},
      {"power_generators:combustion_engine_two_cylinders_controlled", "power_generators:combustion_engine_gearbox", "power_generators:combustion_engine_alternator"},
      {adaptation.metal_ingot.name, "", adaptation.metal_ingot.name},
    },
  })

minetest.register_craft({
    output = "power_generators:alternator",
    recipe = {
      {"power_generators:framework",adaptation.iron_ingot.name,"power_generators:electric_cableS"},
      {adaptation.iron_ingot.name,"power_generators:electric_engine_p24",adaptation.iron_ingot.name},
      {adaptation.transformer.name,adaptation.iron_ingot.name, adaptation.transformer.name},
    }
  })

if adaptation.rubber then
  minetest.register_craft({
      output = "power_generators:fuel_hosepipe",
      recipe = {
        {"",adaptation.rubber.name,""},
        {adaptation.rubber.name,"",adaptation.rubber.name},
        {"",adaptation.rubber.name,""},
      }
    })

  minetest.register_craft({
      output = "power_generators:fuel_tank",
      recipe = {
        {"","power_generators:combustion_engine_fuel_tank",adaptation.rubber.name},
        {"power_generators:combustion_engine_fuel_tank","power_generators:framework","power_generators:combustion_engine_fuel_tank"},
        {"","power_generators:combustion_engine_fuel_tank","power_generators:fuel_hosepipe"},
      }
    })
end

minetest.register_craft({
    output = "power_generators:gearbox",
    recipe = {
      {adaptation.steel_strip.name,adaptation.steel_strip.name,"power_generators:combustion_engine_gearbox"},
      {adaptation.steel_strip.name,"power_generators:framework","power_generators:shaft"},
      {"power_generators:combustion_engine_gearbox","power_generators:shaft","power_generators:combustion_engine_gearbox"},
    }
  })

minetest.register_craft({
    output = "power_generators:starter_manual",
    recipe = {
      {adaptation.steel_bar.name,adaptation.steel_strip.name,adaptation.steel_bar.name},
      {adaptation.steel_strip.name,"power_generators:framework","power_generators:shaft"},
      {"power_generators:combustion_engine_gearbox","power_generators:shaft","power_generators:combustion_engine_gearbox"},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_6c",
    recipe = {
      {"power_generators:framework","power_generators:fuel_hosepipe"},
      {adaptation.steel_strip.name,adaptation.valve.name},
      {"power_generators:shaft","power_generators:combustion_engine_six_cylinders"},
    }
  })

--[[
minetest.register_craft({
    output = "power_generators:combustion_engine_8c",
    recipe = {
      {"power_generators:framework","power_generators:fuel_hosepipe"},
      {adaptation.steel_strip,adaptation.steel_strip},
      {"power_generators:shaft","power_generators:combustion_engine_eight_cylinders"},
    }
  })
--]]

minetest.register_craft({
    output = "power_generators:shaft 3",
    recipe = {
      {adaptation.strong_ingot.name,},
      {adaptation.strong_ingot.name,},
      {adaptation.strong_ingot.name,},
    }
  })

minetest.register_craft({
    output = "power_generators:framework_base",
    recipe = {
      {"",adaptation.steel_bar.name,""},
      {adaptation.steel_bar.name,"", adaptation.steel_bar.name},
      {"",adaptation.steel_bar.name,""},
    }
  })

minetest.register_craft({
    type = "shapeless",
    output = "power_generators:framework",
    recipe = {
      adaptation.steel_bar.name,
      adaptation.steel_bar.name,
      adaptation.steel_bar.name,
      adaptation.steel_bar.name,
      "power_generators:framework_base",
      "power_generators:framework_base",
      adaptation.steel_bar.name,
    }
  })

minetest.register_craft({
    output = "power_generators:block_of_3coils",
    recipe = {
      {adaptation.copper_wire.name,adaptation.copper_wire.name,adaptation.copper_wire.name},
      {adaptation.plastic_strip.name,adaptation.plastic_strip.name,adaptation.plastic_strip.name},
    },
    replacements = {
      {adaptation.copper_wire.name,adaptation.empty_spool.name},
      {adaptation.copper_wire.name,adaptation.empty_spool.name},
      {adaptation.copper_wire.name,adaptation.empty_spool.name}},
  })

minetest.register_craft({
    output = "power_generators:block_of_3magnets",
    recipe = {
      {adaptation.magnet.name,adaptation.magnet.name,adaptation.magnet.name},
      {adaptation.plastic_strip.name,adaptation.plastic_strip.name,adaptation.plastic_strip.name},
    },
  })

minetest.register_craft({
    output = "power_generators:electric_engine_p6",
    recipe = {
      {adaptation.steel_strip.name,"power_generators:block_of_3coils",adaptation.steel_strip.name},
      {"power_generators:block_of_3magnets","power_generators:shaft", "power_generators:block_of_3magnets"},
      {adaptation.steel_strip.name,"power_generators:block_of_3coils",adaptation.steel_strip.name},
    }
  })

minetest.register_craft({
    output = "power_generators:block_of_6coils",
    recipe = {
      {adaptation.copper_wire.name,adaptation.copper_wire.name,adaptation.copper_wire.name},
      {adaptation.plastic_strip.name,adaptation.plastic_strip.name,adaptation.plastic_strip.name},
      {adaptation.copper_wire.name,adaptation.copper_wire.name,adaptation.copper_wire.name},
    },
    replacements = {
      {adaptation.copper_wire.name,adaptation.empty_spool.name},
      {adaptation.copper_wire.name,adaptation.empty_spool.name},
      {adaptation.copper_wire.name,adaptation.empty_spool.name},
      {adaptation.copper_wire.name,adaptation.empty_spool.name},
      {adaptation.copper_wire.name,adaptation.empty_spool.name},
      {adaptation.copper_wire.name,adaptation.empty_spool.name}},
  })

minetest.register_craft({
    output = "power_generators:block_of_6magnets",
    recipe = {
      {adaptation.magnet.name,adaptation.magnet.name,adaptation.magnet.name},
      {adaptation.plastic_strip.name,adaptation.plastic_strip.name,adaptation.plastic_strip.name},
      {adaptation.magnet.name,adaptation.magnet.name,adaptation.magnet.name},
    },
  })

minetest.register_craft({
    output = "power_generators:electric_engine_p12",
    recipe = {
      {adaptation.steel_strip.name,"power_generators:block_of_6coils",adaptation.steel_strip.name},
      {"power_generators:block_of_6magnets","power_generators:shaft", "power_generators:block_of_6magnets"},
      {adaptation.steel_strip.name,"power_generators:block_of_6coils",adaptation.steel_strip.name},
    }
  })

minetest.register_craft({
    output = "power_generators:block_of_12coils",
    recipe = {
      {"power_generators:block_of_6coils",adaptation.plastic_strip.name,"power_generators:block_of_6coils"},
    },
  })

minetest.register_craft({
    output = "power_generators:block_of_12magnets",
    recipe = {
      {"power_generators:block_of_6magnets",adaptation.plastic_strip.name,"power_generators:block_of_6magnets"},
    },
  })

minetest.register_craft({
    output = "power_generators:electric_engine_p24",
    recipe = {
      {adaptation.steel_strip.name,"power_generators:block_of_12coils",adaptation.steel_strip.name},
      {"power_generators:block_of_12magnets","power_generators:shaft", "power_generators:block_of_12magnets"},
      {adaptation.steel_strip.name,"power_generators:block_of_12coils",adaptation.steel_strip.name},
    }
  })

minetest.register_craft({
    output = "power_generators:electric_engine_200",
    recipe = {
      {"power_generators:framework",adaptation.iron_ingot.name,"power_generators:electric_cableS"},
      {adaptation.iron_ingot.name,"power_generators:electric_engine_p6",adaptation.iron_ingot.name},
      {"",adaptation.iron_ingot.name,""},
    }
  })

minetest.register_craft({
    output = "power_generators:electric_engine_400",
    recipe = {
      {"power_generators:framework",adaptation.iron_ingot.name,"power_generators:electric_cableS"},
      {adaptation.iron_ingot.name,"power_generators:electric_engine_p12",adaptation.iron_ingot.name},
      {"",adaptation.iron_ingot.name,""},
    }
  })

minetest.register_craft({
    output = "power_generators:electric_engine_800",
    recipe = {
      {"power_generators:framework",adaptation.iron_ingot.name,"power_generators:electric_cableS"},
      {adaptation.iron_ingot.name,"power_generators:electric_engine_p24",adaptation.iron_ingot.name},
      {"",adaptation.iron_ingot.name,""},
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
      {"power_generators:framework",adaptation.iron_ingot.name,"power_generators:shaft"},
      {adaptation.iron_ingot.name,"power_generators:shaft",adaptation.iron_ingot.name},
      {adaptation.gear.name,adaptation.iron_ingot.name,adaptation.gear.name},
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_horTop",
    recipe = {
      {"power_generators:framework",adaptation.iron_ingot.name,adaptation.gear.name},
      {adaptation.iron_ingot.name,"power_generators:shaft",adaptation.iron_ingot.name},
      {adaptation.gear.name,adaptation.iron_ingot.name,"power_generators:shaft"},
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_verFront",
    recipe = {
      {adaptation.gear.name,adaptation.iron_ingot.name,"power_generators:shaft"},
      {adaptation.iron_ingot.name,"power_generators:shaft",adaptation.iron_ingot.name},
      {"power_generators:framework",adaptation.iron_ingot.name,adaptation.gear.name},
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_switch",
    recipe = {
      {"power_generators:framework",adaptation.iron_ingot.name,adaptation.steel_bar.name},
      {adaptation.iron_ingot.name,"power_generators:shaft",adaptation.iron_ingot.name},
      {adaptation.gear.name,adaptation.iron_ingot.name,adaptation.gear.name},
    }
  })

minetest.register_craft({
    output = "power_generators:shaft_gearbox",
    recipe = {
      {"power_generators:framework",adaptation.iron_ingot.name,adaptation.gear.name},
      {adaptation.iron_ingot.name,"power_generators:shaft",adaptation.iron_ingot.name},
      {adaptation.gear.name,adaptation.iron_ingot.name,adaptation.gear.name},
    }
  })

minetest.register_craft({
    output = "power_generators:rpm_meter",
    recipe = {
      {"power_generators:framework",adaptation.controller.name,"power_generators:electric_cableS"},
      {adaptation.glow_crystal.name,"",adaptation.mese_fragment.name},
      {adaptation.iron_ingot.name,"power_generators:shaft",adaptation.iron_ingot.name},
    }
  })

minetest.register_craft({
    output = "power_generators:rpm_meter_watt",
    recipe = {
      {adaptation.steel_bar.name,"",adaptation.steel_bar.name},
      {adaptation.string.name,"power_generators:shaft",adaptation.plastic_sheet.name},
      {adaptation.steel_bar.name,"",adaptation.steel_bar.name},
    }
  })

